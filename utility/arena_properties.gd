extends Node

@export var backdrop_ID : int # Check %Backdrop2D for the IDs
@onready var backdrop_2d : AnimatedSprite2D = $"%Backdrop2D"


func _ready():
	backdrop_2d.animation = str(backdrop_ID)
