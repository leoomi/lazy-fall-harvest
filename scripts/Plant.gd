class_name Plant
extends Node2D

signal growth_finished()
signal harvested()

const type = preload("res://scripts/PlantType.gd")
@export var growth_time = 120
var current_type: type.Enum = type.Enum.CARROT
var plant_data: Node = null
var current_plant_data: Node = null
var growth: int = 0
var growth_progress: float= 0
var right_plant: Plant
var left_plant: Plant
var neighbors = 0

func init(plant_data: Node, type: type.Enum):
	print(type)
	current_type = type
	current_plant_data = plant_data.get_child(type)
	$Sprite2D.texture = current_plant_data.get_child(growth).texture

func _process(delta):
	if growth == 2:
		return

	var growth_rate = 1.0
	if neighbors > 0:
		growth_rate *= (1.0 / (3.0 * neighbors))
	growth_progress += delta * growth_rate
	
	if growth_progress > growth_time:
		grow()
		growth_progress = 0

func grow():
	if growth >= 2:
		return

	growth += 1
	$Sprite2D.texture = current_plant_data.get_child(growth).texture
	
	if growth == 2:
		$Sound.play()
		growth_finished.emit()
	
	if right_plant:
		check_same_crop(right_plant)

func harvest():
	harvested.emit()
	queue_free()

func set_red_arrows():
	assert(neighbors >= 0 and neighbors <= 2, "Invalid number of neighbors")
	$RedArrow.hide()
	$DoubleRedArrow.hide()

	if neighbors == 1:
		$RedArrow.show()
	if neighbors == 2:
		$DoubleRedArrow.show()

func _on_right_area_entered(area):
	right_plant = area.owner as Plant
	neighbors += 1
	set_red_arrows()
	check_same_crop(right_plant)

func _on_left_area_entered(area):
	left_plant = area.owner as Plant
	neighbors += 1
	set_red_arrows()

func _on_right_area_exited(area):
	right_plant = null
	neighbors -= 1
	set_red_arrows()

func _on_left_area_exited(area):
	left_plant = null
	neighbors -= 1
	set_red_arrows()

func check_same_crop(plant: Plant):
	print(plant.current_type, " ", current_type, " ", plant.growth, " ", growth)
	if plant.current_type == current_type && plant.growth == growth && growth < 2:
		plant.grow()
		queue_free()
