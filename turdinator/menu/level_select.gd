extends Control


const SHADER:Shader = preload("res://scenes/common/texture_button.gdshader")
const HOVER_COLOR=Color(1, .2, .2,.5)
const BUTTON_DOWN_COLOR=Color(.5, .5, .5,.5)

@onready var grid_container: GridContainer = $VBoxContainer/MarginContainer2/GridContainer
var menu = "res://menu/main_menu.tscn"

func create_map_loading_buttons():
	for level_num in range(Global.NUMBER_OF_MAPS) :
		var map_button: = TextureButton.new()
		map_button.texture_normal=load(Global.level_covers[level_num])
		map_button.pressed.connect(_on_map_pressed.bind(Global.levels[level_num]))
		map_button.button_down.connect(_on_map_down.bind(map_button))
		map_button.mouse_entered.connect(_on_mouse_entered.bind(map_button))
		map_button.mouse_exited.connect(_on_mouse_exited.bind(map_button))
		if level_num > Global.last_level_id+1:
			map_button.visible=false
		elif level_num == Global.last_level_id+1:
			map_button.disabled=true
			var shader_material:ShaderMaterial = ShaderMaterial.new()
			shader_material.shader=SHADER
			shader_material.set_shader_parameter("modulate_color", BUTTON_DOWN_COLOR) 
			map_button.material=shader_material
		grid_container.add_child(map_button)
				

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	create_map_loading_buttons()

func _on_mouse_entered(button:TextureButton):
	if not button.disabled:
		var shader_material:ShaderMaterial = ShaderMaterial.new()
		shader_material.shader=SHADER
		shader_material.set_shader_parameter("modulate_color", HOVER_COLOR) 
		button.material=shader_material

func _on_mouse_exited(button:TextureButton):
	if not button.disabled:
		var shader_material:ShaderMaterial = ShaderMaterial.new()
		shader_material.shader=SHADER
		shader_material.set_shader_parameter("modulate_color", Color.WHITE)  # Normal tint
		button.material=shader_material

func _on_map_pressed(level:String) -> void:
	get_tree().change_scene_to_file(level)
	
func _on_map_down(button:TextureButton):
	var shader_material:ShaderMaterial = ShaderMaterial.new()
	shader_material.shader=SHADER
	shader_material.set_shader_parameter("modulate_color", Color(.2, 1.0, .2,.5))  # Normal tint
	button.material=shader_material


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file(menu)
