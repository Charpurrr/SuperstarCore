class_name LayoutTable
extends Resource
# A dictionary of all possible layouts

@export var layout_table : Dictionary = {}


func get_layout(encounter_name : StringName, variant : int) -> PackedScene: # Returns a layout scene
	if variant == -1: # -1 randomises your layout
		variant = randi_range(0, layout_table[encounter_name].size() -1)
	return layout_table[encounter_name][variant]
