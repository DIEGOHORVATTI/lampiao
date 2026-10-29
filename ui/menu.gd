extends Control

const FIRST_LEVEL := "res://world/sertao/sertao.tscn"


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var art := TextureRect.new()
	art.texture = preload("res://resources/ui/titulo.jpg")
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(art)

	var title := Label.new()
	title.text = "LAMPIÃO"
	title.add_theme_font_size_override("font_size", 150)
	title.add_theme_color_override("font_color", Color(0.85, 0.45, 0.15))
	title.add_theme_color_override("font_outline_color", Color(0.05, 0.02, 0.0))
	title.add_theme_constant_override("outline_size", 18)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 30
	add_child(title)

	var hint := Label.new()
	hint.text = "toque para entrar no sertão"
	hint.add_theme_font_size_override("font_size", 40)
	hint.add_theme_color_override("font_color", Color(0.91, 0.84, 0.69))
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	hint.offset_top = -120
	add_child(hint)
	var pulse := create_tween().set_loops()
	pulse.tween_property(hint, "modulate:a", 0.25, 1.2)
	pulse.tween_property(hint, "modulate:a", 1.0, 1.2)


func _input(event: InputEvent) -> void:
	var tapped: bool = event is InputEventScreenTouch and event.pressed
	var clicked: bool = event is InputEventMouseButton and event.pressed
	if tapped or clicked or event.is_action_pressed("ui_accept"):
		set_process_input(false)
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().change_scene_to_file(FIRST_LEVEL)
