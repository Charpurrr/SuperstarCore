extends Node

# 1: Mario solo, 2: Luigi solo, 3: Both bros
export(int, 1, 3) var arena_type
onready var enemy_list : Node = $"%Enemies"

export(int, "Texture", "Model") var backdrop_type
export(int, 1) var backdrop_ID # Check %Backdrop2D for the IDs
onready var backdrop_2d : AnimatedSprite = $"%Backdrop2D"

onready var mario : Node = $"%Mario"
onready var luigi : Node = $"%Luigi"


func _ready():
	set_enemy_count()
	match backdrop_type:
		0: # 2D
			set_backdrop_2D()
		1: # 3D, THESE REQUIRE A LOT OF WORK, ADVISING PRE-RENDERS
			set_backdrop_3D()

	match arena_type:
		1:
			mario.visible = true
			luigi.visible = false
			mario.position = Vector2(150, 175)
			mario.origin_point = mario.position
		2:
			luigi.visible = true
			mario.visible = false
			luigi.position = Vector2(150, 175)
			# Add origin point here
		3:
			luigi.visible = true
			mario.visible = true
			mario.position = Vector2(150, 100)
			mario.origin_point = mario.position
			luigi.position = Vector2(150, 200)
			# Add origin point here


func set_enemy_count():
	GlobalSingletonShared.amount_enemies_field = enemy_list.get_child_count()


func set_backdrop_2D():
	backdrop_2d.animation = str(backdrop_ID)


func set_backdrop_3D():
	breakpoint # Not doing this until much later lel
