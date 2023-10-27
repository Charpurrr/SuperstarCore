class_name EnemyCoordinator
extends Node2D
# Coordinates the enemies inside of this node

@export var encounter_name : StringName
@export var encounter_variant : int

const LAYOUT_TABLE : LayoutTable = preload("res://actors/battle/layouts/layout_table.tres")
var loaded_layout : Node2D
var enemy_amt : int # Amount of enemies in loaded layout

var final_enemy : BattleEnemy # Final selected enemy to attack

var target_slot_frame : int # The current frame of a target slot's animation (for syncing)


func _ready():
	enemy_set() # Priority numero uno
	set_enemy_count()
	print(loaded_layout.get_enemies())


func enemy_set(): # Load enemies depending on the export variable
	var scene = LAYOUT_TABLE.get_layout(encounter_name, encounter_variant)
	var instance = scene.instantiate()

	add_child(instance)

	loaded_layout = instance


func set_enemy_count(): # Set the amount of enemies depending on what was loaded by enemy_set()
	enemy_amt = loaded_layout.get_child_count()
