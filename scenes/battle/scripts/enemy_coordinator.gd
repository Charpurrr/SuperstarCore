class_name EnemyCoordinator
extends Node2D
# Coordinates the enemies inside of this node

const ENEMY_PATH : String = "res://scenes/battle/actors/enemies/"
@onready var enemy_types : Dictionary = {
	"dummy" : preload("%sdummy_battle/dummy.tscn" % ENEMY_PATH),
	"kuribo" : preload("%skuribo_battle/kuribo.tscn" % ENEMY_PATH)
} # What enemies exist

@export var enemy_ids : PackedStringArray # What enemies are loaded in this arena
var enemy_amt : int # Amount of enemies loaded in this arena
var final_enemy : int # Final selected enemy to attack


func _ready():
	enemy_set() # Priority numero uno
	set_enemy_count()


func enemy_set(): # Load enemies depending on the export variable
	for id in enemy_ids:
		var scene = enemy_types[id]
		var instance = scene.instantiate()

		add_child(instance)


func set_enemy_count(): # Set the amount of enemies depending on what was loaded by enemy_set()
	enemy_amt = get_child_count()
