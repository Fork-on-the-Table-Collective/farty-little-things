extends Node

# FOR DEVELOPMENT
const USE_SAVE=false


const HEALTH_PER_SIZE = 20


var size: float = 2.0
var health: float = size*HEALTH_PER_SIZE
var sfx_stream_player= AudioStreamPlayer2D.new()
var button_hover=preload("res://sounds/sfx/menu_button_hover.wav")
var button_pressed=preload("res://sounds/sfx/menu_button_click.wav")
var speed_modifier: float = 1
var score:int
var highscore:int
var is_first_run:bool=true
var last_level_id:int=1
var variable_store_path = "user://variable_store.save"
var level_store_path = "user://level_store.save"
var levels=["res://scenes/map/test_map.tscn","res://scenes/map/tile_test_map.tscn"]
# to be saved, level_comp, score, highscore, fist start


func store_variables():
	if USE_SAVE:
		var file = FileAccess.open(variable_store_path,FileAccess.WRITE)
		file.store_var(highscore)
		file.store_var(score)
		file.store_var(is_first_run)
		file.store_var(last_level_id)
	

func load_variables():
	if FileAccess.file_exists(variable_store_path):
		var file=FileAccess.open(variable_store_path,FileAccess.READ)
		highscore=file.get_var(highscore)
		score=file.get_var(score)
		is_first_run=file.get_var(is_first_run)
		last_level_id=file.get_var(last_level_id)
	else:
		print("no savefile")
		highscore=0
		score=0
		is_first_run=true
		last_level_id=0

func update_highscore():
	if score > highscore:
		highscore=score
var turd_color: String = "brown"

func _ready() -> void:
	load_variables()
	sfx_stream_player.bus="sfx"
	add_child(sfx_stream_player)
	set_all_button()

func set_health(modifier: float):
	health += modifier
	size = floor(health/HEALTH_PER_SIZE)
	if health <= 0:
		var player = get_tree().get_first_node_in_group("player")
		player.you_have_died.visible = true
		get_tree().paused = true
		await get_tree().create_timer(3, true, false, true).timeout
		get_tree().paused = false
		call_deferred("restart_scene")

func restart_scene():
	get_tree().reload_current_scene()
	set_health(80)

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

func set_turd_color(color: String):
	turd_color = color
