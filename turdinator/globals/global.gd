extends Node

var size: float = 1.0
var health: float = 20.0
var speed_modifier: float = 1

func set_size(modifier:float):
	size += modifier

func set_health(modifier: float):
	health += modifier 

func set_speed_modifier(modifier: float):
	speed_modifier = modifier
