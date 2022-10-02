extends ResourcePreloader

onready var mario : KinematicBody2D = get_parent()


func _process(delta):
	match mario.jump_stage:
		2:
			mario.checking = true
			yield(get_tree().create_timer(0.33), "timeout") # 0.33 because that's the length of the animation in the AP
			mario.checking = false
			if mario.successful_jump == false:
				mario.anime_state = "jump_fail"
		3:
			mario.checking_dx = true
			yield(get_tree().create_timer(0.33), "timeout") # 0.33 because that's the length of the animation in the AP
			mario.checking_dx = false
			if mario.successful_jump_dx == false:
				mario.anime_state = "jump"


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"jump_successful":
			mario.jump_stage = 4
			mario.checking_dx = true
		"jump_successful_dx":
			mario.jump_stage = 5
			mario.checking_dx = false
