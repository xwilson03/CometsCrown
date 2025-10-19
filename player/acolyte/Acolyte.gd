extends Player
class_name Acolyte


func handle_jump(_delta: float):
	# Handle jump
	if Input.is_action_just_pressed(player_config.jump_input) and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	
	# Handle fastfall
	if Input.is_action_just_released(player_config.jump_input) and velocity.y < 0:
		velocity.y = 0
