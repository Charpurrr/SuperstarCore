class_name BattlePlayer
extends CharacterBody2D
# A playable party member in the battle arena

@onready var action_commands : Node2D = $"../../ActionCommands"
@onready var battle_player_coordinator : BattlePlayerCoordinator = get_parent()
@onready var state_coordinator : BPStateCoordinator = $States

var action_button : String # The associated action button for this battle player
var fighter_key : String # Dictionary key for this battle player

var is_fighter : bool = false # Check if it's currently this battle player's turn


func _ready():
	fighter_key = await battle_player_coordinator.get_key_wait(self)
	action_button = battle_player_coordinator.bp_associated_action[fighter_key]
