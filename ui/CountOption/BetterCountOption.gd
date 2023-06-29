extends VBoxContainer

signal data_changed()

onready var slider:HSlider = $HSlider
onready var timer:Timer = $UpdateTimer

onready var previous_value = int(slider.value)

var buffer_value_changed = false

export var min_value:int setget min_value_set, min_value_get
export var max_value:int setget max_value_set, max_value_get
var value:int setget value_set, value_get

# Have to use $HSlider in the setters for execution order reasons
func min_value_set(min_value:int):
	$HSlider.min_value = min_value
func max_value_set(max_value:int):
	$HSlider.max_value = max_value
func value_set(value:int):
	$HSlider.value = value
func min_value_get() -> int:
	min_value = int(slider.min_value)
	return min_value
func max_value_get() -> int:
	max_value = int(slider.max_value)
	return max_value
func value_get() -> int:
	value = int(slider.value)
	return value

func _ready():
	$Label.text = name
	update_values()
	slider.connect("value_changed", self, "on_value_changed")
	timer.connect("timeout", self, "_on_update_timer_timeout")
	#on_value_changed(value)
	$ValueLabel.text = str(self.value)

func update_values():
	# Deprecated function just to ensure interoperability
	pass

func on_value_changed(value):
	if previous_value != self.value:
		buffer_value_changed = true
		previous_value = value
		$ValueLabel.text = str(value)

func _on_update_timer_timeout():
	if buffer_value_changed:
		emit_signal("data_changed")
		buffer_value_changed = false

func get_value():
	return self.value
	
func get_data():
	return {
		"count":get_value()
	}
