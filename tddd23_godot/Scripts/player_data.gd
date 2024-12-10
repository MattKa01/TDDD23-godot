extends Node

var health = 100
var damage = 50
var collected_items = []
var unlocked_additional_attack = 1
var unlocked_block = false
var dcd = 3
var max_health = 100
var deaths = 0
var tutorial = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_death():
	deaths += 1

func set_data(h, d, c, ua, ub, d_cd, mh):
	health = h
	damage = d
	collected_items = c
	unlocked_additional_attack = ua
	unlocked_block = ub
	dcd = d_cd
	max_health = mh

func reset_data():
	health = 100
	damage = 50
	collected_items = []
	unlocked_additional_attack = 1
	unlocked_block = false
	dcd = 3
	max_health = 100
	deaths = 0

func set_tutorial(s):
	tutorial = s
