class_name AttackState
extends Node
# A state specific for battle player attacks

@onready var state_coordinator : Node = $"../../"

@onready var doll : AnimatedSprite2D  = $"../../../Doll"
@onready var actor : BattlePlayer = $"../../../"
