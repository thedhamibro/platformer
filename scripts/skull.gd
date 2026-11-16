extends CharacterBody2D
class_name skull

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var player: Player = $"../player"

var facing_right = true
var speed = -100
var dead = false
var attacking = false
var health
var health_max = 3
var hurt = false
var knockback_velocity = Vector2.ZERO
var knockback_timer = 0.0
var knockback_duration = 0.3# Duration of knockback effect
var knockback_decay = 0.7   # How quickly knockback slows down (0.9 = smooth, <1)

func _ready() -> void:
	health = health_max
	if player == null:
		player = $"../../player"
	elif player == null:
		player = $player

	dead = false

func _physics_process(delta: float) -> void:
	# Stop all actions if dead
	if dead:
		velocity = Vector2.ZERO
		handle_anim()
		return

	# Handle knockback
	if knockback_timer > 0:
		velocity += knockback_velocity * delta
		knockback_velocity *= knockback_decay  # Gradual decay of knockback
		knockback_timer -= delta
	else:
		# Normal movement logic
		if is_on_floor():
			velocity.y = 0
		else:
			velocity += get_gravity() * delta

		if !$RayCast2D.is_colliding() and is_on_floor():
			flip()

		if !hurt:
			velocity.x = speed

	move_and_slide()
	handle_anim()

	# Check health for death
	if health <= 0 and not dead:
		die()

func flip():
	facing_right = !facing_right
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1 

func _on_area_2d_body_entered(body: Node2D) -> void:
	if dead or knockback_timer > 0:
		return

	if body is Player:
		var y_delta = position.y - body.position.y
		var x_delta = abs(position.x - body.position.x)
		var dynamic_y_threshold = scale.y * 0.5 
		var dynamic_x_threshold = scale.x * 0.5 

		if y_delta > dynamic_y_threshold and x_delta < dynamic_x_threshold:
			die()
			body.jump()
		elif not attacking:
			attacking = true
			player.reduce_health()
			player.emit_signal("update_hearts")
			await get_tree().create_timer(0.6).timeout
			attacking = false

func handle_anim():
	if dead:
		animated_sprite.play("die")
		return

	if attacking:
		animated_sprite.play("attack")
	elif hurt:
		animated_sprite.play("hurt")
	else:
		animated_sprite.play("move")

func take_hit(from_position: Vector2):
	if dead:
		return  # Ignore hits if already dead

	hurt = true
	health -= 1

	# Calculate knockback direction and apply force
	var knockback_direction = (position - from_position).normalized()
	var knockback_force = 900  # Increased force for faster knockback
	knockback_velocity = knockback_direction * knockback_force
	knockback_timer = knockback_duration

	animated_sprite.play("hurt")
	await get_tree().create_timer(0.5).timeout  # Short delay for hurt animation
	hurt = false

func die():
	dead = true
	velocity = Vector2.ZERO
	animated_sprite.play("die")
	await get_tree().create_timer(0.5).timeout  # Wait for death animation
	queue_free()
