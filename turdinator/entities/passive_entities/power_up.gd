extends Area2D

const HEALTH_MODIFIER: float = 10.0
const SIZE_MODIFIER: float = 1.0

@onready var power_up_sound: AudioStreamPlayer = $power_up_sound

func _on_body_entered(body: Node2D) -> void:
	Global.set_health(HEALTH_MODIFIER)
	Global.set_size(SIZE_MODIFIER)
	power_up_sound.play()
	queue_free()
