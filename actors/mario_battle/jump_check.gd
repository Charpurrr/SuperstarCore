extends ResourcePreloader

onready var mario : KinematicBody2D = get_parent()

var check_timer : float = 0.0 # In frames

var checking_ok : bool = false # From frame 41 - 79
var checking_good : bool = false # From frame 50 - 60
var checking_great : bool = false
var checking_excellent : bool = false # From 121

var rated : bool = false

# List of different ratings
# "Fail"             (Rated == false after jump_check)
# "OK"               (A jump input is detected whilst checking_ok == true)
# "Good"             (A jump input is detected whilst checking_good == true)
# "Good_cancelled"   (No input is detected during successful_jump)
# "Great"            (A jump input is detected whilst checking_great == true)
# "Excellent"        (A jump input is detected whilst checking_excellent == true)


func _process(_delta):
#	print(checking_ok, " OK")
#	print(checking_good, " GOOD")
#	print(mario.jump_rating)
#	print(check_timer)
#	print(mario.jump_stage)
	if mario.checking_jump_rating == true:
		check_timer += 1.0 * _delta * 60.0

		if check_timer >= 41:
			checking_ok = true
		if check_timer >= 50:
			checking_good = true
		if check_timer >= 60:
			checking_good = false
		if check_timer >= 79:
			check_timer = 0
			mario.checking_jump_rating = false
			if rated == false:
				mario.jump_rating = "Fail"


	match mario.jump_stage:
		3: # Checking rating
			initiate_enemy_hurt()
			mario.anime_state = "jump_check"
			mario.mario_anime.play("jump_check")

			match mario.jump_rating:
				"Fail":
					mario.jump_action_cancelled(_delta)
				"OK":
					pass

				"Good":
					pass

				"Great":
					pass

				"Excellent":
					pass

func _input(_event):
	if Input.is_action_just_pressed("A"):
		if checking_ok == true && checking_good == false && rated == false:
			rated = true
			mario.jump_rating = "OK"
		elif checking_good == true && rated == false:
			rated = true
			mario.jump_rating = "Good"


func initiate_enemy_hurt():
	for enemy in mario.enemy_category.get_children():
		if enemy.index == GlobalSingletonShared.final_selected_enemy:
			enemy.anime_state = "hurt"
			enemy.anime.play("hurt")
			yield(get_tree().create_timer(0.33), "timeout")
			enemy.anime_state = "idle"


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"jump_check":
			mario.checking_jump_rating = false
			checking_ok = false
			if mario.jump_rating == "Good":
				mario.anime_state = "jump_successful"
				mario.mario_anime.play("jump_successful")
			else:
				mario.jump_rating = "Fail"

#		"jump_successful":
#			mario.jump_stage = 4
#			print("wah")
#			mario.anime_state = "jump_successful_dx"
#			mario.mario_anime.play("jump_successful_dx")
#
#		"jump_successful_dx":
#			print("zhbfduazfh")
#			mario.jump_stage = 5
