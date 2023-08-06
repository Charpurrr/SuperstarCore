class_name MathUtility
extends Node2D
# Anything and everything predefined math related

static func tween_current_pos_to(node : Node2D, final_pos : Vector2, time_frames : int):
	var tween = node.create_tween()
	tween.tween_property(node, "position", final_pos, float(time_frames) / 60.0).from_current()
	tween.connect("finished", node.tween_finished)
