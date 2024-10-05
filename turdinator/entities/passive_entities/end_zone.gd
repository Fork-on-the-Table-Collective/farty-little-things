extends Area2D

const Player = preload("res://entities/player/player.gd")

@export var next_scene_path: String = "res://scenes/map/feedback.tscn"


func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		print("you won!")
		get_tree().change_scene_to_file(next_scene_path)
