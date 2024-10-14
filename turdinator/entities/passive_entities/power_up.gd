extends Area2D


@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _on_body_entered(_body: Node2D) -> void:
	Global.set_health(Global.HEALTH_PER_SIZE)
	animation_player.play("pickup")
