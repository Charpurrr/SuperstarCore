extends KinematicBody2D

# reference vars
onready var mario_puppet : AnimatedSprite = $"%Puppet"
onready var mario_anime : AnimationPlayer = $"%AnimationPlayer"
onready var enemy_category : Node2D = $"../../Enemies"

# jump attack vars
var jumping_windup : bool = false
var jumping : bool = false
var checking : bool = false # If true, can perform a jump action to get a great or excellent rating
var successful_jump : bool = false # If true, performed jump action to get a great or excellent rating
var checking_dx : bool = false # If true, can perform a jump action to get an excellent rating
var successful_jump_dx : bool = false # If true, performed a jump action to get an excellent rating
var jump_attack_start_pos : Vector2
var jump_attack_end_pos : Vector2
var jump_attack_fail_pos : Vector2
var jump_stage : int
var jump_progression : float = 0.00
var jump_fail_progression : float = 0.00
const JUMP_HEIGHT : int = 100
const JUMP_FAIL_HEIGHT : int = 10

# command block vars
onready var selection_block : Node = $"%Block"
var command_select : int = 1 # [1: jump] [2: hammer] [3: bros] [4: run] [5: item]

# misc vars
var origin_point : Vector2
var anime_state : String = "thinking"


func _ready():
	GlobalSingletonShared.mario_battle_state = "selecting_action"
	mario_puppet.playing = true


func _process(delta):
	print(jump_progression)
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


func _input(event):
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

		1: # run and jump
			anime_state = "run_right"
			for enemy in enemy_category.get_children():
				if enemy.index == GlobalSingletonShared.final_selected_enemy:
					jump_attack_start_pos = enemy.get_node("JumpAttackStart").global_position
					jump_attack_end_pos = enemy.get_node("JumpAttackEnd").global_position
					jump_attack_fail_pos = enemy.get_node("JumpAttackFail").global_position
					var attack_tween = create_tween()
					attack_tween.tween_property(self, "position", 
					# Change the value to the correct duration after study
					jump_attack_start_pos, 0.7).from_current()
					attack_tween.connect("finished", self, "jump_start_windup")

		2: # reference $JumpFailCheck
			pass

		3: # check (great)
			pass
#			if Input.is_action_just_pressed("A") && checking:
#				successful_jump = true
#				anime_state = "jump_air"
#				mario_anime.queue("jump_air")

		4: # check (excellent)
			pass
#			if Input.is_action_just_pressed("A") && checking_dx:
#				anime_state = "jump_excellent"
#				mario_anime.play("jump_excellent")

		5: # excellent recover
			pass

func jump_start_windup():
	jumping_windup = true
	anime_state = "jump_windup"
	yield(get_tree().create_timer(10.0/60.0), "timeout") # 10/60 because there's 2 frames which need to play at 10fps
	anime_state = "jump"
	jumping_windup = false
	jumping = true


func jump_action_extended(): # Handles the sine wave for the jump attack
	if jumping == true && jump_progression < 1.0 - 1.0 / 30.0:
		position.y = jump_attack_start_pos.y - (
			JUMP_HEIGHT * sin(jump_progression * PI) - (
			jump_attack_end_pos.y - jump_attack_start_pos.y)  * jump_progression)

		position.x = jump_attack_start_pos.x + (
			(jump_attack_end_pos.x - jump_attack_start_pos.x) * jump_progression)

		jump_progression += 1.0 / 30.0

	if jumping == true && jump_progression >= 0.5:
		anime_state = "jump_fall"

	if jump_progression == 1.0:
		print("YIPPEE")
		jumping = false
		jump_progression = 0
		jump_stage = 2


func jump_action_failed(): # Handles the sine wave for the failed jump
	if jump_fail_progression <= 1:
		jump_fail_progression += 1.0 / 20.0

		position.y = position.y - (
		JUMP_FAIL_HEIGHT * sin(jump_fail_progression * PI) - (
		jump_attack_fail_pos.y - position.y)  * jump_fail_progression)

		position.x = position.x + (
		(jump_attack_fail_pos.x - position.x) * jump_fail_progression)

	if jump_fail_progression >= 1: # Handles running back after the above
		jumping = false
		anime_state = "run_left"
		var origin_tween = create_tween()
		origin_tween.tween_property(self, "position", 
		# Change the value to the correct duration after study
		origin_point, 0.7).from_current()
		origin_tween.connect("finished", self, "end_turn")


func hammer_action():
	pass


func bros_action():
	pass


func run_action():
	pass


func item_action():
	pass


func end_turn():
	anime_state = "idle"
