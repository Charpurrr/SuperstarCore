class_name HammeringState
extends AttackState
# Performing a hammer attack

const PHASES : PackedStringArray = ["start", "windup"] # Phases of this state
var current_phase : String # Which phase this state is currently on

var check_timer : float = 0.0 # How many frames have passed since starting the swing

var checking_ok : bool = false # From frame 1 - 21
var checking_good : bool = false # From frame 22 - 33
var checking_great : bool = false # From frame 34 - 45
var checking_excellent : bool = false # From frame 46 - 57

var check_timings : Array = [
	[0, "checking_ok"],
	[22, "checking_good"],
	[34, "checking_great"],
	[46, "checking_excellent"]
] # The timings for every rating


func _ready():
	current_phase = PHASES[0]


#func _process(delta):
#	if state_coordinator.active_state == "atk_hammering":
#		match current_phase:
#			PHASES[0]: # start
#				doll.play("hammer_start")
#
#			PHASES[1]: # windup
#				start_check_timer(delta)
#
#				if Input.is_action_just_pressed(actor.action_button):
#					pass


func start_check_timer(delta):
	check_timer += 1.0 * 60.0 * delta

	for check in check_timings:
		var timing = check[0]
		var var_name = check[1]
		if check_timer >= timing:
			set(var_name, true)


func _on_doll_animation_finished():
	match doll.animation:
		"hammer_start":
			doll.play("hammer_windup")
			current_phase = PHASES[1]
