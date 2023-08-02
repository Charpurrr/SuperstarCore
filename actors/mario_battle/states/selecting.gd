class_name SelectingState
extends State
# Selecting an action to perform, and who to perform it on


func _ready():
	state_coordinator.active_state = "selecting_action"
