extends Control

const CHAPTERS := {1: "res://game/world/chapters/chapter_01/chapter_01.tscn"}
const FREE_ROAM := "res://game/world/sandbox/sandbox.tscn"


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_anchors_preset(Control.PRESET_FULL_RECT)

	var art := TextureRect.new()
	art.texture = preload("res://resources/ui/title.jpg")
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(art)

	var title := Label.new()
	title.text = tr("UI_TITLE")
	title.add_theme_font_size_override("font_size", 150)
	title.add_theme_color_override("font_color", Color(0.85, 0.45, 0.15))
	title.add_theme_color_override("font_outline_color", Color(0.05, 0.02, 0.0))
	title.add_theme_constant_override("outline_size", 18)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 30
	add_child(title)

	var buttons := VBoxContainer.new()
	buttons.set_anchors_and_offsets_preset(Control.PRESET_CENTER_BOTTOM)
	buttons.custom_minimum_size = Vector2(560, 0)
	buttons.position += Vector2(-280, -330)
	buttons.add_theme_constant_override("separation", 18)
	add_child(buttons)
	var play_key := "UI_MENU_PLAY" if CHAPTERS.has(Story.chapter) else "UI_MENU_FREE_ROAM"
	buttons.add_child(_button(play_key, _play))
	buttons.add_child(_button("UI_MENU_SETTINGS", func(): add_child(SettingsMenu.new())))
	var credits := Label.new()
	credits.text = tr("UI_MENU_CREDITS")
	credits.add_theme_font_size_override("font_size", 20)
	credits.add_theme_color_override("font_color", Color(0.91, 0.84, 0.69, 0.75))
	credits.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	credits.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits.offset_top = -64
	add_child(credits)


func _button(label_key: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = tr(label_key)
	button.custom_minimum_size = Vector2(0, 96)
	button.add_theme_font_size_override("font_size", 40)
	button.pressed.connect(action)
	return button


func _play() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	preload("res://game/ui/loading_screen.gd").go(get_tree(), CHAPTERS.get(Story.chapter, FREE_ROAM))
