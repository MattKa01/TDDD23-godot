extends Node2D


var player
var enemy
var enemies = []
var boss
var shrine
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	
	enemy = $Skeleton_enemy
	enemies.append(enemy)
	enemy = $Skeleton_enemy2
	enemies.append(enemy)
	enemy = $Skeleton_enemy3
	enemies.append(enemy)
	enemy = $Skeleton_enemy4
	enemies.append(enemy)
	enemy = $Skeleton_enemy5
	enemies.append(enemy)
	enemy = $Skeleton_enemy6
	enemies.append(enemy)
	enemy = $Skeleton_enemy7
	enemies.append(enemy)
	enemy = $Skeleton_enemy8
	enemies.append(enemy)
	enemy = $Skeleton_enemy9
	enemies.append(enemy)
	enemy = $Skeleton_enemy10
	enemies.append(enemy)
	enemy = $Skeleton_enemy11
	enemies.append(enemy)
	enemy = $Skeleton_enemy12
	enemies.append(enemy)
	enemy = $Skeleton_enemy13
	enemies.append(enemy)
	enemy = $Skeleton_enemy14
	enemies.append(enemy)
	enemy = $Skeleton_enemy15
	enemies.append(enemy)
	enemy = $Skeleton_enemy16
	enemies.append(enemy)
	enemy = $Skeleton_enemy17
	enemies.append(enemy)
	
	boss = $Boss
	enemies.append(boss)
	boss = $Boss2
	enemies.append(boss)
	
	
	#shrine = $Shrine
	player.attack.connect(_handle_playerattack)
	player.player_dead.connect(_handle_player_death)
	
	for e in enemies:
		print(e)
		if e.has_method("is_enemy"):
			e.enemy_attack.connect(_handle_enemyattack)
		
		if e.has_method("is_boss"):
			e.boss_attack.connect(_handle_bossattack)
	
	$flag.play("default")
	$flag2.play("default")
	$flag3.play("default")
	$flag3.play("default")
	
	$Waterfall.play("default")
	$Waterfall2.play("default")
	$Waterfall3.play("default")
	$Waterfall4.play("default")
	$Waterfall5.play("default")
	#shrine.choose_item.connect(_handle_choose_item)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _handle_enemyattack(damage):
	#print("enemy attack")
	if player.alive:
		player.take_damage(damage)

func _handle_playerattack(body, damage):
	for scene in enemies:
		if scene == body:
			scene.take_damage(damage)
			#print(scene.health)
			
func _handle_bossattack(damage):
	print("boss attack", damage)
	if player.alive:
		player.take_damage(damage)


func _handle_player_death():
	PlayerData.set_data(
		player.health,
		player.damage,
		player.collected_items,
		player.unlocked_additional_attack,
		player.unlocked_block,
		player.dcd,
		player.max_health
	)
	get_tree().change_scene_to_file("res://Scenes/Item_level.tscn")


func _on_fallbox_body_entered(body: Node2D) -> void:
	if body == player:
		player.position.x = 282
		player.position.y = 59
