class_name BattlePlayer
extends KinematicBody2D
# A playable party member in the battle arena

# reference vars
onready var actor : AnimatedSprite = $"%Puppet"
onready var anime_player : AnimationPlayer = $"%AnimationPlayer"
onready var enemy_category : Node2D = $"../../Enemies"
onready var hammer_disconnected : Sprite = $"%HammerDisconnect"
onready var rating_sprite : AnimatedSprite = $"../../Rating"

onready var jumpcheck : ResourcePreloader = $"%JumpCheck"
onready var hammercheck : ResourcePreloader = $"%HammerCheck"

# command block vars
onready var selection_block : Node = $"%Block"
var command_select : int = 1 # [1: jump] [2: hammer] [3: bros] [4: run] [5: item]

# jump attack vars
var jump_stage : int = 0

var start_jump_attack : bool = false # Allow jump_action() to run
var allow_jump_run : bool = false # Allow running toward the enemy

var jump_attack_start_pos : Vector2
var jump_attack_end_pos : Vector2
var jump_progression : float = 0.00 # How far along jump is
const JUMP_HEIGHT : int = 100

var jumping : bool = false # Playing the first jump animation

var jump_attack_fail_pos : Vector2 # Ending position of failed jump
var jump_fail_progression : float = 0.00 # How far along failed jump is
const JUMP_FAIL_HEIGHT : int = 20
# ^ the second bounce is this value / 2

var jump_rating : String
var jump_rated : bool = false
var checking_jump_rating : bool = false

var running_back_jump : bool = false

# hammer attack vars
var hammer_stage : int = 0

var start_hammer_attack : bool = false # Allow hammer_action() to run
var allow_hammer_run : bool = false # Allow running toward the enemy

var hammer_windupped : bool = false

var hammer_attack_start_pos : Vector2

var hammer_rating : String
var hammer_rated : bool = false
var checking_hammer_rating : bool = false

var running_back_hammer : bool = false

# shared vars
var origin_point : Vector2
var anime_state : String = "thinking"
const RUN_TIME : float = 0.5 # The time it takes to run toward, and back from an enemy


func _ready():
	GlobalSingletonShared.mario_battle_state = "selecting_action"
	actor.playing = true


func _process(_delta):
	command_block_handler(_delta)
	jump_action(_delta)
	hammer_action(_delta)

	actor.animation = anime_state

	if GlobalSingletonShared.mario_battle_state == "assigning":
		if Input.is_action_just_pressed("B"):
			end_turn()


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
			1: start_jump_attack = true
			2: start_hammer_attack = true
			3: bros_action()
			4: run_action()
			5: item_action()


func _input(_event):
	# Switch between command blocks if anime_state == "thinking"
	if Input.is_action_pressed("right") and anime_state == "thinking":
		command_select += 1
		command_select = wrapi(command_select, 1, 6)

	if Input.is_action_pressed("left") and anime_state == "thinking":
		command_select -= 1
		command_select = wrapi(command_select, 1, 6)


func jump_action(_delta): 
	if start_jump_attack == true:
		match jump_stage:
			0: # Assigning enemy to attack
				GlobalSingletonShared.mario_battle_state = "assigning"
				anime_state = "idle"
				allow_jump_run = true
				jump_stage = 1

			1: # Running toward and jumping on the enemy (tween)
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
							# sets anime_state to jump_windup as soon as this tween finishes
							jump_attack_tween.connect("finished", self, "set", ["anime_state", "jump_windup"], CONNECT_ONESHOT)

							allow_jump_run = false

			2: # play the jump attack's bounce animation (ref JumpCheck)
				anime_state = "jump_check"
				anime_player.play("jump_check")

			4: # excellent
				pass

			5: # pose
				anime_state = "jump_land_dx"

			6: # recover
				pass

		# Handles the rating responses
		match jump_rating:
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

		# Handles the sine wave for the jump attack
		if jumping == true and jump_progression < 1.0:
			position.y = jump_attack_start_pos.y - (
				JUMP_HEIGHT * sin(jump_progression * PI) - (
				jump_attack_end_pos.y - jump_attack_start_pos.y)  * jump_progression)

			position.x = jump_attack_start_pos.x + (
				(jump_attack_end_pos.x - jump_attack_start_pos.x) * jump_progression)

			jump_progression += 1.0 * _delta

		if jumping == true and jump_progression >= 0.5:
			anime_state = "jump_fall"

		if jumping == true and jump_progression >= 1.0:

			jump_progression = 0
			jump_stage = 2

		# Handles running back from a jump
		if running_back_jump == true:
			jumping = false
			anime_state = "run_left"

			var origin_tween = create_tween()
			origin_tween.tween_property(self, "position", 
			origin_point, RUN_TIME).from(jump_attack_fail_pos)
			origin_tween.connect("finished", self, "end_turn", [], CONNECT_ONESHOT)
			running_back_jump = false


func jump_action_cancelled(_delta): # Handles the sine wave for a cancelled jump
	if jump_fail_progression <= 1:
		if jump_rating == "Fail":
			actor.offset.y = -40

		jump_stage = 0

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
			running_back_jump = true


func hammer_action(_delta):
	if start_hammer_attack == true:
		match hammer_stage:
			0: # Assigning enemy to attack
				GlobalSingletonShared.mario_battle_state = "assigning"
				anime_state = "idle"
				hammer_stage = 1

			1: # Takeout hammer
				if GlobalSingletonShared.mario_battle_state == "attacking":
					anime_state = "hammer_takeout"

			2: # Running toward enemy
				if allow_hammer_run == true: # Handles running towards an enemy
						anime_state = "hammer_run"

						for enemy in enemy_category.get_children():
							if enemy.index == GlobalSingletonShared.final_selected_enemy:
								hammer_attack_start_pos = enemy.get_node("HammerAttackStart").global_position

								var hammer_attack_tween = create_tween()
								hammer_attack_tween.tween_property(self, "position", 
								hammer_attack_start_pos, RUN_TIME).from(origin_point)
								hammer_attack_tween.connect("finished", self, "set", ["anime_state", "hammer_start"], CONNECT_ONESHOT)

								allow_hammer_run = false

		if running_back_hammer == true: # Handles running back from a hammer attack
			hammer_rating = ""
			anime_state = "run_left"

			var origin_tween = create_tween()
			origin_tween.tween_property(self, "position", 
			origin_point, RUN_TIME).from_current()
			origin_tween.connect("finished", self, "end_turn", [], CONNECT_ONESHOT)
			running_back_hammer = false


		match hammer_rating: # Handles the rating responses
			"OK":
				hammer_rating = ""
				anime_state = "hammer_swing"

			"Good":
				hammer_rating = ""
				anime_state = "hammer_swing"

			"Great":
				hammer_rating = ""
				anime_state = "hammer_swing"

			"Excellent":
				hammer_rating = ""
				anime_state = "hammer_excellent_edge"

			"Fail":
				hammer_rating = ""
				hammer_windupped = false
				hammer_disconnected.visible = true
				anime_player.play("hammer_disconnect")
				anime_state = "hammer_fail"


func bros_action():
	pass


func run_action():
	pass


func item_action():
	pass


func end_turn():
	rating_sprite.visible = false

	start_jump_attack = false
	jump_stage = 0
	jump_rating = ""
	jumpcheck.temp_rating = ""
	jump_rated = false
	running_back_jump = false

	start_hammer_attack = false
	hammer_stage = 0
	hammer_rating = ""
	hammercheck.temp_rating = ""
	hammer_rated = false
	running_back_hammer = false

	GlobalSingletonShared.mario_battle_state = "selecting_action"
	anime_state = "thinking"


func _on_Puppet_animation_finished():
	match anime_state:
		# jump attack
		"jump_windup":
			jumping = true
			checking_jump_rating = true
			anime_state = "jump"

		"jump_fail_land":
			actor.offset.y = -50
			running_back_jump = true

		"jump_land_dx":
			anime_state = "in_style"

		# hammer attack
		"hammer_takeout":
			allow_hammer_run = true
			hammer_stage = 2

		"hammer_start":
			checking_hammer_rating = true
			anime_state = "hammer_windup"

		"hammer_windup":
			hammer_windupped = true
			checking_hammer_rating = false

		"hammer_excellent_edge":
			anime_state = "hammer_excellent"

		"hammer_excellent":
			hammercheck.show_rating()
			anime_state = "hammer_swing_impact"

		"hammer_swing":
			hammercheck.show_rating()
			anime_state = "hammer_swing_impact"

		"hammer_swing_impact":
			anime_state = "hammer_return"

		"hammer_return":
			running_back_hammer = true

# https://youtu.be/_IRn16vAchM?list=RDKx0UXghlSEI <- I love Lancer Deltarune


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"hammer_disconnect":
			running_back_hammer = true
			hammer_disconnected.visible = false
