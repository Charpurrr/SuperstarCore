class_name MovingState
extends State
# Moving toward or from an enemy

func _process(delta):
	if not state_coordinator.active_state == "moving_to":
		pass
