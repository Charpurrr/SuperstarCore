extends ResourcePreloader

onready var actor : KinematicBody2D = get_parent()
onready var rating_sprite : AnimatedSprite = $"../../../Rating"
onready var rating_anime : AnimationPlayer = $"../../../Rating/AnimationPlayerRating"

var temp_rating : String = "" # Only used for the rating graphic

var check_timer : float = 0.0 # In frames

var checking_ok : bool = false # From frame 41 - 79
var checking_good : bool = false # From frame 50 - 60
var checking_great : bool = false
var checking_excellent : bool = false # From 121

var check_timings : Array = [
	[41.0, "checking_ok"],
	[50.0, "checking_good"],
	[0.0, "checking_great"],
	[121.0, "checking_excellent"]
]

# List of different ratings

# NAME               ACTIVATION METHOD

# "Fail"             (jump_rated == false after jump_check animation)
# "OK"               (A jump input is detected whilst checking_ok == true)
# "Good"             (A jump input is detected whilst checking_good == true)
# "Good_cancelled"   (No input is detected during successful_jump)
# "Great"            (A jump input is detected whilst checking_great == true)
# "Excellent"        (A jump input is detected whilst checking_excellent == true)

func _process(_delta):
	if actor.checking_jump_rating == true:
		check_timer += 1.0 * _delta * 60.0

		# Sets checking_x to true based on the value of check_timer
		for check in check_timings:
			var timing = check[0]
			var var_name = check[1]
			if check_timer >= timing:
				set(var_name, true)

		if checking_ok:
			if Input.is_action_just_pressed("A"):
				actor.jump_rated = true
				actor.checking_jump_rating = false
				check_timer = 0.0
				temp_rating = "OK"
				actor.jump_rating = "OK"

#		if checking_good:
#			if Input.is_action_just_pressed("A"):
#				actor.jump_rated = true
#				actor.checking_jump_rating = false
#				check_timer = 0.0
#				temp_rating = "Good"
#				actor.jump_rating = "Good"
#
#			if check_timer >= 60:
#				checking_good = false
#
#		if checking_great:
#			if Input.is_action_just_pressed("A"):
#				actor.jump_rated = true
#				actor.checking_jump_rating = false
#				check_timer = 0.0
#				temp_rating = "Great"
#				actor.jump_rating = "Great"
#
#		if checking_excellent:
#			if Input.is_action_just_pressed("A"):
#				actor.jump_rated = true
#				actor.checking_jump_rating = false
#				check_timer = 0.0
#				temp_rating = "Excellent"
#				actor.jump_rating = "Excellent"

		# FALSE rating is handled in _on_AnimationPlayer_animation_finished()

#	theprintisreal2401()

	# Resets checking_x to false after this script finishes checking
	for check in check_timings:
		var var_name = check[1]
		set(var_name, false)


func theprintisreal2401():
	# Debug print - very useful!
	print(
	"TIME", check_timer, "\n",
	"OK ", checking_ok, "\n",
	"GOOD ", checking_good, "\n",
	"GREAT ", checking_great, "\n",
	"EXCELLENT ", checking_excellent, "\n",
	"______________________________"
	)


func show_rating():
	rating_sprite.visible = true
	rating_sprite.animation = temp_rating
	rating_anime.play("pop_out")


#func initiate_enemy_hurt():
#	for enemy in actor.enemy_category.get_children():
#		if enemy.index == GlobalSingletonShared.final_selected_enemy:
#			enemy.anime_state = "hurt"
#			enemy.anime.play("hurt")
#			yield(get_tree().create_timer(0.33), "timeout")
#			enemy.anime_state = "idle"


func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"jump_check":
			if actor.jump_rated == false:
				actor.jump_rated = true
				actor.checking_jump_rating = false
				check_timer = 0.0
				temp_rating = "Fail"
				actor.jump_rating = "Fail"

#		"jump_successful":
#			actor.jump_stage = 4
#			print("wah")
#			actor.anime_state = "jump_successful_dx"
#			actor.anime_player.play("jump_successful_dx")
#
#		"jump_successful_dx":
#			print("zhbfduazfh")
#			actor.jump_stage = 5
