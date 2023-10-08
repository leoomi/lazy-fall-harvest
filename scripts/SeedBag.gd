class_name SeedBag
extends Node

const type = preload("res://scripts/PlantType.gd")

signal seed_changed(texture: Texture2D)
var current_type: type.Enum = type.Enum.CARROT
var current_plant_data: Node
var plant_data: Node

func _ready():
	plant_data = get_node("/root/Map/PlantData")
	change_plant()

func change_plant():
	var random_plant = randi_range(0, type.Enum.PUMPKIN)
	current_type = random_plant as type.Enum
	current_plant_data = plant_data.get_child(random_plant)

	var sprite = current_plant_data.get_child(2) as Sprite2D
	seed_changed.emit(sprite.texture)
