extends Area2D

const SLOW_MODIFIER: float = 0.75

@onready var slow_down_sound: AudioStreamPlayer = $slow_down_sound

func _on_body_entered(body: Node2D) -> void:
	Global.set_speed_modifier(SLOW_MODIFIER)
	slow_down_sound.play()

func _on_body_exited(body: Node2D) -> void:
	Global.set_speed_modifier(1.0)
	slow_down_sound.play()
