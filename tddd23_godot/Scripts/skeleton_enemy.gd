extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var attack_delay = $attack_delay
@onready var collision = $CollisionPolygon2D
@onready var attack_cooldown = $attack_cooldown
@onready var attack_duration = $attack_duration
@onready var attack_hitbox = $attack_hitbox/CollisionShape2D
const SPEED = 70.0
var player_chase = false
var player = null
var health = 100
var player_close = false
var alive = true
var can_attack = true
var player_attackable = false
var not_attacking = true

signal enemy_attack(damage)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	# Handle jump.
	if alive and not_attacking:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if player_chase:
			if abs(player.position.x - position.x) < 65:
				player_close = true
				attack_player()
				if not _animated_sprite.is_playing():
					_animated_sprite.play("idle")
			else:
				player_close = false
			if position.x < player.position.x:
				_animated_sprite.flip_h = false
				attack_hitbox.position.x = 20
			else:
				_animated_sprite.flip_h = true
				attack_hitbox.position.x = -20
			if not player_close:
				position += (player.position - position)/SPEED
				if not (_animated_sprite.animation == "attack1" and _animated_sprite.is_playing()):
					_animated_sprite.play("walk")
		else:
			if not (_animated_sprite.animation == "attack1" and _animated_sprite.is_playing()):
				_animated_sprite.play("idle")
	elif not alive:
		if not _animated_sprite.is_playing():
			_animated_sprite.play("dead")
			collision.disabled = true
			
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#	velocity.x = 1 * SPEED
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func attack_player():
	if can_attack:
		not_attacking = false
		attack_delay.start(1)
		can_attack = false
		attack_cooldown.start(2)
	
func take_damage(damage):
	health = health - damage
	_animated_sprite.play("hit")
	if health <= 0:
		_animated_sprite.play("death")
		alive = false

func _on_detection_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true



func _on_detection_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	

func _on_attack_cooldown_timeout() -> void:
	print(can_attack)
	can_attack = true

func _on_attack_delay_timeout() -> void:
	_animated_sprite.play("attack1")
	if player_attackable:
		enemy_attack.emit(100)
	attack_duration.start(1)


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	player_attackable = true # Replace with function body.


func _on_attack_hitbox_body_exited(body: Node2D) -> void:
	player_attackable = false


func _on_attack_duration_timeout() -> void:
	not_attacking = true
