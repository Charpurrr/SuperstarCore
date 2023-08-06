class_name BattlePlayerCoordinator
extends Node2D
# Coordinates the battle players inside of this node

@onready var battle_players : Dictionary = {
	mario = $%Mario,
	luigi = $%Luigi,
} # What battle players exist

var bp_associated_action : Dictionary = {
	mario = "A",
	luigi = "B",
} # The associated action button for each battle player

@export var enabled_battle_players : Dictionary = {
	mario = true,
	luigi = true,
} # What battle players are enabled

var current_fighter_key : String # Member that is currently attacking

var starting_pos : Dictionary = {
	mario = null,
	luigi = null,
} # stored idle positions of party members on the battlefield


func _ready():
	set_battle_player_pos()
	set_starter_fighter()
	free_unnecessary()


func set_battle_player_pos(): # Set battle players' initial positions based on which ones are enabled
	if enabled_battle_players["mario"] and enabled_battle_players["luigi"]: # Both Bros.
		battle_players["mario"].position = Vector2(150, 100)
		battle_players["luigi"].position = Vector2(150, 200)
	elif enabled_battle_players["mario"] and not enabled_battle_players["luigi"]: # Solo Mario
		battle_players["mario"].position = Vector2(150, 175)
	elif not enabled_battle_players["mario"] and enabled_battle_players["luigi"]: # Solo Luigi
		battle_players["luigi"].position = Vector2(150, 175)
	else: # NOONE?? ENABLE SOMEONE??
		@warning_ignore("assert_always_false")
		assert(false, "No battle players present.")

	starting_pos["mario"] = battle_players["mario"].position
	starting_pos["luigi"] = battle_players["luigi"].position


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
