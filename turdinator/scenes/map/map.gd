extends Node2D

@export var next_level_id:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.last_level_id <next_level_id:
		Global.last_level_id = next_level_id
	Global.store_variables()
	print("10 point for gryffindor")
