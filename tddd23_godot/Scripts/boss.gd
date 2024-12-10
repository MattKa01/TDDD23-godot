extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var attack_delay = $attack_delay
@onready var collision = $CollisionShape2D
@onready var attack_cooldown = $attack_cooldown
@onready var attack_duration = $attack_duration
@onready var attack_hitbox = $attack_hitbox/CollisionShape2D
@onready var leveling_duration = $Level_up_duration
const SPEED = 70.0
const flame_attacks = ["attack1 flame", "attack2 flame", "attack3 flame", "jumpattack flame"]

var player_chase = false
var player = null
var health = 800
var player_close = false
var alive = true
var can_attack = true
var player_attackable = false
var not_attacking = true
var flame_phase = false
var not_leveling = true

signal boss_attack(damage)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	# Handle jump.
	if alive and not_attacking and not_leveling:
		if not is_on_floor():
			velocity += get_gravity() * delta
		if player_chase:
			if abs(player.position.x - position.x) < 120 and player_attackable:
				player_close = true
				attack_player()
				if not _animated_sprite.is_playing():
					if flame_phase:
						_animated_sprite.play("idle flame")
					else:
						_animated_sprite.play("idle")
			else:
				player_close = false
			if position.x < player.position.x:
				_animated_sprite.flip_h = false
				attack_hitbox.position.x = 29
			else:
				_animated_sprite.flip_h = true
				attack_hitbox.position.x = -29
			if not player_close:
				position += (player.position - position)/SPEED
				if not (_animated_sprite.animation == "attack1" and _animated_sprite.is_playing()):
					if flame_phase:
						_animated_sprite.play("run flame")
					else:
						_animated_sprite.play("run")
					if not $Run_sound.playing:
						$Run_sound.play()
		else:
			if not (_animated_sprite.animation == "attack1" and _animated_sprite.is_playing()):
				if flame_phase:
					_animated_sprite.play("idle flame")
				else:
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
		attack_delay.start(0.2)
		can_attack = false
		attack_cooldown.start(1)
	
func take_damage(damage):
	if not_leveling:
		health = health - damage
	if health <= 0:
		_animated_sprite.play("death")
		alive = false
	elif health <= 400 and not flame_phase:
		flame_phase = true
		_animated_sprite.play("level up")
		$Level_up.play()
		not_leveling = false
		leveling_duration.start(3)


func _on_attack_cooldown_timeout() -> void:
	can_attack = true


func _on_attack_duration_timeout() -> void:
	not_attacking = true


func _on_attack_delay_timeout() -> void:
	if alive and not_leveling:
		if flame_phase:
			_animated_sprite.play(flame_attacks[randi_range(0,3)])
			$Fire_attack.play()
			if player_attackable:
				boss_attack.emit(200)
			attack_duration.start(0.6)
		else:
			_animated_sprite.play("attack" + str(randi_range(1,2)))
			if player_attackable:
				$Normal_attack_hit.play()
				boss_attack.emit(100)
			else:
				$Normal_attack_miss.play()
			attack_duration.start(1)
	print(player_attackable)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	player_attackable = true # Replace with function body.


func _on_attack_hitbox_body_exited(body: Node2D) -> void:
	player_attackable = false # Replace with function body.


func _on_detection_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_level_up_duration_timeout() -> void:
	not_leveling = true

func is_boss():
	return true
