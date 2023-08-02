extends Node2D

@onready var sprite : AnimatedSprite2D = $"AnimatedSprite2D"
@onready var enemy : CharacterBody2D = get_parent()

var progress : int = 0

var selected_enemy_index : int = 0
var current_frame : float = 5.0/60.0


func _ready():
	sprite.play()


#func _input(_event):
#	if Global.mario_battle_state == "assigning":
#		if Input.is_action_pressed("right"):
#			selected_enemy_index += 1
#			selected_enemy_index = wrapi(selected_enemy_index, 0, Global.amount_enemies_field)
#		if Input.is_action_pressed("left"):
#			selected_enemy_index -= 1
#			selected_enemy_index = wrapi(selected_enemy_index, 0, Global.amount_enemies_field)
#
#		if Input.is_action_just_pressed("A"):
#			Global.final_selected_enemy = selected_enemy_index
#			Global.mario_battle_state = "attacking"


#func _process(_delta):
#	# makes the bobbing animation synced
#	current_frame += 5.0/60.0
#	sprite.frame = (int(current_frame) % sprite.sprite_frames.get_frame_count(sprite.animation))
#
#	if Global.mario_battle_state == "assigning":
#		visible = true
#		if selected_enemy_index == enemy.index:
#			sprite.animation = "attack_select"
#		else:
#			sprite.animation = "attack_deselect"
#	else:
#		visible = false
