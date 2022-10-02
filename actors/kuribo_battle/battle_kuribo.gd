extends KinematicBody2D

onready var hp_label : Node = $"%HP"
onready var kuribo_puppet : Node = $"%Puppet"
onready var collision : Node = $"%CollisionShape2D"
onready var action_indicator : Node = $"%ActionIndicator"

var anime_state : String = "idle"

onready var index : int = get_index()
var hp : int = 30


func _ready():
	kuribo_puppet.playing = true


func _process(delta):
	kuribo_puppet.animation = anime_state
