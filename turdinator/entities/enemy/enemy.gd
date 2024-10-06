extends CharacterBody2D

const COOLDOWN = 1.0
const PATROL_TURNOVER_TIME = 5.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_effect: AnimatedSprite2D = $AnimatedSprite2D/AttackEffect

@export var speed = 200.0
@export var damage = -20.0

@export_group("Patrol properties")



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

func set_movement(t: Node2D):
	velocity = (t.global_position - position).normalized() * speed

func _ready() -> void:
	origin_speed = speed
	velocity = Vector2(1.0,1.0)
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
		animated_sprite.flip_h=true
	else:
		animated_sprite.flip_h=false
	move_and_slide()
	
func patrol() -> void:
	velocity = Vector2(1.0,1.0)
	direction=Vector2(1.0,1.0)
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
