extends Node

var health = 100
var damage = 50
var collected_items = []
var unlocked_additional_attack = 1
var unlocked_block = false
var dcd = 3
var max_health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_data(h, d, c, ua, ub, d_cd, mh):
	health = h
	damage = d
	collected_items = c
	unlocked_additional_attack = ua
	unlocked_block = ub
	dcd = d_cd
	max_health = mh
