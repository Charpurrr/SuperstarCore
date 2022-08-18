extends ResourcePreloader

onready var mario_actor = $"%Actor"

func _process(delta):
	match mario_actor.jump_progression:
		1:
			mario_actor.checking = true
			yield(get_tree().create_timer(0.33), "timeout")
			mario_actor.checking = false
			if mario_actor.successful_jump == false:
				mario_actor.state = "jump_fail"
		2:
			mario_actor.checking_dx = true
			yield(get_tree().create_timer(0.33), "timeout")
			mario_actor.checking_dx = false
			if mario_actor.successful_jump_dx == false:
				mario_actor.state = "jump_fail"


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"jump_air":
			mario_actor.jump_progression = 2
			mario_actor.checking_dx = true
		"jump_excellent":
			mario_actor.jump_progression = 3
			mario_actor.checking_dx = false
