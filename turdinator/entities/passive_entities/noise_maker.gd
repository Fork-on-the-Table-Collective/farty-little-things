extends Area2D

const HEALTH_MODIFIER: float = -10.0 

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var noise_maker_sound: AudioStreamPlayer = $noise_maker_sound
@onready var collision_shape: CollisionShape2D = $PerceptionArea/CollisionShape2D
@onready var timer: Timer = $Timer

func _on_body_entered(_body: Node2D) -> void:
	call_deferred("disable_collision")
	animated_sprite.play("activated")
	noise_maker_sound.play()
	timer.start()
	
func disable_collision() -> void:
	collision_shape.disabled = false	
	
func _on_timer_timeout() -> void:
	collision_shape.disabled = true 
	animated_sprite.play("idle")
	noise_maker_sound.stop()
