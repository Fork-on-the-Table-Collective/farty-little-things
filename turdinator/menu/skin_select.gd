extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_back_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")

func _on_option_button_item_selected(index: int) -> void:
	if index == 1:
		Global.set_turd_color("light_brown")
	else:
		Global.set_turd_color("brown")
	get_tree().change_scene_to_file("res://scenes/map/test_map.tscn")
