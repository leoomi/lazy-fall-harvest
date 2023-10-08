class_name ExpandSign
extends Node2D

@export var text_label: RichTextLabel
var camera: Camera2D
var wallet: Wallet

func _ready():
	camera = get_node("/root/Map/Player/Camera2D")
	wallet = get_node("/root/Map/Wallet")

func _on_player_detector_area_entered(area):
	$Arrow.show()
	text_label.show()

func _on_player_detector_area_exited(area):
	$Arrow.hide()
	text_label.hide()

func do_action():
	if wallet.coins < 200:
		return

	wallet.add_amount(-200)
	queue_free()
	camera.limit_left -= 260
