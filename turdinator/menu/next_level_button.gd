extends Button

@export var next_scene_path: String = "res://menu/level_select.tscn"
# Called when the node enters the scene tree for the first time.

func _on_pressed() -> void:
	get_tree().change_scene_to_file.call_deferred(next_scene_path)
