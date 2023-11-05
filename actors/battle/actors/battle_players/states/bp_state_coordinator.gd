class_name BPStateCoordinator
extends State
# A method of coordination between a battle player's states.


@export var target_actor: Node = owner
@export var target_av: AVCoordinator = null
@export var initial_state: State = null

func _ready():
#	recurse_descendents(&"set", [&"actor", target_actor])
#	recurse_descendents(&"set", [&"av", target_av])
#	await target_actor.ready
	
	# Switch to and initialise the initial state, if there is one.
#	if initial_state != null:
#		var link = StateLink.new(self, initial_state)
#		_switch_leaf(link)
#		live_substate.trigger_enter(null)


func _physics_process(_delta):
#	recurse_live("probe_switch")

	if live_substate != null:
		# Call the tick hook function.
		live_substate.recurse_live("tick_hook")


#func _process(_delta):
#	match active_state:
#		"idle":
#			doll.play("idle")
#
#		"selecting_action":
#			doll.play("thinking")
#
#			actor.action_commands.active = true
#
#		"select_action":
#			doll.play("jump")
#
#			animation_player.play("select_jump")
#
#		"selecting_target":
#			doll.play("idle")
#
#			actor.action_commands.active = false
#
#		"preparing_target":
#			match actor.action_commands.selected_command:
#				"jump":
#					actor.action_commands.selected_command = ""
#					active_state = "j_moving_toward"
#					doll.play("run_right")
#				"hammer":
#					actor.action_commands.selected_command = ""
#					doll.play("hammer_takeout")
#
#
#func _on_animation_player_animation_finished(anim_name):
#	match anim_name:
#		"select_jump":
#			active_state = "selecting_target"
#
#
#func _on_doll_animation_finished():
#	match doll.animation:
#		"hammer_takeout":
#			active_state = "h_moving_toward"
#			doll.play("hammer_run")
