extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var attack_delay = $attack_cooldown
const SPEED = 70.0
var player_chase = false
var player = null
var health = 100
var player_close = false
var alive = true
var can_attack = false

signal enemy_attack(damage)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Handle jump.
	if alive:
		if player_chase:
			if abs(player.position.x - position.x) < 60:
				player_close = true
				attack_player()
				_animated_sprite.play("idle")
			else:
				player_close = false
			if position.x < player.position.x:
				_animated_sprite.flip_h = false
			else:
				_animated_sprite.flip_h = true
			if not player_close:
				position += (player.position - position)/SPEED
				_animated_sprite.play("walk")
		else:
			_animated_sprite.play("idle")
	else:
		if not _animated_sprite.is_playing():
			_animated_sprite.play("dead")	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#	velocity.x = 1 * SPEED
	#	velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func attack_player():
	enemy_attack.emit(25)
	pass
	
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


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	can_attack = true
