extends CharacterBody2D


@export var player_config: PlayerConfig
@export var spawn_position: Vector2

@export var SPEED: float = 250.0
@export var X_ACCELERATION: float = 50.0
@export var JUMP_VELOCITY: float = 750.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var alive: bool = true

var clone: Node2D
var clone_sprite: Sprite2D
var show_clone: bool = false
var viewport_size: Vector2

func _ready():
	player_config = get_parent()
	spawn_position = global_position
	viewport_size = get_viewport_rect().size
	
	$Area2D.area_entered.connect(_on_attack_collision)
	
	clone = $Clone
	clone_sprite = clone.get_child(0)
	clone.hide()

	spawn()


func _physics_process(delta: float):

	if not alive:
		return

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
	var speed_x: float = Input.get_axis(player_config.left_input, player_config.right_input) * SPEED
	velocity.x = move_toward(velocity.x, speed_x, X_ACCELERATION)

	# Apply velocities and collision
	move_and_slide()

	if (global_position.x < $Sprite2D.texture.get_width() / 2):
		global_position = Vector2(global_position.x + viewport_size.x, global_position.y)
	if (global_position.x > viewport_size.x - $Sprite2D.texture.get_width() / 2):
		global_position = Vector2(global_position.x - viewport_size.x, global_position.y)
	if (global_position.y < $Sprite2D.texture.get_height() / 2):
		global_position = Vector2(global_position.x, global_position.y + viewport_size.y)
	if (global_position.y > viewport_size.y - $Sprite2D.texture.get_height() / 2):
		global_position = Vector2(global_position.x, global_position.y - viewport_size.y)
	
	show_clone = false
	if (global_position.x < clone_sprite.texture.get_width() / 2):
		clone.global_position = Vector2(global_position.x + viewport_size.x, global_position.y)
		show_clone = true
	if (global_position.x > viewport_size.x - clone_sprite.texture.get_width() / 2):
		clone.global_position = Vector2(global_position.x - viewport_size.x, global_position.y)
		show_clone = true
	if (global_position.y < clone_sprite.texture.get_height() / 2):
		clone.global_position = Vector2(global_position.x, global_position.y + viewport_size.y)
		show_clone = true
	if (global_position.y > viewport_size.y - clone_sprite.texture.get_height() / 2):
		clone.global_position = Vector2(global_position.x, global_position.y - viewport_size.y)
		show_clone = true

	clone.set_visible(show_clone)

	# Face sprite towards movement direction
	$Sprite2D.flip_h = (speed_x < 0)


func _on_attack_collision(other: Node2D):
	if other.global_position.y < global_position.y:
		die()


func die():
	velocity = Vector2.ZERO
	global_position = spawn_position
	hide()
	alive = false
	set_physics_process(false)
	await get_tree().create_timer(player_config.respawn_delay).timeout
	spawn()


func spawn():
	show()
	alive = true
	set_physics_process(true)
