extends Area2D

const HEALTH_MODIFIER: float = -10.0
const SIZE_MODIFIER: float = -1.0

@onready var power_down_sound: AudioStreamPlayer = $power_down_sound

func _on_body_entered(body: Node2D) -> void:
	Global.set_health(HEALTH_MODIFIER)
	power_down_sound.play()
