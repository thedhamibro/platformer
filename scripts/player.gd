extends CharacterBody2D

const SPEED = 130.0
const JUMP_VELOCITY = -300.0
const FRICTION = 500.0
const ACCELERATION = 800.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var custom_velocity = Vector2()
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	if not is_on_floor():
		custom_velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		custom_velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		custom_velocity.x = lerp(custom_velocity.x, float(direction) * SPEED, ACCELERATION * delta)
		animated_sprite.flip_h = direction < 0
	else:
		custom_velocity.x = lerp(custom_velocity.x, 0.0, FRICTION * delta)

	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")

	move_and_slide()
