extends CanvasLayer
var item1 = 0
var item2 = 0
var item3 = 0
var item4 = 0
var item5 = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if len(PlayerData.collected_items) != 0:
		for i in PlayerData.collected_items:
			match i[2]:
				1:
					item1 += 1
				2:
					item2 += 1
				3:
					item3 += 1
				4:
					item4 += 1
				5:
					item5 += 1
	
	$Sprite2D/Label1.text = str(item1)
	$Sprite2D2/Label2.text = str(item2)
	$Sprite2D3/Label3.text = str(item3)
	$Sprite2D4/Label4.text = str(item4)
	$Sprite2D5/Label5.text = str(item5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
