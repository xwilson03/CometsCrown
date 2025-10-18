extends CharacterBody2D


@export var SPEED: float = 250.
@export var JUMP_VELOCITY: float = 400.0

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta: float):
    
    # Apply gravity to velocity if airborne
    if not is_on_floor():
        velocity.y += gravity * delta

    # Handle jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y -= JUMP_VELOCITY

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
