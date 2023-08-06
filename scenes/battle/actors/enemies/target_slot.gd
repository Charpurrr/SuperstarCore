class_name TargetSlot
extends AnimatedSprite2D
# A graphic that previews the target indication on this enemy

# Place this graphic over the enemy in a way you deem appropriate

@onready var actor : BattleEnemy = get_parent()


func _ready():
	play("attack_deselect")
	actor.target_slot_pos = global_position


func _process(_delta):
	actor.enemy_coordinator.target_slot_frame = frame
	visible = actor.is_selected
