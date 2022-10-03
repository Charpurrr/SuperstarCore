extends ResourcePreloader

onready var mario : KinematicBody2D = get_parent()


func _process(delta):
	match mario.jump_stage:
		2:
			mario.anime_state = "jump_check"
			mario.mario_anime.play("jump_check")
			mario.checking = true

			if Input.is_action_just_pressed("A") && mario.checking:
				mario.successful_jump = true
				mario.anime_state = "jump_air"
				mario.mario_anime.queue("jump_air")

			yield(get_tree().create_timer(0.33), "timeout") # 0.33 because that's the length of the animation in the AP
			mario.checking = false
			# fail code (also parabola curve)
			if mario.successful_jump == false:
				mario.anime_state = "jump_fail"
				mario.mario_anime.stop()
				mario.jump_action_failed() # Handles the parabola curve

#		3:
#			mario.checking_dx = true
#			yield(get_tree().create_timer(0.33), "timeout") # 0.33 because that's the length of the animation in the AP
#			mario.checking_dx = false
#			if mario.successful_jump_dx == false:
#				mario.anime_state = "jump"


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"jump_successful":
			mario.jump_stage = 4
			mario.checking_dx = true
		"jump_successful_dx":
			mario.jump_stage = 5
			mario.checking_dx = false
