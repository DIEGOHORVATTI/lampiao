class_name DeathScreen
extends ColorRect

signal retry_requested

var message: Label


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	color = Color(0.08, 0.0, 0.0, 0.85)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	message = Label.new()
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	message.set_anchors_preset(Control.PRESET_FULL_RECT)
	message.add_theme_font_size_override("font_size", 56)
	message.add_theme_color_override("font_color", Color(0.85, 0.45, 0.15))
	add_child(message)
	var retry := Button.new()
	retry.text = tr("UI_DEATH_RETRY")
	retry.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	retry.custom_minimum_size = Vector2(520, 100)
	retry.position += Vector2(-260, -180)
	retry.add_theme_font_size_override("font_size", 36)
	retry.pressed.connect(func(): retry_requested.emit())
	add_child(retry)


func show_message(text_key: String) -> void:
	message.text = tr(text_key)
	visible = true
