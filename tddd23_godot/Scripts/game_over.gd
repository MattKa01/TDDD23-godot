extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if WinCondition.friend_alive and WinCondition.enemies_alive == 0:
		$SavedAndWin.visible = true
	elif WinCondition.friend_alive and WinCondition.enemies_alive > 0:
		$SavedAndLose.visible = true
	else:
		$Lose.visible = true
		
	$Info.text = "Deaths: " + str(PlayerData.deaths) + " Items collected: " + str(len(PlayerData.collected_items))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_button_up() -> void:
	PlayerData.reset_data()
	get_tree().change_scene_to_file("res://Scenes/Base_level.tscn")
