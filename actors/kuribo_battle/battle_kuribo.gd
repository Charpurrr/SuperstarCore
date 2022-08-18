extends KinematicBody2D

onready var hp_label = $"%HP"
onready var puppet = $"%Puppet"
onready var collision = $"%CollisionShape2D"
var state = "idle"

var hp = 30

func _ready():
	state = "idle"
	puppet.playing = true
	puppet.animation = "idle"


func _process(delta):
	hp_label.text = str(hp, "HP")
	puppet.animation = state

	if hp <= 0:
		state = "dead"


func _input(event):
	if Input.is_action_just_pressed("A") && state != "dead":
		hp -= 10
