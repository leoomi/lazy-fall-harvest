class_name Wallet
extends Node

signal coins_changed(coins: int)

@export var coins = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	coins_changed.emit(coins)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func add_amount(coins: int):
	self.coins += coins
	coins_changed.emit(self.coins)
