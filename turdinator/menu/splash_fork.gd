extends Control

@onready var in_time : float = 0.5
@onready var fade_in_time : float = 1.5
@onready var showing_time : float = 2.0
@onready var fade_out_time : float = 1.5
@onready var out_time : float = 0.5

@onready var next_scene = "res://menu/splash_turdvivor.tscn"

@onready var screen = $Panel/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ToDo: Implement fade in, fade out, and transfer to the next scene automatically (splash_turdvivor)
	screen.modulate.a = 0.0
	fade()
	

	
func fade() -> void:
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(screen, "modulate:a", 1.0,fade_in_time)
	tween.tween_interval(showing_time)
	tween.tween_property(screen, "modulate:a", 0.0,fade_out_time)
	tween.tween_interval(out_time)
	await tween.finished
	
	get_tree().change_scene_to_file(next_scene)
	
