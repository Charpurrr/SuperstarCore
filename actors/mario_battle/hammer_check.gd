extends ResourcePreloader

onready var actor : KinematicBody2D = get_parent()
onready var rating_sprite : AnimatedSprite = $"../../../Rating"
onready var rating_anime : AnimationPlayer = $"../../../Rating/AnimationPlayerRating"

var temp_rating : String = "" # Only used for the rating graphic

var check_timer : float = 0.0 # In frames

var checking_ok : bool = false # From frame 1 - 21
var checking_good : bool = false # From frame 22 - 33
var checking_great : bool = false # From frame 34 - 45
var checking_excellent : bool = false # From frame 46 - 57

var check_timings : Array = [
	[0.0, "checking_ok"],
	[22.0, "checking_good"],
	[34.0, "checking_great"],
	[46.0, "checking_excellent"]
]

# List of different ratings

# NAME               ACTIVATION METHOD

# "Fail"             (rated == false after hammer_windup)
# "OK"               (A hammer input is detected whilst checking_ok == true)
# "Good"             (A hammer input is detected whilst checking_good == true)
# "Great"            (A hammer input is detected whilst checking_great == true)
# "Excellent"        (A hammer input is detected whilst checking_excellent == true)

func _process(_delta):
	if actor.checking_hammer_rating == true:
		check_timer += 1.0 * _delta * 60.0

		# Sets checking_x to true based on the value of check_timer
		for check in check_timings:
			var timing = check[0]
			var var_name = check[1]
			if check_timer >= timing:
				set(var_name, true)

		if checking_ok:
			if Input.is_action_just_pressed("A"):
				actor.hammer_rated = true
				actor.checking_hammer_rating = false
				check_timer = 0.0
				temp_rating = "OK"
				actor.hammer_rating = "OK"

		if checking_good:
			if Input.is_action_just_pressed("A"):
				actor.hammer_rated = true
				actor.checking_hammer_rating = false
				check_timer = 0.0
				temp_rating = "Good"
				actor.hammer_rating = "Good"

		if checking_great:
			if Input.is_action_just_pressed("A"):
				actor.hammer_rated = true
				actor.checking_hammer_rating = false
				check_timer = 0.0
				temp_rating = "Great"
				actor.hammer_rating = "Great"

		if checking_excellent:
			if Input.is_action_just_pressed("A"):
				actor.hammer_rated = true
				actor.checking_hammer_rating = false
				check_timer = 0.0
				temp_rating = "Excellent"
				actor.hammer_rating = "Excellent"

		# FALSE rating is handled in _on_Puppet_animation_finished()

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


func _on_Puppet_animation_finished():
	if actor.hammer_windupped and actor.hammer_rated == false:
		actor.hammer_rated = true
		actor.checking_hammer_rating = false
		check_timer = 0.0
		temp_rating = "Fail"
		actor.hammer_rating = "Fail"
