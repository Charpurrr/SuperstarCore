class_name SelectingState
extends State
# Selecting an action to perform, and who to perform it on

var selected_command : String # See actor.action_commands.selected_command

const PHASES : PackedStringArray = ["selecting_action", "selecting_target",] # Phases of this state
var current_phase : String # Which phase this state is currently on


func _ready():
	current_phase = PHASES[0]


func _process(_delta):
	if not actor.is_fighter: return

	selected_command = actor.action_commands.selected_command

	match current_phase:
		PHASES[0]: # selecting_action
			if state_coordinator.active_state == "idle":
				state_coordinator.active_state = current_phase

			if Input.is_action_just_pressed(actor.action_button) and state_coordinator.active_state == "selecting_action":
				state_coordinator.active_state = "select_action" # not the same as selecting_action

			match selected_command:
				"jump", "hammer":
					current_phase = PHASES[1]

		PHASES[1]: # selecting_target
			if Input.is_action_just_pressed("shoulder_l") and state_coordinator.active_state == "selecting_target":
				state_coordinator.active_state = current_phase
				actor.action_commands.selected_command = ""
				current_phase = PHASES[0]

			if not actor.bp_coordinator.enemy_coordinator.final_enemy == null:
				state_coordinator.active_state = "preparing_target"
				current_phase = PHASES[0]
