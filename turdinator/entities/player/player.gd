extends CharacterBody2D

const SPEED = 600.0
const SPRINT = 1.25
const HEALTH_LOST_PER_SECOND_OF_SPRINT = 2
const DEFAULT_ZOOM = Vector2.ONE*2
const MAX_ZOOM = Vector2.ONE*2.3
const MIN_ZOOM = Vector2.ONE*1.5
const FARTS_COUNT = 3

var random = RandomNumberGenerator.new()
var anim_dict:Dictionary={}
var pause_menu_scene: PackedScene = preload("res://menu/pause_menu.tscn")
var pause_menu_instance: Node = null  # Will hold the instance of the pause menu
var farts: Array = []

@onready var player_body: AnimatedSprite2D = $Player_Skin/Player_Body
@onready var player_skin: AnimatedSprite2D = $Player_Skin
@onready var you_have_died: Node2D = $YouHaveDied
@onready var body_collision_shape: CollisionShape2D = $BodyCollisionShape
@onready var camera: Camera2D = $Camera2D
@onready var streak: CPUParticles2D = $Streak
@onready var toutch_controls: CanvasLayer = $ToutchControls
@onready var slow_down_sound: AudioStreamPlayer = $slow_down_sound
@onready var health_bar: TextureProgressBar = $Control/CanvasLayer/Healthbar

func reset_player_params():
	Global.size=2.0
	Global.health=Global.size*Global.HEALTH_PER_SIZE
	Global.set_health(0.0)
	streak.emitting = false


func set_music_based_on_action(bus_name,volume):
	var bus_index = AudioServer.get_bus_index(bus_name)
	#var current_volume = AudioServer.get_bus_volume_db(bus_index)
	#var new_volume = (volume-current_volume)*delta
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(volume)
	)
	
func bg_music_trigger():
	if Global.size==1:
		set_music_based_on_action("bgm2",1)
	else:
		set_music_based_on_action("bgm2",0)
	if Global.health<15:
		set_music_based_on_action("bgm3",1)
	else:
		set_music_based_on_action("bgm3",0)
		
		

func _ready() -> void:
	slow_down_sound.volume_db=linear_to_db(.2)
	if OS.get_name() == "iOS" or OS.get_name() == "Android":
		toutch_controls.visible=true
	reset_player_params()
	set_animation_dict()
	Global.you_are_dead = false
	streak.color = player_skin.sprite_frames.get_frame_texture("idle_2_" + Global.turd_color, 0).get_image().get_pixel(128, 128)
	if is_instance_of(health_bar.texture_progress, GradientTexture2D):
		(health_bar.texture_progress as GradientTexture2D).gradient.set_color(1, streak.color)
	load_farts()


func load_farts() -> void:
	for i in range(1, FARTS_COUNT + 1):
		var audio_player = AudioStreamPlayer.new()
		audio_player.stream = load("res://sounds/sfx/farts/fart%s.wav" % i)
		farts.append(audio_player)
		add_child(audio_player)


func _process(_delta: float) -> void:
	bg_music_trigger()
	you_have_died.visible = Global.you_are_dead
	body_collision_shape.scale=Global.player_body_collision_scale
	body_collision_shape.position=Global.player_body_collision_pos
	var current_health_percentage = Global.health / (Global.HEALTH_PER_SIZE*Global.MAX_LEVEL)
	health_bar.value = current_health_percentage
	var delta_zoom :Vector2= (camera.zoom - DEFAULT_ZOOM/Global.health*Global.HEALTH_PER_SIZE)*_delta
	if delta_zoom != Vector2.ZERO and camera.zoom-delta_zoom<MAX_ZOOM and camera.zoom-delta_zoom> MIN_ZOOM and not Global.you_are_dead:
		camera.zoom -=delta_zoom
	



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
		speed_modifier =  Global.speed_modifier*((6-Global.size)/5)
		velocity=direction*speed_modifier*SPEED
		play_animation(direction, speed_modifier)
		#velocity.y = direction.y * SPEED / Global.size * Global.speed_modifier

		# Play animation based on direction and velocity
		#play_animation(direction, Global.speed_modifier/Global.size)

		# Check if sprinting
		if Input.is_action_pressed("sprint"):
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

	if Input.is_action_just_pressed("fart"):
		play_random_fart()

func play_random_fart():
	var r = random.randi_range(0, FARTS_COUNT - 1)
	farts[r].play()

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

func _on_terrain_sense_area_body_entered(_body: Node2D) -> void:
	slow_down_sound.play()
	Global.set_speed_modifier(0.75)
	pass # Replace with function body.

func _on_terrain_sense_area_body_exited(_body: Node2D) -> void:
	slow_down_sound.stop()
	Global.set_speed_modifier(1.0)
	pass # Replace with function body.


# Pause menu scene

func _input(event):
	# Detect when the pause key is pressed
	if event.is_action_pressed("pause_game"):  # Assuming you have defined the "ui_pause" action
		toggle_pause()

func toggle_pause():
	if !get_tree().paused:
		pause_game()
	else:
		resume_game()

func pause_game():
	# Instance the pause menu and add it to the scene
	if not pause_menu_instance:
		pause_menu_instance = pause_menu_scene.instantiate()

		add_child(pause_menu_instance)

		# Set the pause menu to process even when the game is paused
		pause_menu_instance.process_mode = Node.PROCESS_MODE_WHEN_PAUSED

	# Pause the game
	get_tree().paused = true	

func resume_game():
	# Resume the game
	get_tree().paused = false

	# Remove the pause menu
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
