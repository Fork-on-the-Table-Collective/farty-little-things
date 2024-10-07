extends CharacterBody2D

const COOLDOWN = 2.0
const PATROL_TURNOVER_TIME = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_effect: AnimatedSprite2D = $AnimatedSprite2D/AttackEffect
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var perception_shape: CollisionShape2D = $PerceptionArea/CollisionShape2D
@onready var hit_box: CollisionShape2D = $HitBoxArea/HitBox
@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_down: RayCast2D = $RayCastDown
@onready var enemy_char_animation: AnimatedSprite2D = $AnimatedSprite2D

@export var enemy:Enemies
@export var is_patroling:bool=true




var speed = 200.0
var damage = -20.0
var direction:Vector2=Vector2.ZERO
var is_in_hitbox: bool = false
var target: Area2D = null
var cooldown_timer: Timer
var patrol_timer: Timer
var is_click_on_cooldown: bool = false
var origin_speed
var you_can_eat:bool = true


enum Enemies {
	Fly,
	Rat,
	Sinoc,
	Croissant
}
const ENEMIES_CHAR_SHEETS=[
	{
		"path":"res://entities/assets/Fly_anim_sheet_new.png",
		"rows":1,
		"cols":3,
		"speed":250.0,
		"damage":-3.0,
		"scale":Vector2(.1,.1),
		"attak_position":Vector2(-137,153),
		"attak_scale":Vector2(0.7,0.7),
		"attak_rotation":-125.0,
		"collision_radius": 20.0,
		"perception_radius":100.0,
		"hitbox_radius":20.0,
	},
	{
		"path":"res://entities/assets/Rat_anim_sheet_new.png",
		"rows":1,
		"cols":3,
		"speed":200.0,
		"damage":-10.0,
		"scale":Vector2(.3,.3),
		"attak_position":Vector2(-202,102.5),
		"attak_scale":Vector2(0.6,0.56),
		"attak_rotation":130.0,
		"collision_radius": 18.0,
		"perception_radius":30.0,
		"hitbox_radius":22.0,
	},
	{
		"path":"res://entities/assets/sinoc_sheet.png",
		"rows":1,
		"cols":3,
		"speed":200.0,
		"damage":-8.0,
		"scale":Vector2(.4,.4),
		"attak_position":Vector2(37.5,67.5),
		"attak_scale":Vector2(0.332,0.427),
		"attak_rotation":-147.0,
		"collision_radius": 10.0,
		"perception_radius":20.0,
		"hitbox_radius":13.0,
	},
	{
		"path":"res://entities/assets/Croissant_anim_sheet.png",
		"rows":2,
		"cols":2,
		"speed":150.0,
		"damage":-15.0,
		"scale":Vector2(.4,.4),
		"attak_position":Vector2(-120,77.5),
		"attak_scale":Vector2(0.35,0.35),
		"attak_rotation":-125.0,
		"collision_radius": 10.0,
		"perception_radius":20.0,
		"hitbox_radius":10.0,
	},
]

func set_animation_from_images():
	var sprite_sheet:Image=load(ENEMIES_CHAR_SHEETS[enemy].path).get_image()
	var sprite_frames = SpriteFrames.new()
	animated_sprite.frames = sprite_frames
	var frame_width = sprite_sheet.get_size().x/ENEMIES_CHAR_SHEETS[enemy].cols
	var frame_height  = sprite_sheet.get_size().y/ENEMIES_CHAR_SHEETS[enemy].rows
	#sprite_frames.add_animation("default")
	for row in range(ENEMIES_CHAR_SHEETS[enemy].rows):
		for col in range(ENEMIES_CHAR_SHEETS[enemy].cols):
			var frame_rect = Rect2(col * frame_width, row * frame_height, frame_width, frame_height)
			var texture = ImageTexture.create_from_image(sprite_sheet.get_region(frame_rect))
			sprite_frames.add_frame("default",texture)

func set_movement(t: Node2D):
	if t:
		velocity = (t.global_position - position).normalized() * speed

func _ready() -> void:
	speed=ENEMIES_CHAR_SHEETS[enemy].speed
	damage=ENEMIES_CHAR_SHEETS[enemy].damage
	set_animation_from_images()
	attack_effect.position=ENEMIES_CHAR_SHEETS[enemy].attak_position
	attack_effect.rotation_degrees=ENEMIES_CHAR_SHEETS[enemy].attak_rotation
	attack_effect.scale=ENEMIES_CHAR_SHEETS[enemy].attak_scale
	var c_shape:CircleShape2D=collision_shape.shape.duplicate()
	c_shape.radius=ENEMIES_CHAR_SHEETS[enemy].collision_radius
	var p_shape:CircleShape2D=perception_shape.shape.duplicate()
	p_shape.radius=ENEMIES_CHAR_SHEETS[enemy].perception_radius
	var h_shape:CircleShape2D=hit_box.shape.duplicate()
	h_shape.radius=ENEMIES_CHAR_SHEETS[enemy].hitbox_radius
	self.scale=ENEMIES_CHAR_SHEETS[enemy].scale
	collision_shape.shape=c_shape
	perception_shape.shape=p_shape
	hit_box.shape=h_shape

	
	origin_speed = speed
	velocity = Vector2.ONE
	cooldown_timer = Timer.new()
	cooldown_timer.set_wait_time(COOLDOWN)
	cooldown_timer.set_one_shot(false)  # The timer should stop after one timeout
	cooldown_timer.timeout.connect(_cooldown_over)
	add_child(cooldown_timer)  # Add the timer to the scene

	patrol_timer = Timer.new()
	patrol_timer.set_wait_time(PATROL_TURNOVER_TIME)
	patrol_timer.set_one_shot(false)  # The timer should stop after one timeout
	patrol_timer.timeout.connect(_on_Patrol_timeout)
	add_child(patrol_timer)  # Add the timer to the scene
	patrol_timer.start()
	patrol()

	

func _on_Patrol_timeout():
	patrol()
	

func _physics_process(_delta: float) -> void:
	if ray_cast_right.is_colliding() or ray_cast_left.is_colliding() or ray_cast_up.is_colliding() or ray_cast_down.is_colliding() : 
		patrol()
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
		direction = Vector2(randf_range(-1,1),randf_range(-1,1))
		velocity = direction.normalized() * speed /2

func _cooldown_over():
	you_can_eat=true
	apply_damage()

func apply_damage():
	if you_can_eat:
		if is_in_hitbox == true:
			Global.set_health(damage)
			attack_effect.visible = true
			attack_effect.play("activated")
			you_can_eat=false
			speed=0
			cooldown_timer.start()
		else:
			speed=origin_speed
			patrol()
	else:
		target=null
		velocity=Vector2.ZERO

func _on_hit_box_area_body_entered(_body: Node2D) -> void:
	is_in_hitbox=true
	apply_damage()

func _on_perception_area_area_entered(area: Area2D) -> void:
	if you_can_eat:
		target = area
		set_movement(target)
	else:
		target=null
		velocity=Vector2.ZERO

func _on_perception_area_area_exited(_area: Area2D) -> void:
	target=null
	velocity=Vector2.ZERO


func _on_hit_box_area_body_exited(_body: Node2D) -> void:
	is_in_hitbox=false
	speed = origin_speed
	attack_effect.stop()
	attack_effect.visible = false
