class_name AVEffect
extends Node
## An audiovisual effect, triggered by the AVManager.


## Trigger the effect.
func trigger() -> void:
	trigger_effect()
	trigger_sub_fx()


## Behavior of the effect.
func trigger_effect() -> void:
	pass


## Trigger sub-effects.
func trigger_sub_fx() -> void:
	for child in get_children():
		child.trigger()
