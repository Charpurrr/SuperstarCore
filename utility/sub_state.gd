class_name SubState
extends Node
# A sub state coordinated by the state coordinator
# Same as State, except one layer deeper in the scene tree

@onready var state_coordinator : Node = $"../../"
@onready var actor : CharacterBody2D = $"../../../"
