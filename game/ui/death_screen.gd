class_name DeathScreen
extends ColorRect

signal retry_requested

var message: Label
var retry: Button


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	theme = Backlands.THEME
	color = Color(0.1, 0.0, 0.0, 0.86)
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var panel := PanelContainer.new()
	panel.theme_type_variation = &"BloodPanel"
	panel.custom_minimum_size = Vector2(1240, 0)
	center.add_child(panel)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 30)
	panel.add_child(column)
	column.add_child(Backlands.rule(true))
	message = Backlands.label("", &"DeathLabel")
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	message.custom_minimum_size = Vector2(0, 200)
	column.add_child(message)
	column.add_child(Backlands.rule(true))
	var retry_row := CenterContainer.new()
	column.add_child(retry_row)
	retry = Backlands.button("UI_DEATH_RETRY", func(): retry_requested.emit())
	retry.custom_minimum_size.x = 600
	retry_row.add_child(retry)


func show_message(text_key: String) -> void:
	message.text = tr(text_key)
	visible = true
	retry.grab_focus.call_deferred()
