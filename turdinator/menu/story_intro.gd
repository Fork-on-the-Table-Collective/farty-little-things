extends Control

var in_time : float = 0.5
var fade_in_time : float = 1.5
var fade_out_time : float = 1.5
var out_time : float = 0.3

var next_scene = "res://scenes/map/map_00.tscn"

@onready var button_skip: Button = $ButtonSkip
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	modulate.a = 0.0
	Global.set_all_button()
	if not Global.is_first_run:
		button_skip.visible = true
	fade()

func fade() -> void:
	var tween = self.create_tween()
	tween.tween_interval(in_time)
	tween.tween_property(self, "modulate:a", 1.0,fade_in_time)
	tween.tween_interval(audio_stream_player.stream.get_length())
	tween.tween_property(self, "modulate:a", 0.0,fade_out_time)
	tween.tween_interval(out_time)
	tween.play()
	await get_tree().create_timer(fade_in_time, true, false, true).timeout
	audio_stream_player.play()
	await tween.finished

	get_tree().change_scene_to_file(next_scene)

func _on_button_skip_pressed() -> void:
	get_tree().change_scene_to_file(next_scene)
