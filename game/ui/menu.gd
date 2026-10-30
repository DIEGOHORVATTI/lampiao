extends Control

const CHAPTERS := {1: "res://game/world/chapters/chapter_01/chapter_01.tscn"}
const FREE_ROAM := "res://game/world/sandbox/sandbox.tscn"
const COLUMN_WIDTH := 680.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_anchors_preset(Control.PRESET_FULL_RECT)
	theme = Backlands.THEME

	var art := TextureRect.new()
	art.texture = preload("res://resources/ui/title.jpg")
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(art)
	add_child(_shade(Vector2(0, 0), Vector2(1, 0), 0.9, 0.62))
	add_child(_shade(Vector2(0, 1), Vector2(0, 0), 0.85, 0.22))

	var column := VBoxContainer.new()
	column.anchor_bottom = 1.0
	column.offset_left = 110.0
	column.offset_right = 110.0 + COLUMN_WIDTH
	column.offset_top = 60.0
	column.offset_bottom = -120.0
	column.alignment = BoxContainer.ALIGNMENT_CENTER
	column.add_theme_constant_override("separation", 22)
	add_child(column)
	var title := Backlands.label(tr("UI_TITLE"), &"TitleLabel")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(title)
	var chapter := Backlands.label(tr("UI_MENU_CHAPTER") % Story.chapter, &"HeaderLabel")
	chapter.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	chapter.add_theme_font_size_override("font_size", 40)
	column.add_child(chapter)
	column.add_child(Backlands.rule(true))
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 24)
	column.add_child(spacer)
	var play_key := "UI_MENU_PLAY" if CHAPTERS.has(Story.chapter) else "UI_MENU_FREE_ROAM"
	var play := Backlands.button(play_key, _play)
	column.add_child(play)
	column.add_child(Backlands.button("UI_MENU_SETTINGS", func(): add_child(SettingsMenu.new())))
	play.grab_focus.call_deferred()

	var credits := Backlands.label(tr("UI_MENU_CREDITS"), &"CaptionLabel")
	credits.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	credits.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	credits.offset_top = -84
	credits.offset_bottom = -20
	add_child(credits)


func _shade(from: Vector2, to: Vector2, strength: float, reach: float) -> TextureRect:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.02, 0.01, 0.0, strength))
	gradient.set_color(1, Color(0.02, 0.01, 0.0, 0.0))
	gradient.set_offset(1, reach)
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill_from = from
	texture.fill_to = to
	var shade := TextureRect.new()
	shade.texture = texture
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return shade


func _play() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	preload("res://game/ui/loading_screen.gd").go(get_tree(), CHAPTERS.get(Story.chapter, FREE_ROAM))
