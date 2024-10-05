extends CharacterBody2D

const SPEED = 300.0
const SPRINT = 3.0

var anim_dict:Dictionary={}

@onready var player_body: AnimatedSprite2D = $Player_Skin/Player_Body

func _ready() -> void:
	set_animation_dict()

func _physics_process(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	# Map the input directions to x and y axis: -1, 0, 1
	var direction = Vector2(input_dir.x, input_dir.y)

	# Apply movement direction and sprint
	if input_dir: 
		velocity.x = direction.x * SPEED / Global.size
		velocity.y = direction.y * SPEED / Global.size
		
		# Play animation based on direction and velocity
		play_animation(direction, velocity)
		
		# Check if sprinting 
		if Input.is_action_pressed("sprint"):
			velocity *= SPRINT
			play_animation(direction, velocity)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)
		play_animation(direction, velocity)
		
	move_and_slide()

func get_move(direction:Vector2):
	if direction.x < 0:
		return "right"
	elif direction.x > 0:
		return "left"
	elif direction.y < 0:
		return "up"
	elif direction.y > 0:
		return "down"
	else:
		return "idle"	
		
func set_animation_dict():
	var directions = ["left","right","up","down","idle"]
	for i in range(1,5):
		anim_dict[i]={}
		for direction in directions:
			anim_dict[i][direction]=direction+"_"+str(i)

func play_animation(direction:Vector2, velocity:Vector2):
	#print(get_move(direction))
	#print(Global.size)
	#print(anim_dict[int(Global.size)])
	#print(anim_dict[int(Global.size)][get_move(direction)])
	player_body.play(anim_dict[int(Global.size)][get_move(direction)])
	player_body.speed_scale *= velocity.length()/100.0
