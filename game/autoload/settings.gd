extends Node

signal changed

const PATH := "user://settings.cfg"
const DEFAULTS := {
	"mouse_sensitivity": 0.003,
	"touch_sensitivity": 0.006,
	"keyboard_look_speed": 2.2,
	"invert_y": false,
	"third_person": false,
	"master_volume": 0.8,
	"render_scale": 0.85,
}

var values := DEFAULTS.duplicate()


const LOOK_KEYS := {"look_left": KEY_LEFT, "look_right": KEY_RIGHT, "look_up": KEY_UP, "look_down": KEY_DOWN}


func _ready() -> void:
	for action in LOOK_KEYS:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = LOOK_KEYS[action]
			InputMap.action_add_event(action, key)
	var file := ConfigFile.new()
	if file.load(PATH) == OK:
		for key in DEFAULTS:
			values[key] = file.get_value("game", key, DEFAULTS[key])
	apply()


func get_value(key: String) -> Variant:
	return values[key]


func set_value(key: String, value: Variant) -> void:
	values[key] = value
	apply()
	save()
	changed.emit()


func save() -> void:
	var file := ConfigFile.new()
	for key in values:
		file.set_value("game", key, values[key])
	file.save(PATH)


func apply() -> void:
	var bus := AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(bus, linear_to_db(maxf(values.master_volume, 0.0001)))
	get_viewport().scaling_3d_scale = values.render_scale


func look_delta(relative: Vector2, sensitivity_key: String) -> Vector2:
	var delta: Vector2 = relative * float(values[sensitivity_key])
	if values.invert_y:
		delta.y = -delta.y
	return delta
