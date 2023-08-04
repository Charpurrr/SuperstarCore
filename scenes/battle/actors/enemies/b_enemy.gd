class_name BattleEnemy
extends CharacterBody2D
# A fightable enemy in the battle arena

@onready var anime : AnimationPlayer = $"%AnimationPlayer"
@onready var doll : AnimatedSprite2D = $"Doll"

@onready var bp_coordinator : BattlePlayerCoordinator = $"../../BattlePlayers"
@onready var enemy_coordinator : EnemyCoordinator = get_parent()

@onready var target_indicator : TargetIndicator = $"%TargetIndicator"

@onready var hologram : Sprite2D = $"%HammerAttackHologram" 
# A silhouette that previews a hammer attack on this enemy
# Place this graphic's RED hammer head over the enemy in a way you deem appropriate

@onready var index : int = get_index()


func _ready():
	hologram.visible = false
