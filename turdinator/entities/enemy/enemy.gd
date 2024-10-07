extends CharacterBody2D

const COOLDOWN = 1.0
const PATROL_TURNOVER_TIME = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_effect: AnimatedSprite2D = $AnimatedSprite2D/AttackEffect

@export var speed = 200.0
@export var damage = -20.0
@export var enemy:Enemies
@export var is_patroling:bool=true




var direction:Vector2=Vector2.ZERO
var orientation = 0

var target: Area2D = null
var cooldown_timer: Timer
var patrol_timer: Timer
var is_click_on_cooldown: bool = false
var origin_speed

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var enemy_char_animation: AnimatedSprite2D = $AnimatedSprite2D

enum Enemies {
	Fly,
	Rat,
	Sinoc,
	Croissant
}
var enemies_char_sheets=[
	{
		"path":"res://entities/assets/Fly_anim_sheet_new.png",
		"rows":1,
		"cols":3,
		"scale":Vector2(.3,.3),
		"attak_position":Vector2(-137,153),
		"attak_scale":Vector2(0.7,0.7),
		"attak_rotation":-125.0
	},
	{
		"path":"res://entities/assets/Rat_anim_sheet_new.png",
		"rows":1,
		"cols":3,
		"scale":Vector2(.3,.3),
		"attak_position":Vector2(-202,102.5),
		"attak_scale":Vector2(0.6,0.56),
		"attak_rotation":130.0
	},
	{
		"path":"res://entities/assets/sinoc_sheet.png",
		"rows":1,
		"cols":3,
		"scale":Vector2(.4,.4),
		"attak_position":Vector2(37.5,67.5),
		"attak_scale":Vector2(0.332,0.427),
		"attak_rotation":-147.0
	},
	{
		"path":"res://entities/assets/Croissant_anim_sheet.png",
		"rows":2,
		"cols":2,
		"scale":Vector2(.4,.4),
		"attak_position":Vector2(-120,77.5),
		"attak_scale":Vector2(0.35,0.35),
		"attak_rotation":-125.0
	},
]

func set_animation_from_images():
	var sprite_sheet:Image=load(enemies_char_sheets[enemy].path).get_image()
	var sprite_frames = SpriteFrames.new()
	animated_sprite.frames = sprite_frames
	var frame_width = sprite_sheet.get_size().x/enemies_char_sheets[enemy].cols
	var frame_height  = sprite_sheet.get_size().y/enemies_char_sheets[enemy].rows
	#sprite_frames.add_animation("default")
	for row in range(enemies_char_sheets[enemy].rows):
		for col in range(enemies_char_sheets[enemy].cols):
			var frame_rect = Rect2(col * frame_width, row * frame_height, frame_width, frame_height)
			var texture = ImageTexture.create_from_image(sprite_sheet.get_region(frame_rect))
			sprite_frames.add_frame("default",texture)

func set_movement(t: Node2D):
	velocity = (t.global_position - position).normalized() * speed

func _ready() -> void:
	self.scale=enemies_char_sheets[enemy].scale
	set_animation_from_images()
	attack_effect.position=enemies_char_sheets[enemy].attak_position
	attack_effect.rotation_degrees=enemies_char_sheets[enemy].attak_rotation
	attack_effect.scale=enemies_char_sheets[enemy].attak_scale
	print(attack_effect.position)
	print(attack_effect.rotation_degrees)
	print(attack_effect.scale)
	origin_speed = speed
	velocity = Vector2.ONE
	cooldown_timer = Timer.new()
	cooldown_timer.set_wait_time(COOLDOWN)
	cooldown_timer.set_one_shot(true)  # The timer should stop after one timeout
	cooldown_timer.timeout.connect(_on_Cooldown_timeout)
	add_child(cooldown_timer)  # Add the timer to the scene

	patrol_timer = Timer.new()
	patrol_timer.set_wait_time(PATROL_TURNOVER_TIME)
	patrol_timer.set_one_shot(false)  # The timer should stop after one timeout
	patrol_timer.timeout.connect(_on_Patrol_timeout)
	add_child(patrol_timer)  # Add the timer to the scene
	patrol_timer.start()

func _process(_delta: float) -> void:
	if direction==Vector2(0,0):
		patrol()


func _on_Patrol_timeout():
	orientation=randi() % 2
	patrol()
	#direction*=-1

func _on_Cooldown_timeout():
	speed=origin_speed
	patrol()
	attack_effect.stop()
	attack_effect.visible = false

func _physics_process(_delta: float) -> void:
	
	if target != null:
		set_movement(target)
	if velocity.x >0:
		animated_sprite.scale.x=-1
	else:
		animated_sprite.scale.x=1
	move_and_slide()
	
func patrol() -> void:
	if is_patroling:
		velocity = Vector2.ONE
		direction=Vector2.ONE
		if orientation == 0:
			direction.y=0
			if ray_cast_right.is_colliding() :
				direction.x= -1.0
			elif ray_cast_left.is_colliding() :
				direction.x = 1.0
		elif orientation == 1:
			direction.x=0
			if ray_cast_up.is_colliding() :
				direction.y= 1
			elif ray_cast_down.is_colliding() :
				direction.y = -1
		velocity = direction * speed


func _on_hit_box_area_body_entered(_body: Node2D) -> void:
	Global.set_health(damage)
	attack_effect.visible = true
	attack_effect.play("activated")
	speed=0
	cooldown_timer.start()

func _on_perception_area_area_entered(area: Area2D) -> void:
	target = area
	set_movement(target)

func _on_perception_area_area_exited(_area: Area2D) -> void:
	target=null
	velocity=Vector2.ZERO
