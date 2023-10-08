extends CanvasLayer

@export var coin_label: RichTextLabel
@export var plant_texture: TextureRect
@export var texture_path: String

func _on_purse_coins_changed(coins: int):
	var str = str(coins)
	var final_str = "[img=24]%s%s.png[/img]" % [texture_path, "coin"]
	
	for char in str:
		final_str += "[img]%s%s.png[/img]" % [texture_path, char]

	coin_label.text = final_str

func _on_seed_bag_seed_changed(texture: Texture2D):
	plant_texture.texture = texture
