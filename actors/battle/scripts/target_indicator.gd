class_name TargetIndicator
extends AnimatedSprite2D
# A UI element that helps you target a specific enemy/enemies

@onready var bp_coordinator : BattlePlayerCoordinator = %BattlePlayers
@onready var enemy_coordinator : EnemyCoordinator = %Enemies
@onready var bp_state_coordinator : BPStateCoordinator
@onready var current_fighter : BattlePlayer

var target_slot_positions : PackedVector2Array # A list of all the target slot positions
var enemies : Array # A list of all the enemy nodes

var selected_enemy_index : int = 0 # Which enemy (index) in the enemy list is currently selected

var current_frame : float # Current frame of the sprite animation

const TWEEN_DELAY : int = 5 # How fast the target indicator moves toward its target

const INIT_CYCLE_DELAY : int = 25 # How fast you can cycle through enemies (initially)
const CYCLE_DELAY : int = 10 # How fast you can cycle through enemies (when holding)
var init_cycle_timer : int # How far along the initial delay is
var cycle_timer : int # How far along the held delay is

var can_tween : bool = true # Check if the target indicator can tween


func _ready():
	set_slot_pos()
	set_enemies()

	enemies[selected_enemy_index].is_selected = true
	position = enemies[0].target_slot_pos


func _process(_delta):
	current_fighter = bp_coordinator.get_current_fighter()
	bp_state_coordinator = current_fighter.state_coordinator

	frame = enemy_coordinator.target_slot_frame

	if bp_state_coordinator.active_state == "selecting_target":
		input()

		play("attack_select_%s" % bp_coordinator.get_key(current_fighter))
		visible = true

		cycle_timer = max(cycle_timer - 1, 0)

		if Input.get_vector("left", "right", "up", "down") == Vector2.ZERO:
			init_cycle_timer = INIT_CYCLE_DELAY

		for index in enemies.size():
			enemies[index].is_selected = index == selected_enemy_index
			enemies[index].target_slot.visible = not enemies[index].is_selected
	else:
		visible = false

		for enemy in enemy_coordinator.loaded_layout.get_children():
			enemy.target_slot.visible = false


func input(): # Handle input related stuff when called
	if Input.get_axis("left", "right"):
		cycle(Input.get_axis("left", "right"))
	elif Input.get_axis("down", "up"):
		cycle(Input.get_axis("down", "up"))
	else:
		cycle_timer = 0

	if Input.is_action_just_pressed(bp_coordinator.get_current_fighter().action_button):
		enemy_coordinator.final_enemy = enemies[selected_enemy_index]


func set_slot_pos(): # Fill the target hologram positions array with all of the loaded holograms
	for enemy in enemy_coordinator.loaded_layout.get_children():
		target_slot_positions.append(enemy.target_slot_pos)


func set_enemies():
	enemies = enemy_coordinator.loaded_layout.get_children()


func sync_anim(fps): # Sync the bobbing animation even when sprite animation is changed
	current_frame = wrapf(current_frame + float(fps)/60.0, 0, sprite_frames.get_frame_count(animation))
	frame = int(current_frame)


func can_cycle() -> bool: # Check if you're able to cycle between enemies
	return (cycle_timer == 0 and 
	(init_cycle_timer == 0 or init_cycle_timer == INIT_CYCLE_DELAY) and
	can_tween)


func cycle(direction): # Cycle between enemies
	if can_cycle():
		selected_enemy_index = wrapi(selected_enemy_index + direction, 0, enemy_coordinator.enemy_amt)

		MathUtility.tween_current_pos_to(self, target_slot_positions[selected_enemy_index], TWEEN_DELAY, self)
		cycle_timer = max(cycle_timer - 1, 0)
		can_tween = false

	init_cycle_timer = max(init_cycle_timer - 1, 0)


func tween_finished(): # Called when a tween is finished interpolating
	cycle_timer = CYCLE_DELAY
	can_tween = true
