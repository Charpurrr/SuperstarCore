class_name Hologram
extends Node2D
# Node that becomes invisible on runtime.


@onready var actor : Node = get_parent()


func _ready():
	modulate.a = 0
