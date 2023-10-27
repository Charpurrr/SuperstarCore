class_name LayoutProperties
extends Node2D
# Properties of this layout

@export var enemies : Dictionary = {}


func get_enemies() -> Dictionary: # Generates and caches the enemies dictionary
	if not enemies.is_empty():
		return enemies

	for child in get_children():
		var key = child.enemy_name

		if enemies.has(key):
			enemies[key] += 1
		else:
			enemies[key] = 1

	return enemies
