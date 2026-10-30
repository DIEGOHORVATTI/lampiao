class_name SettingsMenu
extends CenterContainer

signal closed

const ROWS := [
	{"key": "mouse_sensitivity", "label": "UI_SETTINGS_MOUSE", "min": 0.0005, "max": 0.008, "step": 0.0001},
	{"key": "touch_sensitivity", "label": "UI_SETTINGS_TOUCH", "min": 0.001, "max": 0.015, "step": 0.0005},
	{"key": "keyboard_look_speed", "label": "UI_SETTINGS_KEYBOARD", "min": 0.5, "max": 5.0, "step": 0.1},
	{"key": "master_volume", "label": "UI_SETTINGS_VOLUME", "min": 0.0, "max": 1.0, "step": 0.05},
	{"key": "render_scale", "label": "UI_SETTINGS_QUALITY", "min": 0.5, "max": 1.0, "step": 0.05},
]


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = Backlands.THEME
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(1060, 0)
	add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 10)
	panel.add_child(column)
	var title := Backlands.label(tr("UI_SETTINGS_TITLE"), &"HeaderLabel")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)
	column.add_child(Backlands.rule())
	for row in ROWS:
		column.add_child(_slider_row(row))
	column.add_child(_toggle_row("UI_SETTINGS_INVERT_Y", "invert_y"))
	column.add_child(_toggle_row("UI_SETTINGS_THIRD_PERSON", "third_person"))
	var back := Backlands.button("UI_SETTINGS_BACK", func():
		closed.emit()
		queue_free())
	back.custom_minimum_size.y = 92
	var back_row := CenterContainer.new()
	back.custom_minimum_size.x = 520
	back_row.add_child(back)
	column.add_child(back_row)
	back.grab_focus.call_deferred()


func _slider_row(row: Dictionary) -> Control:
	var line := HBoxContainer.new()
	line.add_theme_constant_override("separation", 24)
	line.add_child(_label(tr(row.label)))
	var slider := HSlider.new()
	slider.min_value = row.min
	slider.max_value = row.max
	slider.step = row.step
	slider.value = Settings.get_value(row.key)
	slider.custom_minimum_size = Vector2(420, 64)
	slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slider.value_changed.connect(func(value): Settings.set_value(row.key, value))
	line.add_child(slider)
	return line


func _toggle_row(label_key: String, setting: String) -> Control:
	var check := CheckButton.new()
	check.text = tr(label_key)
	check.button_pressed = Settings.get_value(setting)
	check.custom_minimum_size = Vector2(0, 64)
	check.toggled.connect(func(on): Settings.set_value(setting, on))
	return check


func _label(text: String) -> Label:
	var label := Backlands.label(text, &"SettingLabel")
	label.custom_minimum_size = Vector2(380, 0)
	return label
