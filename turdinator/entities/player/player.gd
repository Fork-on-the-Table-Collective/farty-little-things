extends CharacterBody2D

const SPEED = 300.0
const SPRINT = 3.0

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = Vector2(input_dir.x, input_dir.y)
	if input_dir:
		velocity.x = direction.x * SPEED / Global.size * Global.speed_modifier
		velocity.y = direction.y * SPEED / Global.size * Global.speed_modifier
		# Check if sprinting
		if Input.is_action_pressed("sprint"):
			velocity *= SPRINT
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)


	move_and_slide()
