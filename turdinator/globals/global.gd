extends Node

# FOR DEVELOPMENT
const USE_SAVE=true

# Only change is constant 
const HEALTH_PER_SIZE = 20
const WAIT_OF_RESTART = 3
const NUMBER_OF_MAPS = 5
#const DEFAULT_PLAYER_COL_SCALE = Vector2(.5,.5)
const MAX_LEVEL=4.0

# Dictionary contains the transformation values to scale the player to size
# Values: x scale, y scale, x position, y position
const player_scale_dict:Dictionary={
	1.0: {"Scale": Vector2(1.0, 0.5), "Position": Vector2(-5.0, 35.0)},
	2.0: {"Scale": Vector2(1.1, 1.1), "Position": Vector2(-10.0, -10.0)},
	3.0: {"Scale": Vector2(2.35, 0.95), "Position": Vector2(0.0, -10.0)},
	4.0: {"Scale": Vector2(2.85, 1.2), "Position": Vector2(0.0, 0.0)}
}

# all the fucking variables you moron
var size: float = 2.0
var health: float = size*HEALTH_PER_SIZE
var sfx_stream_player= AudioStreamPlayer2D.new()
var button_hover=preload("res://sounds/sfx/menu/menu_button_hover.wav")
var button_pressed=preload("res://sounds/sfx/menu/menu_button_click.wav")
var speed_modifier: float = 1
var highscore:int = 0
var is_first_run:bool=true
var last_level_id:int=1
var variable_store_path = "user://variable_store.save"
var level_store_path = "user://level_store.save"
var levels=[]
var level_covers=[]
var you_are_dead = false
var turd_color: String = "brown"
var player_body_collision_pos=Vector2(0.0,0.0)
var player_body_collision_scale=Vector2(1.0,1.0)
var slider_value_dict: Dictionary={
	"Master": 1.0,
	"music": 1.0,
	"sfx": 1.0
} 
# to be saved, level_comp, score, highscore, fist start

func create_level_list():
	for i in range(NUMBER_OF_MAPS):
		levels.append("res://scenes/map/map_" + str(i).pad_zeros(2)+".tscn")
		level_covers.append("res://scenes/map/assets/covers/Map_Cover_" + str(i).pad_zeros(2)+".png")
func store_variables():
	if USE_SAVE:
		var data_to_store={
			"highscore":highscore,
			"is_first_run":is_first_run,
			"last_level_id":last_level_id,
			"slider_value_dict":slider_value_dict,
		}
		var file = FileAccess.open(variable_store_path,FileAccess.WRITE)
		file.store_string(JSON.stringify(data_to_store))
		file.close()

func load_variables():
	if FileAccess.file_exists(variable_store_path):
		var file=FileAccess.open(variable_store_path,FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()
		var parsed_data = JSON.parse_string(json_string)
		if parsed_data:
			highscore=parsed_data.highscore
			is_first_run=parsed_data.is_first_run
			last_level_id=parsed_data.last_level_id
			slider_value_dict=parsed_data.slider_value_dict
			for bus in slider_value_dict.keys():
				set_volume_by_bus(bus)
		else:
			print("Failed to load JSON: ")
			store_variables()

	else:
		print("no savefile")
		highscore=0
		#score=0
		is_first_run=true
		last_level_id=0

func update_highscore(map_score:int):
	if map_score > 0:
		highscore+=map_score

func _ready() -> void:
	load_variables()
	create_level_list()
	print(levels)
	sfx_stream_player.bus="sfx"
	add_child(sfx_stream_player)
	set_all_button()
	store_variables()

func set_health(modifier: float):
	health += modifier
	size = max(1,min(ceil(health/HEALTH_PER_SIZE),MAX_LEVEL))
	player_body_collision_pos = player_scale_dict[size].Position
	player_body_collision_scale = player_scale_dict[size].Scale
	if health <= 0:
		size=1
		you_are_dead = true
		await get_tree().create_timer(.1, true, false, true).timeout

		get_tree().paused = true
		await get_tree().create_timer(WAIT_OF_RESTART, true, false, true).timeout
		get_tree().paused = false
		call_deferred("restart_scene")

func restart_scene():
	get_tree().reload_current_scene()

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

func set_volume_by_bus(bus_name):
	var bus_index = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(slider_value_dict[bus_name])
	)
