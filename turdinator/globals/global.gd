extends Node

const HEALT_PER_SIZE = 20

var size: float = 4.0
var health: float = size*HEALT_PER_SIZE
var speed_modifier: float = 1


func set_size(modifier:float):
	size += modifier

func set_health(modifier: float):
	health += modifier 
  size = floor(health/HEALT_PER_SIZE)

func set_speed_modifier(modifier: float):
	speed_modifier = modifier

