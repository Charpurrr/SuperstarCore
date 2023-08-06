class_name MathUtility
extends Node2D
# Anything and everything predefined math related

static func tween_current_pos_to(node : Node2D, final_pos : Vector2, time_frames : int, signal_receiver : Node):
# node: What node gets their position tweened
# final_pos: What position the node tweens to
# time_frames: How long the tween takes in frames
# signal_receiver: What node receives the tween_finished signal

	var tween = node.create_tween()
	tween.tween_property(node, "position", final_pos, float(time_frames) / 60.0).from_current()
	tween.connect("finished", signal_receiver.tween_finished)
