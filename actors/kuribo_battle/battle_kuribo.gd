extends KinematicBody2D

onready var hp_label : Label = $"%HP"
onready var kuribo_puppet : AnimatedSprite = $"%Puppet"
onready var collision : CollisionShape2D = $"%CollisionShape2D"
onready var action_indicator : Node = $"%ActionIndicator"
onready var anime : AnimationPlayer = $"%AnimationPlayer"

onready var index : int = get_index()
var anime_state : String = "idle"
var hp : int = 30


func _ready():
	kuribo_puppet.playing = true


func _process(_delta):
	kuribo_puppet.animation = anime_state
