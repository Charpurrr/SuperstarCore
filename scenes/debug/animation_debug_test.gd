extends OptionButton

onready var mario = $"../Mario/Actor"

func _process(delta):
	if get_selected_id() == 0:
		mario.state = "idle"
	if get_selected_id() == 1:
		mario.state = "idle_tired"
	if get_selected_id() == 2:
		mario.state = "thinking"
	if get_selected_id() == 3:
		mario.state = "thinking_tired"
	if get_selected_id() == 4:
		mario.state = "jump"
