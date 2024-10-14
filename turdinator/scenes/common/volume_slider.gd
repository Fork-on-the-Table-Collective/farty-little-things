extends HSlider

@export var bus_name: String
var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	self.value=Global.slider_value_dict[bus_name]
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(value))

func _on_value_changed(new_value: float) -> void:
	Global.slider_value_dict[bus_name]=new_value
	Global.store_variables()
	Global.set_volume_by_bus(bus_name)
