extends CharacterBody2D

const COOLDOWN = 1.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var speed = 200.0
@export var damage = -20.0

@export_group("Patrol properties")
@export_enum("horizontal", "vertical") var orientation: String
@export_range(-1,1) var direction: int

var target: Area2D = null
var cooldown_timer: Timer
var is_click_on_cooldown: bool = false
var origin_speed

@onready var ray_cast_right: RayCast2D = $RayCastRight
@onready var ray_cast_left: RayCast2D = $RayCastLeft
@onready var ray_cast_up: RayCast2D = $RayCastUp
@onready var ray_cast_down: RayCast2D = $RayCastDown

func set_movement(t: Node2D):
	velocity = (t.global_position - position).normalized() * speed

func _ready() -> void:
	origin_speed = speed
	velocity = Vector2(0, 0)
	cooldown_timer = Timer.new()
	cooldown_timer.set_wait_time(COOLDOWN)
	cooldown_timer.set_one_shot(true)  # The timer should stop after one timeout
	cooldown_timer.connect("timeout",  _on_Cooldown_timeout)
	add_child(cooldown_timer)  # Add the timer to the scene

func _on_Cooldown_timeout():
	speed=origin_speed
	patrol(orientation, direction)

func _physics_process(_delta: float) -> void:
	patrol(orientation, direction)
	
	if target != null:
		set_movement(target)
	if velocity.x >0:
		animated_sprite.flip_h=true
	else:
		animated_sprite.flip_h=false
	move_and_slide()

func patrol(orientation:String, direction:int) -> void:
	if orientation == "horizontal":
		velocity.x = direction * speed
		if ray_cast_right.is_colliding() || ray_cast_left.is_colliding():
			direction *= -1
	elif orientation == "vertical":
		velocity.y += direction * speed
		if ray_cast_up.is_colliding() || ray_cast_down.is_colliding():
			direction *= -1

func _on_hit_box_area_body_entered(_body: Node2D) -> void:
	Global.set_health(damage)
	speed=0
	cooldown_timer.start()

func _on_perception_area_area_entered(area: Area2D) -> void:
	print("turd seen")
	target = area
	set_movement(target)

func _on_perception_area_area_exited(_area: Area2D) -> void:
	target=null
	velocity=Vector2(0.0,0.0)
