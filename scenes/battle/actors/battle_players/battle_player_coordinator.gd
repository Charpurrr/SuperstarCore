class_name BattlePlayerCoordinator
extends Node2D
# Coordinates the battle players inside of this node

@onready var enemy_coordinator : EnemyCoordinator = %Enemies
@onready var battle_players : Dictionary = {
	mario = $%Mario,
	luigi = $%Luigi,
} # What battle players exist

@export var enabled_battle_players : Dictionary = {
	mario = true,
	luigi = true,
} # What battle players are enabled

var bp_associated_action : Dictionary = {
	mario = "A",
	luigi = "B",
} # The associated action button for each battle player

var current_fighter_key : String # Member that is currently attacking

var starting_pos_order : Array = ["mario", "luigi",] # Priority order 
var starting_pos : Dictionary = {
	mario = null,
	luigi = null,
} # stored idle positions of party members on the battlefield


func _ready():
	set_battle_player_pos()
	set_starter_fighter()
	free_unnecessary()


func set_battle_player_pos(): # Set battle players' initial positions based on which ones are enabled
	var enabled_battle_players_count : int = 0

	for battle_player in enabled_battle_players:
		if enabled_battle_players[battle_player]:
			starting_pos[battle_player] = battle_players[battle_player].position
			enabled_battle_players_count += 1

	match enabled_battle_players_count:
		0: # Noone enabled
			@warning_ignore("assert_always_false")
			assert(false, "No battle players present.")
		1: # One battle player enabled
			for battle_player in enabled_battle_players:
				battle_players[battle_player].position = Vector2(150, 175)
				break
		2: # 2 battle players enabled
			battle_players[starting_pos_order[0]].position = Vector2(150, 100)
			battle_players[starting_pos_order[1]].position = Vector2(150, 200)
			# fails if 3 bps exist (FIX TORMROWW)


func free_unnecessary(): # Delete disabled battle players
	for key in battle_players:
		if not enabled_battle_players[key]:
			battle_players[key].queue_free()


func set_starter_fighter(): # Set which battle player attacks initially depending on their speed
	var highest_speed = 0

	for key in enabled_battle_players:
		if enabled_battle_players[key]:
			var speed = BattlePlayerStats.stats[key].spd

			if speed > highest_speed:
				highest_speed = speed

				current_fighter_key = key
				get_current_fighter().is_fighter = true


func get_current_fighter() -> BattlePlayer: # Return the current battling player node (fighter)
	return battle_players[current_fighter_key]


func get_key(node: BattlePlayer) -> String: # Get the key for passed battle player
	for key in battle_players:
		if battle_players[key] == node:
			return key

	return ""


func get_key_wait(node: BattlePlayer) -> String: # get_key() but it waits until loaded
	await ready
	return get_key(node)
