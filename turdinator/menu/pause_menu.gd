extends Control
@onready var settings: VBoxContainer = $settings

func _ready() -> void:
	Global.set_all_button()

func _on_button_exit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_button_resume_pressed() -> void:
	get_tree().paused = false
	queue_free()  # Remove the pause menu when resuming


func _on_settings_pressed() -> void:
	if settings.visible:
		settings.visible=false
	else:
		settings.visible=true
