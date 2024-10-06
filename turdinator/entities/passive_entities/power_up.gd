extends Area2D


@onready var power_up_sound: AudioStreamPlayer = $power_up_sound

func _on_body_entered(_body: Node2D) -> void:
	Global.set_health(Global.HEALTH_PER_SIZE)
	power_up_sound.play()
	queue_free()
