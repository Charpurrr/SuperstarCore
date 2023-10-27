class_name AVCoordinator
extends Node
## An interface that manages audiovisual effects.


var _effect_cache: Dictionary = {}


func trigger_effect(effect: String) -> void:
	if _effect_cache.has(effect):
		_effect_cache[effect].trigger()
	else:
		var node : AVEffect = get_node_or_null(effect)

		if node == null:
			push_warning("No effect named '", effect, "'.")
			return

		node.trigger()
		_effect_cache[effect] = node
