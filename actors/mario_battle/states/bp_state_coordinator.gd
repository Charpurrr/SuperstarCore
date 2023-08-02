class_name BPStateCoordinator
extends Node
# A method of coordination between a battle player's states

@onready var actor : CharacterBody2D = get_parent()
@onready var doll : AnimatedSprite2D = $%Doll

var active_state : String


func _process(_delta):
	if active_state == "selecting_action":
		doll.play("thinking")

		actor.action_commands.active = true
