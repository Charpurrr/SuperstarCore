class_name HammerHologram
extends Hologram
# A silhouette that previews a hammer attack on this enemy

# Place this graphic's RED hammer head over the enemy in a way you deem appropriate


func _ready():
	actor.hammer_holo_pos = global_position
