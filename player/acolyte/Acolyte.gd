extends CharacterBody2D


@export var player_config: PlayerConfig

@export var SPEED: float = 250.
@export var JUMP_VELOCITY: float = 500.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	player_config = get_parent()
	$Area2D.area_entered.connect(_on_attack_collision)

	spawn()


func _physics_process(delta: float):

	# Handle jump
	if Input.is_action_just_pressed(player_config.jump_input) and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	
	# Handle fastfall
	if Input.is_action_just_released(player_config.jump_input) and velocity.y < 0:
		velocity.y = 0
	
	# Handle gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle movement
	var direction_x: float = Input.get_axis(player_config.left_input, player_config.right_input)

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


func _on_attack_collision(other: Node2D):
	if other.global_position.y < global_position.y:
		die()


func die():
	hide()
	get_tree().create_timer(player_config.respawn_delay).timeout.connect(spawn)


func spawn():
	velocity = Vector2.ZERO
	position = player_config.spawn_position
	show()
