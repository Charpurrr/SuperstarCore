extends Node2D

@onready var battle_players : Dictionary = {
	mario = $%Mario,
	luigi = $%Luigi,
} # What battle players exist
@export var enabled_battle_players : Dictionary = {
	mario = true,
	luigi = true,
} # What battle players are enabled

var current_fighter : String # Member that is currently attacking

var starting_pos : Dictionary = {
	mario = null,
	luigi = null,
} # stored idle positions of party members on the battlefield


func _ready():
	set_battle_player_pos()
	free_unnecessary()

	for key in enabled_battle_players:
		if enabled_battle_players[key]:
			current_fighter = key
			break
			# SAVE EDIT TO FIGURE OUT IF SPEED AFFECTS STARTING PLAYER


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


func get_current_fighter() -> BattlePlayer: # Return the current battling player (fighter)
	return battle_players[current_fighter]
