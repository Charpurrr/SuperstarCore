extends Node2D

onready var enemy_types : Dictionary = {
	"dummy" : preload("res://actors/dummy_battle/dummy.tscn"),
	"kuribo" : preload("res://actors/kuribo_battle/kuribo.tscn")
}

export var enemy_ids : PoolStringArray

func _ready():
	for id in enemy_ids:
		var scene = enemy_types[id]
		var instance = scene.instance()
		
		add_child(instance)
