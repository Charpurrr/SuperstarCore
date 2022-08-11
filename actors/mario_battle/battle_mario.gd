extends KinematicBody2D

onready var mario_puppet = $"%Puppet"
onready var mario_anime = $"%AnimationPlayer"
var state = "idle"
var checking = false # If true, can perform a jump action to get a great or excellent

# Disable after command blocks have been split
onready var selection_blocks = $"%Row"

func _ready():
	selection_blocks.visible = true
	state = "idle"
	mario_puppet.playing = true
	mario_puppet.animation = "idle"

func _process(delta):
	mario_puppet.animation = state

func _input(event):
	if Input.is_action_just_pressed("jump_mario"):
		state = "jump"
		selection_blocks.visible = false
		mario_anime.play("jump_check")
