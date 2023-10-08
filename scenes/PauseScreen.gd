extends CanvasLayer

var player: Player
var enabled = false
var current_scene = 1

func _ready():
	player = get_node("/root/Map/Player")

func _process(delta):
	if not enabled:
		return

	if Input.is_action_just_pressed("move_right"):
		if current_scene == 1 or current_scene == 2:
			current_scene += 1
			update_page()

	if Input.is_action_just_pressed("move_left"):
		if current_scene == 2 or current_scene == 3:
			current_scene -= 1
			update_page()

func update_page():
	for i in range(1, 4, 1):
		get_child(i).hide()
	
	get_child(current_scene).show()
