extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var hitbox = $Attack_hitbox
@onready var attack_timer = $AttackCooldown
@export var SPEED = 300.0
@export var DASH = 600.0
@export var JUMP_VELOCITY = -700.0

var tween: Tween
var dash_velocity = 0.0
var can_dash = true
var attackable_enemy = null
var health = 100
var max_health = 100
var damage = 50
var can_attack = true
var collected_items = []
var unlocked_additional_attack = 1
var unlocked_block = false
var attack_chain_counter = 1
var dcd = 3
var blocking = false
var alive = true

signal attack(damage, body)
signal player_dead()

func _ready() -> void:
	health = PlayerData.health
	damage = PlayerData.damage
	collected_items = PlayerData.collected_items
	unlocked_additional_attack = PlayerData.unlocked_additional_attack
	unlocked_block = PlayerData.unlocked_block
	print(health)
	max_health = PlayerData.max_health

func _physics_process(delta: float) -> void:
	if alive:
		if velocity.x == 0 and velocity.y == 0 and not is_attacking() and not blocking:
			_animated_sprite.play("idle")
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * 1.5 * delta

	# Handle jump.
		if Input.is_action_just_pressed("jump") and is_on_floor():
			should_jump(delta)

		if Input.is_action_just_pressed("attack_light") and velocity.x == 0 and velocity.y == 0 and not blocking:
			if attack_chain_counter == 1:
				should_attack(delta)
			elif attack_chain_counter == 2 and not (_animated_sprite.is_playing() and _animated_sprite.animation == "attack1"):
				attack_chain(attack_chain_counter)
			elif attack_chain_counter == 3 and not (_animated_sprite.is_playing() and _animated_sprite.animation == "attack2"):
				attack_chain(attack_chain_counter)

		if Input.is_action_pressed("block") and velocity.x == 0 and velocity.y == 0 and not is_attacking():
			should_block(delta)
		else:
			blocking = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
		if not is_attacking():
			var direction := Input.get_axis("move_left", "move_right")
			if Input.is_action_just_pressed("dash"):
				should_dash(delta, direction)
		
			if direction:
				should_move(delta, direction)
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)
	
		move_and_slide()

func is_attacking():
	return (_animated_sprite.is_playing() and _animated_sprite.animation == "attack1") or (_animated_sprite.is_playing() and _animated_sprite.animation == "attack2") or (_animated_sprite.is_playing() and _animated_sprite.animation == "attack3")

func should_jump(delta: float) -> void:
	velocity.y = JUMP_VELOCITY
	_animated_sprite.play("jump")

func should_block(delta):
	if not unlocked_block:
		return
	else:
		if not (_animated_sprite.is_playing() and _animated_sprite.animation == "block_hit"):
			_animated_sprite.play("block")
		blocking = true

func should_dash(delta: float, direction: int) -> void:
	if can_dash and is_on_floor():
		dash_velocity = DASH
		_animated_sprite.play("dash")
		can_dash = false
		$DashCooldown.start(dcd)
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)

func should_attack(delta: float) -> void:
	if attackable_enemy != null and can_attack:
		attack.emit(attackable_enemy, damage)
		_animated_sprite.play("attack1")
		print("attack1")
		attack_chain_counter += 1
		if unlocked_additional_attack == 1:
			can_attack = false
			attack_timer.start(1)
			attack_chain_counter = 1

func attack_chain(chain_nr):
	if attackable_enemy != null and can_attack:
		if chain_nr == 2:
			attack.emit(attackable_enemy, damage)
			_animated_sprite.play("attack2")
			print("attack2")
			attack_chain_counter += 1
			if unlocked_additional_attack == 2:
				can_attack = false
				attack_timer.start(1)
				attack_chain_counter = 1
		elif chain_nr == 3:
			_animated_sprite.play("attack3")
			print("attack3")
			attack.emit(attackable_enemy, damage)
			can_attack = false
			attack_timer.start(1)
			attack_chain_counter = 1

func should_move(delta: float, direction: int) -> void:
	velocity.x = direction * (SPEED + dash_velocity)
	if direction > 0:
		_animated_sprite.flip_h = false
		hitbox.position.x = 120
		
	else:
		_animated_sprite.flip_h = true
		hitbox.position.x = -40
	if velocity.y == 0 and dash_velocity == 0:
		_animated_sprite.play("run")
		

func take_damage(damage):
	if blocking:
		_animated_sprite.play("block_hit")
		health -= damage/2
	else:
		health -= damage
	print(health)
	
	if health <= 0:
		alive = false
		_animated_sprite.play("death")
		$Dying.start(2)

func new_item(item):
	var id = item[2]
	collected_items.append(item)
	
	match id:
		1:
			if unlocked_additional_attack < 3:
				unlocked_additional_attack += 1
		2:
			damage += 25
		3:
			health += 50
			max_health += 50
		5:
			unlocked_block = true
		4:	
			if dcd > 1:
				dcd -= 1
		_:
			pass
	

func _on_DashCooldown_timeout():
	can_dash = true


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	print(body)
	attackable_enemy = body


func _on_attack_hitbox_body_exited(body: Node2D) -> void:
	attackable_enemy = null


func _on_attack_cooldown_timeout() -> void:
	can_attack = true # Replace with function body.


func _on_dying_timeout() -> void:
	player_dead.emit()
