extends KinematicBody2D

onready var hp_label = $"%HP"
onready var kuribo_puppet = $"%Puppet"
var state = "idle"

var hp = 30

func _ready():
	state = "idle"
	kuribo_puppet.playing = true
	kuribo_puppet.animation = "idle"

func _process(delta):
	hp_label.text = str(hp, "HP")
	kuribo_puppet.animation = state

	if hp <= 0:
		state = "dead"

func _input(event):
	if Input.is_action_just_pressed("jump_mario") && state != "dead":
		hp -= 10
