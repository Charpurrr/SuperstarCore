extends KinematicBody2D

# reference vars
onready var mario_puppet : AnimatedSprite = $"%Puppet"
onready var mario_anime : AnimationPlayer = $"%AnimationPlayer"
onready var enemy_category : Node2D = $"../../Enemies"

# command block vars
onready var selection_block : Node = $"%Block"
var command_select : int = 1 # [1: jump] [2: hammer] [3: bros] [4: run] [5: item]

# jump attack vars
var jumping : bool = false
var checking : bool = false # If true, can perform a jump action to get a great or excellent rating
var successful_jump : bool = false # If true, performed jump action to get a great or excellent rating
var checking_dx : bool = false # If true, can perform a jump action to get an excellent rating
var successful_jump_dx : bool = false # If true, performed a jump action to get an excellent rating
var jump_attack_start_pos : Vector2
var jump_attack_end_pos : Vector2
var jump_attack_fail_pos : Vector2
var jump_stage : int = 0
var jump_progression : float = 0.00
var jump_fail_progression : float = 0.00
const JUMP_HEIGHT : int = 100
const JUMP_FAIL_HEIGHT : int = 20

# shared attack vars
const RUNBACK_TIME : float = 0.7 # The time it takes to run toward, and back from an enemy

# misc vars
var attacking : bool = false
var origin_point : Vector2
var anime_state : String = "thinking"


func _ready():
	GlobalSingletonShared.mario_battle_state = "selecting_action"
	mario_puppet.playing = true


func _process(_delta):
	jump_action_extended()
	command_block_handler()
	mario_puppet.animation = anime_state


func command_block_handler():
	if anime_state == "thinking":
		selection_block.visible = true
	else:
		selection_block.visible = false

	match command_select:
		1: selection_block.animation = "jump"
		2: selection_block.animation = "hammer"
		3: selection_block.animation = "bros"
		4: selection_block.animation = "run"
		5: selection_block.animation = "item"

	if Input.is_action_just_pressed("A"):
		match command_select:
			1: jump_action()
			2: hammer_action()
			3: bros_action()
			4: run_action()
			5: item_action()


func _input(_event):
	if Input.is_action_pressed("right") && anime_state == "thinking":
		command_select += 1
		command_select = wrapi(command_select, 1, 6)
	if Input.is_action_pressed("left") && anime_state == "thinking":
		command_select -= 1
		command_select = wrapi(command_select, 1, 6)


func jump_action():
	match jump_stage:
		0: # assign call
			GlobalSingletonShared.mario_battle_state = "assigning"
			anime_state = "idle"
			jump_stage = 1

		1: # run + jump call
			anime_state = "run_right"
			for enemy in enemy_category.get_children():
				if enemy.index == GlobalSingletonShared.final_selected_enemy:
					jump_attack_start_pos = enemy.get_node("JumpAttackStart").global_position
					jump_attack_end_pos = enemy.get_node("JumpAttackEnd").global_position
					jump_attack_fail_pos = enemy.get_node("JumpAttackFail").global_position

					if attacking == false:
						attacking = true
						var attack_tween = create_tween()
						attack_tween.tween_property(self, "position", 
						jump_attack_start_pos, RUNBACK_TIME).from(origin_point)
						attack_tween.connect("finished", self, "jump_start_windup", [], CONNECT_ONESHOT)

		2: # jump
			pass

		3:
			pass

		4: # 
			pass

		5: # 
			pass
#			if Input.is_action_just_pressed("A") && checking_dx:
#				anime_state = "jump_excellent"
#				mario_anime.play("jump_excellent")

		6: # recover
			pass

func jump_start_windup():
	jump_stage = 2
	anime_state = "jump_windup"
	yield(get_tree().create_timer(10.0/60.0), "timeout") # 10/60 because there's 2 frames which need to play at 10fps
	anime_state = "jump"
	jumping = true


func jump_action_extended(): # Handles the sine wave for the jump attack
	if jumping == true && jump_progression < 1.0:
		position.y = jump_attack_start_pos.y - (
			JUMP_HEIGHT * sin(jump_progression * PI) - (
			jump_attack_end_pos.y - jump_attack_start_pos.y)  * jump_progression)

		position.x = jump_attack_start_pos.x + (
			(jump_attack_end_pos.x - jump_attack_start_pos.x) * jump_progression)

		jump_progression += 1.0 / 60.0

	if jumping == true && jump_progression >= 0.5:
		anime_state = "jump_fall"

	if jumping == true && jump_progression >= 1.0:
		jumping = false
		checking = true
		jump_progression = 0
		jump_stage = 3


func jump_action_failed(): # Handles the sine wave for the failed jump
	if jump_fail_progression <= 1:
		jump_stage = 6
		position.y = position.y - (
		JUMP_FAIL_HEIGHT * sin(jump_fail_progression * PI) - (
		jump_attack_fail_pos.y - position.y)  * jump_fail_progression)

		position.x = position.x + (
		(jump_attack_fail_pos.x - position.x) * jump_fail_progression)

		jump_fail_progression += 1.0 / 20.0

	if jump_fail_progression >= 1: # Handles running back after the above
		jumping = false
		anime_state = "run_left"
		var origin_tween = create_tween()
		origin_tween.tween_property(self, "position", 
		origin_point, RUNBACK_TIME).from(jump_attack_fail_pos)
		origin_tween.connect("finished", self, "end_turn", [], CONNECT_ONESHOT)


func hammer_action():
	pass


func bros_action():
	pass


func run_action():
	pass


func item_action():
	pass


func end_turn():
	GlobalSingletonShared.mario_battle_state = "defending"
	anime_state = "idle"
