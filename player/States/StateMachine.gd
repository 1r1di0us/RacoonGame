extends Node
class_name StateMachine

## Interface for a generic state machine. Initializes states and delegates engine callbacks (_process, _physics_process, _unhandled_input) to the active state node. Intended to be as reusable as possible.
# Has been changed a bit for Raccoon purposes

# Emitted when transitioning to a new state
signal state_changed(current_state)

# Path to the initial active state. We export this without setting it, as it must be set in the inspector or in the node extending this state machine interface, or the game will crash (so we don't forget to set it).
@export var initial_state := NodePath()

const PREVIOUS = "previous"

# Map holding the names and references of all the states within this particular state machine
var states_map = {}

# Stack for our pushdown automata implementation
var states_stack = []

# The current active state. At the start of the game, we begin at the initial state
@onready var current_state: State = get_node(initial_state)

func _ready():
	await owner.ready
	for child in get_children():
		# The state machine assigns itself to the State objects' state_machine property.
#		child.state_machine = self
		
		#In order to decouple the above code, we can instead have the state emit a signal when it finishes. That way, it does not even need to be aware of the state machine, or even the other states (only their names are hard coded). The 'finished' signal emitted by the state connects
		child.connect("finished", Callable(self, "_change_state"))
	states_stack.push_front(current_state)
	current_state = states_stack[0]
	current_state.enter()
	states_map = {"Idle": $Idle, "Run": $Run, "Crouch": $Crouch, "Crawl": $Crawl, "Jump": $Jump, "Freefall": $Freefall, "Roll": $Roll, "High_Jump": $High_Jump, "Launch": $Launch, "Freeball": $Freeball, "Tuck": $Tuck, "Pole_Climb": $Pole_Climb, "Pole_Clamber": $Pole_Clamber, "Wall_Climb": $Wall_Climb, "Wall_Clamber": $Wall_Clamber, "Splat": $Splat}

# The state machine subscribes to node callbacks and delegates them to the current state

func _unhandled_input(event):
	current_state.handle_input(event)

func _process(delta):
	current_state.update(delta)

func _physics_process(delta):
	current_state.physics_update(delta)

func _on_animation_finished(anim_name):
	current_state._on_animation_finished(anim_name)

# This function calls the current state's exit() function, then changes the active state and calls its enter() function.
# The optional 'msg' dictionary is passed to the next state's enter() function if needed for initialization
func _change_state(target_state_name, msg: Dictionary = {}) -> void:
	# Safety check, you could use an assert() here to report an error if the state name is incorrect.
	# We don't use an assert here to help with code reuse. If you reuse a state in different state machines
	# but you don't want them all, they won't be able to transition to states that aren't in the scene tree.
	if not states_map.has(target_state_name):
		print("no such state for value: " + str(target_state_name))
		return
#	print("current state: " + str(current_state))
	current_state.exit()
	
	if str(states_map[target_state_name]) == PREVIOUS:
		states_stack.pop_front()
	else:
		states_stack[0] = states_map[target_state_name]
	current_state = states_stack[0]
	emit_signal("state_changed", current_state)
	
	if str(states_map[target_state_name]) != PREVIOUS:
		current_state.enter(msg)
#	print("new state: " + str(current_state))
	
