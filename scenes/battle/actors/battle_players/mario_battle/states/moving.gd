class_name MovingState
extends State
# Moving toward or from an enemy

var tweening : bool


func _process(_delta):
	print(state_coordinator.active_state)
	match state_coordinator.active_state:
		"j_moving_toward": # Moving toward the enemy for a jump attack
			pass
		"h_moving_toward": # Moving toward the enemy for a hammer attack
			if not tweening:
				var final_pos = actor.bp_coordinator.enemy_coordinator.final_enemy.hammer_holo_pos

				tweening = true
				MathUtility.tween_current_pos_to(actor, final_pos, 30, self)


func tween_finished(): # Called when a tween is finished interpolating
	tweening = false
	state_coordinator.active_state = "atk_hammering"
