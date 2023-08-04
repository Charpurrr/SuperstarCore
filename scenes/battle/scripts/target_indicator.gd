class_name TargetIndicator
extends AnimatedSprite2D
# A UI element that helps you target a specific enemy/enemies

@onready var enemy : CharacterBody2D = get_parent()

@onready var bp_state_coordinator : BPStateCoordinator
@onready var current_fighter : BattlePlayer

var selected_enemy_index : int = 0 # Which (index) enemy in the list is currently selected

var current_frame : float # Current frame of the sprite animation


func _ready():
	play("attack_deselect")


func _process(_delta):
	sync_anim(5.0) # Has to be a float

	current_fighter = enemy.bp_coordinator.get_current_fighter()
	bp_state_coordinator = current_fighter.state_coordinator

	if bp_state_coordinator.active_state == "selecting_target":
		visible = true

		if selected_enemy_index == enemy.index:
			animation = ("attack_select_%s" % enemy.bp_coordinator.get_key(current_fighter))
		else:
			animation = "attack_deselect"

		if Input.is_action_pressed("right"):
			selected_enemy_index = wrapi(selected_enemy_index + 1, 0, enemy.enemy_coordinator.enemy_amt)
		if Input.is_action_pressed("left"):
			selected_enemy_index = wrapi(selected_enemy_index - 1, 0, enemy.enemy_coordinator.enemy_amt)

		if Input.is_action_just_pressed(enemy.bp_coordinator.get_current_fighter().action_button):
			enemy.enemy_coordinator.final_enemy = selected_enemy_index
	else:
		visible = false


func sync_anim(fps): # Sync the bobbing animation even when sprite animation is changed
	current_frame = wrapf(current_frame + fps/60.0, 0, sprite_frames.get_frame_count(animation))
	@warning_ignore("narrowing_conversion")
	frame = current_frame
