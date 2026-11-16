extends CharacterBody2D
class_name Enemy

## Shared behaviour for patrolling enemies (Slime, Skull).
## Subclasses set speed / facing_right / health_max in _init().

## How far (px) the player's centre must be above the enemy's centre to count as a stomp.
const STOMP_HEIGHT := 10.0
const KNOCKBACK_FORCE := 900.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

var speed := -60.0
var facing_right := false
var health_max := 3
var health: int
var dead := false
var hurt := false
var attacking := false

var knockback_velocity := Vector2.ZERO
var knockback_timer := 0.0
var knockback_duration := 0.3  # Seconds the knockback lasts
var knockback_decay := 0.7     # Multiplier per frame (lower = stops faster)


func _ready() -> void:
	health = health_max


func _physics_process(delta: float) -> void:
	if dead:
		velocity = Vector2.ZERO
		handle_anim()
		return

	if knockback_timer > 0:
		velocity += knockback_velocity * delta
		knockback_velocity *= knockback_decay
		knockback_timer -= delta
	else:
		if is_on_floor():
			velocity.y = 0
		else:
			velocity += get_gravity() * delta

		# Turn around at ledges
		if !ray_cast.is_colliding() and is_on_floor():
			flip()

		if !hurt:
			velocity.x = speed

	move_and_slide()
	handle_anim()

	if health <= 0 and not dead:
		die()


func flip() -> void:
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	speed = abs(speed) if facing_right else -abs(speed)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if dead or knockback_timer > 0:
		return
	if not body is Player:
		return

	# Stomp: player is clearly above the enemy
	if global_position.y - body.global_position.y > STOMP_HEIGHT:
		die()
		body.jump()
	elif not attacking:
		attacking = true
		body._on_damage()
		await get_tree().create_timer(0.6).timeout
		attacking = false


func handle_anim() -> void:
	if dead:
		animated_sprite.play("die")
	elif attacking:
		animated_sprite.play("attack")
	elif hurt:
		animated_sprite.play("hurt")
	else:
		animated_sprite.play("move")


func take_hit(from_position: Vector2) -> void:
	if dead:
		return

	hurt = true
	health -= 1

	var knockback_direction := (position - from_position).normalized()
	knockback_velocity = knockback_direction * KNOCKBACK_FORCE
	knockback_timer = knockback_duration

	animated_sprite.play("hurt")
	await get_tree().create_timer(0.5).timeout
	hurt = false


func die() -> void:
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("die")
	await get_tree().create_timer(0.5).timeout
	queue_free()
