class_name ActionCommandsCoordinator
extends Node2D
# Coordinates the action commands inside of this node

@onready var bp_coordinator : BattlePlayerCoordinator = $%BattlePlayers
@onready var action_block : AnimatedSprite2D = $Block

var current_block : String
var active : bool # If action commands should be active

var commands : Array = ["jump", "hammer", "bros", "item", "run",]
var viewed_command : int = 0 # Which action command the player is currently looking at
var selected_command : String # The final command selected by the battle player

const INIT_SELECT_DELAY : int = 40 # How fast you can switch between commands (initially)
const SELECT_DELAY : int = 7 # How fast you can switch between commands (when holding)
var init_select_timer : int # How far along the initial delay is
var select_timer : int # How far along the held delay is

var input : Input


func _process(_delta):
	visible = active

	if active:
		action_block.position = bp_coordinator.starting_pos[bp_coordinator.current_fighter_key]
		action_block.animation = commands[viewed_command]

		select_timer = max(select_timer - 1, 0)

		if Input.is_action_pressed("right"):
			cycle(1)
		if Input.is_action_pressed("left"):
			cycle(-1)

		if not (Input.is_action_pressed("right") or Input.is_action_pressed("left")): 
			init_select_timer = INIT_SELECT_DELAY

		if Input.is_action_just_pressed(bp_coordinator.get_current_fighter().action_button):
			selected_command = commands[viewed_command]


func can_cycle() -> bool: # Check if you're able to cycle between commands yet
	return (select_timer == 0 and 
	(init_select_timer == 0 or init_select_timer == INIT_SELECT_DELAY))


func cycle(direction):
	if can_cycle():
		viewed_command = wrapi(viewed_command + direction, 0, commands.size())
		select_timer = SELECT_DELAY
	init_select_timer = max(init_select_timer - 1, 0)


func _on_block_animation_changed():
	select_timer = SELECT_DELAY
