class_name BattleEnemy
extends CharacterBody2D
# A fightable enemy in the battle arena

@export var enemy_name : StringName # The name of this enemy (lowercase)

@onready var anime : AnimationPlayer = $"%AnimationPlayer"
@onready var doll : AnimatedSprite2D = $"Doll"

@onready var bp_coordinator : BattlePlayerCoordinator = $"../../../BattlePlayers"
@onready var enemy_coordinator : EnemyCoordinator = $"../../"

@onready var hammer_hologram : HammerHologram = $HammerAttackHologram
@onready var target_slot : TargetSlot = $TargetIndicatorSlot

var hammer_holo_pos : Vector2 # The hammer hologram's position on this enemy
var target_slot_pos : Vector2 # The target slot's position on this enemy

@onready var index : int = get_index()

var is_selected : bool # Check if this enemy is selected by the target indicator


func _ready():
	hammer_hologram.visible = false
