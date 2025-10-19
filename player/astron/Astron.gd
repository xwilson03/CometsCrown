extends Player
class_name Astron


@export var FLIGHT_VELOCITY: float = 200.0
@export var FLIGHT_ACCELERATION: float = 450.0
@export var MAX_FLIGHT_SPEED: float = 400.0

var target_y_velocity: float = 0.0


func handle_jump(delta: float):
	# Handle jump
	if Input.is_action_just_pressed(player_config.jump_input):
		velocity.y += -JUMP_VELOCITY
		target_y_velocity += -FLIGHT_VELOCITY
	
	target_y_velocity = clampf(target_y_velocity, -MAX_FLIGHT_SPEED, INF)
	
	if velocity.y > target_y_velocity:
		velocity.y = move_toward(velocity.y, target_y_velocity, (FLIGHT_ACCELERATION + GRAVITY_MULTIPLIER) * delta)
	elif velocity.y < target_y_velocity:
		velocity.y = move_toward(velocity.y, target_y_velocity, FLIGHT_ACCELERATION * delta)
	velocity.y = clampf(velocity.y, -MAX_FLIGHT_SPEED, INF)
