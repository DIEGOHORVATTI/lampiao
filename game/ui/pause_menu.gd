class_name PauseMenu
extends ColorRect

signal resume_requested
signal settings_requested
signal menu_requested


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color = Color(0.03, 0.02, 0.02, 0.88)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(600, 0)
	column.add_theme_constant_override("separation", 24)
	center.add_child(column)
	var title := Label.new()
	title.text = tr("UI_PAUSE_TITLE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(0.72, 0.53, 0.17))
	column.add_child(title)
	column.add_child(_button("UI_PAUSE_RESUME", resume_requested))
	column.add_child(_button("UI_PAUSE_SETTINGS", settings_requested))
	column.add_child(_button("UI_PAUSE_TO_MENU", menu_requested))


func _button(label_key: String, emitted: Signal) -> Button:
	var button := Button.new()
	button.text = tr(label_key)
	button.custom_minimum_size = Vector2(0, 100)
	button.add_theme_font_size_override("font_size", 40)
	button.pressed.connect(func(): emitted.emit())
	return button
