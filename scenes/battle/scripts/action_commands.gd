extends Node2D

@onready var bp_coordinator : Node2D = $%BattlePlayers
@onready var action_block : AnimatedSprite2D = $Block

var current_block : String
var active : bool # If action commands should be active

var commands : Array = ["jump", "hammer", "bros", "item", "run",]
var viewed_command : int = 0 # Which action command the player is currently looking at


func _process(_delta):
	visible = active

	if active:
		action_block.position = bp_coordinator.starting_pos[bp_coordinator.get_current_fighter()]
		action_block.animation = commands[viewed_command]

		if Input.is_action_just_pressed("right"):
			pass
