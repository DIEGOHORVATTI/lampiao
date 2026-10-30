class_name PauseMenu
extends ColorRect

signal resume_requested
signal settings_requested
signal menu_requested


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = Backlands.THEME
	color = Color(0.03, 0.02, 0.02, 0.82)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.custom_minimum_size = Vector2(760, 0)
	center.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 22)
	panel.add_child(column)
	var title := Backlands.label(tr("UI_PAUSE_TITLE"), &"HeaderLabel")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 72)
	column.add_child(title)
	column.add_child(Backlands.rule(true))
	column.add_child(_button("UI_PAUSE_RESUME", resume_requested))
	column.add_child(_button("UI_PAUSE_SETTINGS", settings_requested))
	column.add_child(_button("UI_PAUSE_TO_MENU", menu_requested))
	visibility_changed.connect(_focus_first.bind(column))


func _button(label_key: String, emitted: Signal) -> Button:
	return Backlands.button(label_key, func(): emitted.emit())


func _focus_first(column: VBoxContainer) -> void:
	if visible:
		column.get_child(2).grab_focus.call_deferred()
