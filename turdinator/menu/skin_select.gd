extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func start_game() -> void:
	if Global.is_first_run:
		get_tree().change_scene_to_file("res://menu/story_intro.tscn")
		Global.is_first_run=false
		Global.store_variables()
	else:
		get_tree().change_scene_to_file("res://menu/level_select.tscn")

func _on_button_yes_pressed() -> void:
	Global.set_turd_color("light_brown")
	start_game()

func _on_button_no_pressed() -> void:
	Global.set_turd_color("brown")
	start_game()
