extends Node
class_name State

# Virtual base class for all states, based on the GDQuest tutorial. Interface used to declare the functions called by the state machine of the active state.

# Reference to the state machine, to call its 'transition_to()' method directly.
#This is a bit unorthodox, as it defines the state having a relationship with a state machine, as in 'a state must have a state machine'.
# The state machine will assign itself to this variable in each of its states.
#var state_machine = null

# ALTERNATIVELY
# Instead of coupling the state to the state machine, the state can emit a signal indicating that it has ended and the state must now change to the state name provided with the signal.
#warning-ignore:unused_signal
signal finished(next_state_name)

# Virtual function to recieve events from the '_unhandled_input()' callback, from the state machine.
func handle_input(event: InputEvent) -> void:
	pass

# Virtual function corresponding to the '_process()' callback.
func update(delta: float) -> void:
	pass

# Virtual function corresponding to the '_physics_process()' callback.
func physics_update(delta: float) -> void:
	pass

# Virtual function called by the state machine upon changing the active state. msg is an optional dictionary with arbitrary data the state can use to initialize itself.
func enter(msg: Dictionary = {}) -> void:
	pass

# Virtual function called by the state machine before changing the active state, intended for use in cleaning up the state before changing it, if necessary.
func exit() -> void:
	pass

# Virtual function of the state connected to the owner's animation player, if applicable. Useful if a state has a one time animation to define behaviour after that animation finishes.
func _on_animation_finished(anim_name):
	pass
