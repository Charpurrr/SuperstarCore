extends OptionButton

onready var mario = $"../Mario"

func _process(delta):
	if get_selected_id() == 0:
		mario.anime_state = "idle"
	if get_selected_id() == 1:
		mario.anime_state = "idle_tired"
	if get_selected_id() == 2:
		mario.anime_state = "thinking"
	if get_selected_id() == 3:
		mario.anime_state = "thinking_tired"
	if get_selected_id() == 4:
		mario.anime_state = "jump"
	if get_selected_id() == 4:
		mario.anime_state = "hammer_fail"
