class_name PlantablePlot
extends Node2D

const type = preload("res://scripts/PlantType.gd")
@export var text_label: RichTextLabel
@export var texture_path: String
@export var plant_transform: Node2D
@export var plant_scene: PackedScene
var current_plant: Plant
var seed_bag: SeedBag
var wallet: Wallet
var plant_data: Node

# Called when the node enters the scene tree for the first time.
func _ready():
	seed_bag = get_node("/root/Map/SeedBag")
	wallet = get_node("/root/Map/Wallet")
	plant_data = get_node("/root/Map/PlantData")
	set_coin_text("-5")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_detector_area_entered(area):
	if current_plant == null or current_plant.growth == 2:
		$Arrow.show()

	text_label.show()

func _on_player_detector_area_exited(area):
	$Arrow.hide()
	text_label.hide()

func set_coin_text(text: String):
	if not text:
		text_label.text = ""
		return

	text_label.text = convert_text(text)

func convert_text(text: String) -> String:
	var final_str = ""
	for char in text:
		final_str += "[img]%s%s.png[/img]" % [texture_path, char]
	
	final_str += "[img]%s%s.png[/img]" % [texture_path, "coin"]
	return final_str
	
func do_action():
	if current_plant == null:
		plant_seed()
		return
		
	if current_plant.growth == 2:
		harvest()
		return

func plant_seed():
	if current_plant != null or wallet.coins < 5:
		print("can't plant")
		return

	$PlantingSound.play()
	wallet.add_amount(-5)
	$Arrow.hide()

	current_plant = plant_scene.instantiate()
	current_plant.init(plant_data, seed_bag.current_type)
	add_child(current_plant)
	current_plant.position = plant_transform.position
	set_coin_text("")
	seed_bag.change_plant()

	current_plant.growth_finished.connect(on_plant_growth)

func harvest():
	$HarvestSound.play()
	current_plant.harvest()
	wallet.add_amount(50)
	$Arrow.show()
	set_coin_text("-5")

func on_plant_growth():
	$Arrow.show()
	set_coin_text("+50")
