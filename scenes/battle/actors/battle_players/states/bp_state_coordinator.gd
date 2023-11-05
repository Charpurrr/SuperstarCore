class_name BPStateCoordinator
extends Node
# A method of coordination between a battle player's states

@onready var animation_player : AnimationPlayer = $%AnimationPlayer
@onready var actor : CharacterBody2D = get_parent()
@onready var doll : AnimatedSprite2D = $%Doll

var active_state : StringName


func _process(_delta):
	match active_state:
		"idle":
			doll.play("idle")

		"selecting_action":
			doll.play("thinking")

			actor.action_commands.active = true

		"select_action":
			doll.play("jump")

			animation_player.play("select_jump")

		"selecting_target":
			doll.play("idle")

			actor.action_commands.active = false

		"preparing_target":
			match actor.action_commands.selected_command:
				"jump":
					actor.action_commands.selected_command = ""
					active_state = "j_moving_toward"
					doll.play("run_right")
				"hammer":
					actor.action_commands.selected_command = ""
					doll.play("hammer_takeout")


func _on_animation_player_animation_finished(anim_name):
	match anim_name:
		"select_jump":
			active_state = "selecting_target"


func _on_doll_animation_finished():
	match doll.animation:
		"hammer_takeout":
			active_state = "h_moving_toward"
			doll.play("hammer_run")
