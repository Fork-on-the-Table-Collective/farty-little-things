extends CharacterBody2D

const SPEED = 300.0
const SPRINT = 3.0
const HEALTH_LOST_PER_SECOND_OF_SPRINT = 2
const DEFAULT_ZOOM = Vector2(2.0,2.0)

var anim_dict:Dictionary={}

@onready var player_body: AnimatedSprite2D = $Player_Skin/Player_Body
@onready var player_skin: AnimatedSprite2D = $Player_Skin
@onready var you_have_died: Node2D = $YouHaveDied
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var camera: Camera2D = $Camera2D
@onready var streak: CPUParticles2D = $Streak
@onready var control: Control = $Control
@onready var control_2: Control = $Control2

func reset_player_params():
	Global.size=2.0
	Global.health=Global.size*Global.HEALTH_PER_SIZE
	Global.set_health(0.0)
	streak.emitting = false


func _ready() -> void:
	if OS.get_name() == "iOS":
		control.visible=true
		control_2.visible=true
	reset_player_params()
	set_animation_dict()
	Global.you_are_dead = false
	streak.color = player_skin.sprite_frames.get_frame_texture("idle_2_" + Global.turd_color, 0).get_image().get_pixel(128, 128)


func _process(_delta: float) -> void:
	you_have_died.visible = Global.you_are_dead
	body_collision_shape.scale=Global.player_body_collision_scale
	body_collision_shape.position=Global.player_body_collision_pos
	var delta_zoom :Vector2= camera.zoom - DEFAULT_ZOOM/Global.health*Global.HEALTH_PER_SIZE
	if delta_zoom != DEFAULT_ZOOM*0 and  not Global.you_are_dead:
		camera.zoom -=delta_zoom*_delta



func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var toutch_input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	# Map the input directions to x and y axis: -1, 0, 1
	var direction = Vector2.ZERO
	if input_dir:
		direction = Vector2(input_dir.x, input_dir.y)
	elif toutch_input_dir:
		direction = Vector2(toutch_input_dir.x, toutch_input_dir.y)
	var speed_modifier = 1.0

	# Apply movement direction and sprint
	if input_dir or toutch_input_dir:
		speed_modifier =  Global.speed_modifier/Global.size
		velocity=direction*speed_modifier*SPEED
		play_animation(direction, speed_modifier)
		#velocity.y = direction.y * SPEED / Global.size * Global.speed_modifier

		# Play animation based on direction and velocity
		#play_animation(direction, Global.speed_modifier/Global.size)

		# Check if sprinting
		if Input.is_action_pressed("sprint") or Input.is_action_pressed("ui_select"): 
			speed_modifier*=SPRINT
			velocity=direction*speed_modifier*SPEED
			play_animation(direction, speed_modifier)
			streak.emitting = true
			if Global.health >= Global.HEALTH_PER_SIZE:
				Global.set_health(-HEALTH_LOST_PER_SECOND_OF_SPRINT * delta)
		else:
			streak.emitting = false
	else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED)
		streak.emitting = false
		velocity=direction
		play_animation(direction, 1)

	move_and_slide()

func get_move(direction:Vector2):
	if direction.x > 0:
		return "right"
	elif direction.x < 0:
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

func play_animation(direction:Vector2, anim_speed_modifier:float):
	const NORMAL_SPEED = 3.0
	var animation_body_name = anim_dict[int(Global.size)][get_move(direction)]
	var animation_skin_name =animation_body_name+ "_" + Global.turd_color
	#var anim_speed_modifier=Global.speed_modifier/Global.size
	player_body.speed_scale=anim_speed_modifier*NORMAL_SPEED
	player_body.play(animation_body_name)
	player_skin.play(animation_skin_name)
	
	if Global.size == 3.0:
		player_skin.scale = Vector2(0.85, 0.85)
	else:
		player_skin.scale = Vector2(1.0, 1.0)
	#player_body.speed_scale *= velocity.length()
