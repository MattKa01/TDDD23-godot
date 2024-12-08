extends Node2D

@onready var items = {
	"item1": [$Bonus_attack_item,"Add 1 attack to chain", 1],
	"item2": [$Bonus_damage_item,"increase damage by 25", 2],
	"item3": [$Bonus_health_item, "Increase health by 50", 3],
	"item4": [$More_dash_item, "Less cooldown on dash", 4],
	"item5": [$Block_item, "Unlock block", 5],
}
var player_in = false
var used = false
var disabled = false
var choices

signal choose_item(item)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_in and not used:
		choices = show_items()
	
	if not disabled:
		if Input.is_action_just_pressed("choose_item_1") and player_in: #and used: #debug remove used
			choose_item.emit(choices[0])
			for item in items:
				items[item][0].visible = false
			disabled = true
	
		elif Input.is_action_just_pressed("choose_item_2") and player_in: #and used: #debug remove used
			choose_item.emit(choices[1])
			for item in items:
				items[item][0].visible = false
			disabled = true

func show_items():
	#debug below
	for item in items:
		items[item][0].visible = false
	
	var choice1 = items["item"+str(randi_range(1,5))]
	var choice2 = items["item"+str(randi_range(1,5))]
	
	choice1[0].position.y = -100
	choice1[0].position.x = -50
	
	choice2[0].position.y = -100
	choice2[0].position.x = 50
	
	choice1[0].visible = true
	choice2[0].visible = true
	
	#comment out for debug
	#used = true
	
	return [choice1, choice2]

func _on_player_detection_body_entered(body: Node2D) -> void:
	player_in = true


func _on_player_detection_body_exited(body: Node2D) -> void:
	player_in = false
