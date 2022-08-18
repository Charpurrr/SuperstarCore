extends KinematicBody2D

# Mario's animation is always the same as his state, so don't change the former, change the latter to the name of an animation in %Puppet

onready var mario_puppet = $"%Puppet"
onready var mario_anime = $"%AnimationPlayer"
var state = "idle"
var command_select = 1 # [1: jump] [2: hammer] [3: bros] [4: run] [5: item]

var jump_progression = 0
var checking = false # If true, can perform a jump action to get a great or excellent rating
var successful_jump = false # If true, performed jump action to get a great or excellent rating
var checking_dx = false # If true, can perform a jump action to get an excellent rating
var successful_jump_dx = false # If true, performed a jump action to get an excellent rating

onready var selection_block = $"%Block"

func _process(delta):
	command_block_handler()
	mario_puppet.animation = state


func command_block_handler():
	if state == "thinking":
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
	if Input.is_action_pressed("right") && state == "thinking":
		command_select += 1
		command_select = wrapi(command_select, 1, 6)
	if Input.is_action_pressed("left") && state == "thinking":
		command_select -= 1
		command_select = wrapi(command_select, 1, 6)


func assign_attack():
	pass


func jump_action():

	match jump_progression:
#		0: # assign
#			assign_attack()
		0: # start
			if Input.is_action_just_pressed("A"):
				state = "jump_successful"
				mario_anime.play("jump_check")
				jump_progression = 1

		1: # check
			if Input.is_action_just_pressed("A") && checking:
				successful_jump = true
				state = "jump_air"
				mario_anime.queue("jump_air")

		2: # check (excellent)
			if Input.is_action_just_pressed("A") && checking_dx:
				state = "jump_excellent"
				mario_anime.play("jump_excellent")


func hammer_action():
	pass


func bros_action():
	pass


func run_action():
	pass


func item_action():
	pass
