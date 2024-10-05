extends CharacterBody2D


const SPEED = 200

#@onready var hit_box = $HitBox
#@onready var sprite = $AnimatedSprite2D
var target: Area2D = null


func set_movement(t: Node2D):
	velocity = (t.global_position - position).normalized() * SPEED


func _ready() -> void:
	velocity = Vector2(0, 0)


func _physics_process(delta: float) -> void:
	if target != null:
		set_movement(target)
	move_and_slide()


func _on_hit_box_area_body_entered(body: Node2D) -> void:
	print("damage")


func _on_perception_area_area_entered(area: Area2D) -> void:
	print("turd seen")
	target = area
	set_movement(target)


func _on_perception_area_area_exited(area: Area2D) -> void:
	velocity = Vector2(0, 0)
	target = null
