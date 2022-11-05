extends KinematicBody2D

# reference vars
onready var mario_puppet : AnimatedSprite = $"%Puppet"
onready var mario_anime : AnimationPlayer = $"%AnimationPlayer"
onready var enemy_category : Node2D = $"../../Enemies"

# command block vars
onready var selection_block : Node = $"%Block"
var command_select : int = 1 # [1: jump] [2: hammer] [3: bros] [4: run] [5: item]

# jump attack vars
var allow_jump_run : bool = false
var jump_rating : String
var checking_jump_rating : bool = false
var jumping : bool = false
var jump_stage : int = 0

var jump_attack_start_pos : Vector2 # Sine curve
var jump_attack_end_pos : Vector2 # Sine curve
var jump_attack_fail_pos : Vector2 # Sine curve
var jump_progression : float = 0.00 # Sine curve
var jump_fail_progression : float = 0.00 # Sine curve

const JUMP_HEIGHT : int = 100 # Sine curve
const JUMP_FAIL_HEIGHT : int = 20 # Sine curve

# hammer attack vars
var hammer_stage : int = 0
var allow_hammer_run : bool = false

var hammer_attack_start_pos : Vector2

# shared vars
var running_back : bool = false
var attacking : bool = false
var origin_point : Vector2
var anime_state : String = "thinking"
const RUN_TIME : float = 0.7 # The time it takes to run toward, and back from an enemy


func _ready():
	GlobalSingletonShared.mario_battle_state = "selecting_action"
	mario_puppet.playing = true


func _process(_delta):
	command_block_handler(_delta)
	jump_action_extended(_delta)
	hammer_action_extended(_delta)

	mario_puppet.animation = anime_state


func command_block_handler(_delta):
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
			1: jump_action(_delta)
			2: hammer_action(_delta)
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


func jump_action(_delta):
	match jump_stage:
		0: # assign call
			GlobalSingletonShared.mario_battle_state = "assigning"
			anime_state = "idle"
			allow_jump_run = true
			jump_stage = 1

		1: # run + jump
			if allow_jump_run == true:
				anime_state = "run_right"
				for enemy in enemy_category.get_children():
					if enemy.index == GlobalSingletonShared.final_selected_enemy:
						jump_attack_start_pos = enemy.get_node("JumpAttackStart").global_position
						jump_attack_end_pos = enemy.get_node("JumpAttackEnd").global_position
						jump_attack_fail_pos = enemy.get_node("JumpAttackFail").global_position
				
						var jump_attack_tween = create_tween()
						jump_attack_tween.tween_property(self, "position", 
						jump_attack_start_pos, RUN_TIME).from(origin_point)
						jump_attack_tween.connect("finished", self, "jump_start_windup", [], CONNECT_ONESHOT)

						allow_jump_run = false

		3: # check rating (reference JumpCheck) Jump stage is 3 but it didn't reach the breakpoint????
			pass

		4: # excellent
			pass

		5: # pose
			anime_state = "jump_land_dx"

		6: # recover
			pass


func jump_action_extended(_delta): 
	# Handles the sine wave for the jump attack
	if jumping == true && jump_progression < 1.0:
		position.y = jump_attack_start_pos.y - (
			JUMP_HEIGHT * sin(jump_progression * PI) - (
			jump_attack_end_pos.y - jump_attack_start_pos.y)  * jump_progression)

		position.x = jump_attack_start_pos.x + (
			(jump_attack_end_pos.x - jump_attack_start_pos.x) * jump_progression)

		jump_progression += 1.0 * _delta

	if jumping == true && jump_progression >= 0.5:
		anime_state = "jump_fall"

	if jumping == true && jump_progression >= 1.0:
		jumping = false
		jump_progression = 0
		jump_stage = 3

	match jump_rating: # Handels the rating responses
		"Fail":
			anime_state = "jump_fail"
			jump_action_cancelled(_delta)
		"OK":
			pass

		"Good":
			pass

		"Good_cancelled":
			pass

		"Great":
			pass

		"Excellent":
			pass

	if running_back == true: # Handles running back from a jump
		jumping = false
		anime_state = "run_left"

		var origin_tween = create_tween()
		origin_tween.tween_property(self, "position", 
		origin_point, RUN_TIME).from(jump_attack_fail_pos)
		origin_tween.connect("finished", self, "end_turn", [], CONNECT_ONESHOT)
		running_back = false


func jump_start_windup():
	jump_stage = 2
	anime_state = "jump_windup"


func jump_action_cancelled(_delta): # Handles the sine wave for a cancelled jump
	if jump_fail_progression <= 1:
		if jump_rating == "Fail":
			mario_puppet.offset.y = -40

		jump_stage = 6
		position.y = position.y - (
		JUMP_FAIL_HEIGHT * sin(jump_fail_progression * PI) - (
		jump_attack_fail_pos.y - position.y)  * jump_fail_progression)

		position.x = position.x + (
		(jump_attack_fail_pos.x - position.x) * jump_fail_progression)

		jump_fail_progression += 3.0 * _delta

	if jump_fail_progression >= 1: # Handles running back after the above
		if jump_rating == "Fail":
			anime_state = "jump_fail_land"
			jump_rating = ""
		else:
			running_back = true


func hammer_action(_delta):
	match hammer_stage:
		0: # assign call
			GlobalSingletonShared.mario_battle_state = "assigning"
			anime_state = "idle"
			hammer_stage = 1

		1: # start + run
			anime_state = "hammer_takeout"
			hammer_stage = 2

		2:
			pass


func hammer_action_extended(_delta):
	if allow_hammer_run == true: # Handles running towards an enemy
			anime_state = "hammer_run"
			for enemy in enemy_category.get_children():
				if enemy.index == GlobalSingletonShared.final_selected_enemy:
					hammer_attack_start_pos = enemy.get_node("HammerAttackStart").global_position

					var hammer_attack_tween = create_tween()
					hammer_attack_tween.tween_property(self, "position", 
					hammer_attack_start_pos, RUN_TIME).from(origin_point)
					hammer_attack_tween.connect("finished", self, "hammer_action_windup", [], CONNECT_ONESHOT)

					allow_hammer_run = false


func hammer_action_windup():
	anime_state = "hammer_start"


func bros_action():
	pass


func run_action():
	pass


func item_action():
	pass


func end_turn():
	jump_rating = ""
	running_back = false
	GlobalSingletonShared.mario_battle_state = "defending"
	anime_state = "idle"


func _on_Puppet_animation_finished():
	match anime_state:
		"jump_windup":
			jumping = true
			checking_jump_rating = true
			anime_state = "jump"

		"jump_fail_land":
			mario_puppet.offset.y = -50
			running_back = true

		"jump_land_dx":
			anime_state = "in_style"


		"hammer_takeout":
			allow_hammer_run = true

		"hammer_start":
			anime_state = "hammer_windup"
