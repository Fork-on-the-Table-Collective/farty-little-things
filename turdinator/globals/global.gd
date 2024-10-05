extends Node

const HEALT_PER_SIZE = 20

var size: float = 4.0
var health: float = size*HEALT_PER_SIZE
var sfx_stream_player= AudioStreamPlayer2D.new()
var button_hover=preload("res://sounds/sfx/menu_button_hover.wav")
var button_pressed=preload("res://sounds/sfx/menu_button_click.wav")
var speed_modifier: float = 1


func _ready() -> void:
	sfx_stream_player.bus="sfx"
	add_child(sfx_stream_player)
	set_all_button()

func set_size(modifier:float):
	size += modifier

func set_health(modifier: float):
	health += modifier 
	size = floor(health/HEALT_PER_SIZE)
  
func set_speed_modifier(modifier: float):
	speed_modifier = modifier

func _button_hover_sound_play():
	sfx_stream_player.stream=button_hover
	sfx_stream_player.play()
	
func _button_pressed_sound_play():
	sfx_stream_player.stream=button_pressed
	sfx_stream_player.play()

func get_all_buttons_recursive(parent) -> Array:
	var all_buttons = []
	for child in parent.get_children():
		if child is Button:
			all_buttons.append(child)
		all_buttons += get_all_buttons_recursive(child)
	return all_buttons

func set_all_button():
	var root = get_tree().root
	var buttons = get_all_buttons_recursive(root)
	for child in buttons:
		child.mouse_entered.connect(_button_hover_sound_play)
		child.pressed.connect(_button_pressed_sound_play)


