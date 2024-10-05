extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_button_pick_pressed() -> void:
	if Global.is_first_run:
		get_tree().change_scene_to_file(Global.levels[0])
		Global.is_first_run=false
	else:
		get_tree().change_scene_to_file("res://scenes/main/game_area.tscn")
