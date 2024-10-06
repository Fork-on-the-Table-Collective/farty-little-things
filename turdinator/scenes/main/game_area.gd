extends Node2D
var menu = preload("res://menu/main_menu.tscn")
@onready var map_1: TextureButton = $GridContainer/map1
@onready var map_2: TextureButton = $GridContainer/map2
@onready var map_3: TextureButton = $GridContainer/map3



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var map_buttons=[map_1,map_2,map_3]
	if Global.is_first_run:
		get_tree().change_scene_to_file.call_deferred("res://menu/skin_select.tscn")
	for id in range(map_buttons.size()):
		if id > Global.last_level_id+1:
			map_buttons[id].visible=false
		elif id == Global.last_level_id+1:
			map_buttons[id].disabled=true




func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://menu/main_menu.tscn")

func _on_map_1_pressed() -> void:
	get_tree().change_scene_to_file(Global.levels[0])

func _on_map_2_pressed() -> void:
	get_tree().change_scene_to_file(Global.levels[1])
