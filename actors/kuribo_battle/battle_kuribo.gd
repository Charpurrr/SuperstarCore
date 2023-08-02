class_name BattleEnemy
extends CharacterBody2D
# A fightable enemy in the battle arena

@onready var actor : AnimatedSprite2D = $"Puppet"
#@onready var action_indicator : Node = $"%ActionIndicator"
#@onready var anime : AnimationPlayer = $"%AnimationPlayer"

@onready var index : int = get_index()
var anime_state : String = "idle"
var hp : int = 30


func _ready():
	actor.play()


func _process(_delta):
	actor.animation = anime_state
