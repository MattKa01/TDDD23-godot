extends Node2D

var player
var shrine
var portal
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	shrine = $shrine
	portal = $Portal
	shrine.choose_item.connect(_handle_choose_item)
	portal.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_choose_item(item):
	player.new_item(item)
	print(player.collected_items)


func _on_area_2d_body_entered(body: Node2D) -> void:
	PlayerData.set_data(
		player.max_health,
		player.damage,
		player.collected_items,
		player.unlocked_additional_attack,
		player.unlocked_block,
		player.dcd,
		player.max_health
	)
	get_tree().change_scene_to_file("res://Scenes/Base_level.tscn")
