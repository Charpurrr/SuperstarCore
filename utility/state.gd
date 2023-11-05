class_name State
extends Node
# A state coordinated by the state coordinator

@onready var state_coordinator : Node = get_parent()
@onready var actor : CharacterBody2D = $"../../"
