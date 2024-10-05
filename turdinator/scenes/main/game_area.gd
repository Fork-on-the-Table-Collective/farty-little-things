extends Node2D
var menu = preload("res://menu/main_menu.tscn")
var testmap = preload("res://scenes/map/test_map.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")


func _on_testmap_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/map/test_map.tscn")
