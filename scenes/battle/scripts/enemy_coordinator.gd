extends Node2D

@onready var enemy_types : Dictionary = {
	"dummy" : preload("res://actors/dummy_battle/dummy.tscn"),
	"kuribo" : preload("res://actors/kuribo_battle/kuribo.tscn")
} # What enemies exist

@export var enemy_ids : PackedStringArray # What enemies are loaded in this arena
var enemy_amt : int # Amount of enemies loaded in this arena


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
