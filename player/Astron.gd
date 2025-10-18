extends CharacterBody2D


@export var SPEED: float = 250.0
@export var FLIGHT_VELOCITY: float = 200.0
@export var INSTANT_FLIGHT_VELOCITY: float = 100.0
@export var FLIGHT_ACCELERATION: float = 200.0
@export var MAX_FLIGHT_SPEED: float = 400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var target_y_velocity: float = 0.0

func _physics_process(delta: float):

	# Handle jump
	if Input.is_action_just_pressed("jump"):
		velocity.y += -INSTANT_FLIGHT_VELOCITY
		target_y_velocity += -FLIGHT_VELOCITY
	
	# Handle gravity
	if not is_on_floor():
		target_y_velocity += gravity * delta

	target_y_velocity = clampf(target_y_velocity, -MAX_FLIGHT_SPEED, MAX_FLIGHT_SPEED)
	
	velocity.y = move_toward(velocity.y, target_y_velocity, FLIGHT_ACCELERATION * delta)
	velocity.y = clampf(velocity.y, -MAX_FLIGHT_SPEED, MAX_FLIGHT_SPEED)

	# Handle movement
	var direction_x: float = Input.get_axis("left", "right")

	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.1)

	# Apply velocities and collision
	move_and_slide()

	# Face sprite towards movement direction
	if direction_x > 0:
		$Sprite2D.flip_h = false
	elif direction_x < 0:
		$Sprite2D.flip_h = true
