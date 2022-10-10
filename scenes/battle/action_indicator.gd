extends Node2D

onready var enemy : KinematicBody2D = get_parent()
onready var ai_sprite : AnimatedSprite = $"AnimatedSprite"
var selected_enemy_index : int = 0
var progress : int = 0
var current_frame : float = 5.0/60.0


func _ready():
	ai_sprite.playing = true


func _input(_event):
	if GlobalSingletonShared.mario_battle_state == "assigning":
		if Input.is_action_pressed("right"):
			selected_enemy_index += 1
			selected_enemy_index = wrapi(selected_enemy_index, 0, GlobalSingletonShared.amount_enemies_field)
		if Input.is_action_pressed("left"):
			selected_enemy_index -= 1
			selected_enemy_index = wrapi(selected_enemy_index, 0, GlobalSingletonShared.amount_enemies_field)

		if Input.is_action_just_pressed("A"):
			GlobalSingletonShared.final_selected_enemy = selected_enemy_index
			GlobalSingletonShared.mario_battle_state = "attacking"


func _process(_delta):
	# makes the bobbing animation synced
	current_frame += 5.0/60.0
	ai_sprite.frame = (int(current_frame) % ai_sprite.frames.get_frame_count(ai_sprite.animation))

	if GlobalSingletonShared.mario_battle_state == "assigning":
		visible = true
		if selected_enemy_index == enemy.index:
			ai_sprite.animation = "attack_select"
		else:
			ai_sprite.animation = "attack_deselect"
	else:
		visible = false
