extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.set_all_button()



func _on_button_start_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/skin_select.tscn")

func _on_button_settings_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/settings_menu.tscn")

func _on_button_exit_pressed() -> void:
	get_tree().quit()

func _on_button_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0,toggled_on)
