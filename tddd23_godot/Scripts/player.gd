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
var damage = 50
var can_attack = true

signal attack(damage, body)

func _physics_process(delta: float) -> void:
	if velocity.x == 0 and velocity.y == 0 and not Input.is_action_pressed("attack_light") and not Input.is_action_pressed("attack_heavy"):
		_animated_sprite.play("idle")
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * 1.5 * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		should_jump(delta)

	if Input.is_action_pressed("attack_light") and velocity.x == 0 and velocity.y == 0:
		should_attack(delta)
		
		
	if Input.is_action_pressed("attack_heavy") and velocity.x == 0 and velocity.y == 0:
		_animated_sprite.play("attack2")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if Input.is_action_just_pressed("dash"):
		should_dash(delta, direction)
		
	if direction:
		should_move(delta, direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()


func should_jump(delta: float) -> void:
	velocity.y = JUMP_VELOCITY
	_animated_sprite.play("jump")


func should_dash(delta: float, direction: int) -> void:
	if can_dash and is_on_floor():
		dash_velocity = DASH
		_animated_sprite.play("dash")
		can_dash = false
		$DashCooldown.start()
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property(self, "dash_velocity", 0, 0.3).set_ease(Tween.EASE_OUT)

func should_attack(delta: float) -> void:
	if attackable_enemy != null and can_attack:
		attack.emit(attackable_enemy, damage)
		_animated_sprite.play("attack1")
		can_attack = false
		attack_timer.start(1)
		

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
	health -= damage
	print(health)

func _on_DashCooldown_timeout():
	can_dash = true
	


func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	attackable_enemy = body


func _on_attack_hitbox_body_exited(body: Node2D) -> void:
	attackable_enemy = null


func _on_attack_cooldown_timeout() -> void:
	can_attack = true # Replace with function body.
