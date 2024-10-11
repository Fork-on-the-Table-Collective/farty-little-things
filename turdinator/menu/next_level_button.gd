extends Button



@export var is_next_level_button:bool = true

func set_level_path()->String:
	var level_selector: String = "res://menu/level_select.tscn"
	if is_next_level_button:
		return Global.levels[Global.current_map]
	else:
		return level_selector
# Called when the node enters the scene tree for the first time.

func _on_pressed() -> void:
	Global.current_map+=1
	get_tree().change_scene_to_file.call_deferred(set_level_path())
