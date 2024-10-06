extends Area2D

const PLAYER = preload("res://entities/player/player.gd")

var next_scene_path: String = "res://scenes/map/feedback.tscn"


func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, PLAYER):
		Global.score+=100
		Global.last_level_id+=1
		get_tree().change_scene_to_file.call_deferred(next_scene_path)
