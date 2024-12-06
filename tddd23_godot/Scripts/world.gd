extends Node2D

var player
var enemy
var enemies = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	enemy = $Skeleton_enemy
	enemies.append(enemy)
	player.attack.connect(_handle_playerattack)
	enemy.enemy_attack.connect(_handle_enemyattack)
	$Shop.play("default")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_enemyattack(damage):
	print("enemy attack")
	player.take_damage(damage)

func _handle_playerattack(body, damage):
	for scene in enemies:
		if scene == body:
			scene.take_damage(damage)
