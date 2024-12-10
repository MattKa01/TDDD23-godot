extends Node

var friend_alive
var enemies_alive
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_wincondition(f_alive, e_alive):
	friend_alive = f_alive
	enemies_alive = e_alive
