class_name SettingsMenu
extends CenterContainer

signal closed

const INK := Color(0.91, 0.86, 0.75)
const ROWS := [
	{"key": "mouse_sensitivity", "label": "UI_SETTINGS_MOUSE", "min": 0.0005, "max": 0.008, "step": 0.0001},
	{"key": "touch_sensitivity", "label": "UI_SETTINGS_TOUCH", "min": 0.001, "max": 0.015, "step": 0.0005},
	{"key": "keyboard_look_speed", "label": "UI_SETTINGS_KEYBOARD", "min": 0.5, "max": 5.0, "step": 0.1},
	{"key": "master_volume", "label": "UI_SETTINGS_VOLUME", "min": 0.0, "max": 1.0, "step": 0.05},
	{"key": "render_scale", "label": "UI_SETTINGS_QUALITY", "min": 0.5, "max": 1.0, "step": 0.05},
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(900, 680)
	add_child(panel)
	var frame := StyleBoxFlat.new()
	frame.bg_color = Color(0.05, 0.03, 0.02, 0.95)
	frame.border_color = Color(0.72, 0.53, 0.17)
	frame.set_border_width_all(2)
	frame.set_content_margin_all(32)
	panel.add_theme_stylebox_override("panel", frame)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 18)
	panel.add_child(column)
	column.add_child(_title())
	for row in ROWS:
		column.add_child(_slider_row(row))
	column.add_child(_toggle_row("UI_SETTINGS_INVERT_Y", "invert_y"))
	column.add_child(_toggle_row("UI_SETTINGS_THIRD_PERSON", "third_person"))
	var back := Button.new()
	back.text = tr("UI_SETTINGS_BACK")
	back.custom_minimum_size = Vector2(0, 80)
	back.add_theme_font_size_override("font_size", 34)
	back.pressed.connect(func():
		closed.emit()
		queue_free())
	column.add_child(back)


func _title() -> Label:
	var title := Label.new()
	title.text = tr("UI_SETTINGS_TITLE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 48)
	title.add_theme_color_override("font_color", Color(0.72, 0.53, 0.17))
	return title


func _slider_row(row: Dictionary) -> Control:
	var line := HBoxContainer.new()
	line.add_child(_label(tr(row.label)))
	var slider := HSlider.new()
	slider.min_value = row.min
	slider.max_value = row.max
	slider.step = row.step
	slider.value = Settings.get_value(row.key)
	slider.custom_minimum_size = Vector2(420, 60)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value): Settings.set_value(row.key, value))
	line.add_child(slider)
	return line


func _toggle_row(label_key: String, setting: String) -> Control:
	var check := CheckButton.new()
	check.text = tr(label_key)
	check.button_pressed = Settings.get_value(setting)
	check.add_theme_font_size_override("font_size", 30)
	check.toggled.connect(func(on): Settings.set_value(setting, on))
	return check


func _label(text: String) -> Label:
	var label := Label.new()
	label.text = text
	label.custom_minimum_size = Vector2(320, 0)
	label.add_theme_font_size_override("font_size", 30)
	label.add_theme_color_override("font_color", INK)
	return label
