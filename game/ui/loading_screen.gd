extends Control

const ARTS := ["res://resources/ui/loading/1.jpg", "res://resources/ui/loading/2.jpg", "res://resources/ui/loading/3.jpg"]
const VERSES := ["LOADING_VERSE_1", "LOADING_VERSE_2", "LOADING_VERSE_3"]
const MIN_SECONDS := 2.5

static var next_scene := ""

var bar: ProgressBar
var spinner: TextureRect
var elapsed := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	theme = Backlands.THEME
	var pick := randi() % ARTS.size()
	var art := TextureRect.new()
	art.texture = load(ARTS[pick])
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(art)
	add_child(_shade())
	var column := VBoxContainer.new()
	column.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	column.grow_vertical = Control.GROW_DIRECTION_BEGIN
	column.offset_left = 96
	column.offset_right = 96 + 720
	column.offset_top = -340
	column.offset_bottom = -110
	column.alignment = BoxContainer.ALIGNMENT_END
	column.add_theme_constant_override("separation", 12)
	add_child(column)
	var verse := Backlands.label(tr(VERSES[pick]), &"VerseLabel")
	column.add_child(verse)
	var rule := Backlands.rule(true)
	rule.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	rule.custom_minimum_size = Vector2(0, 30)
	column.add_child(rule)
	bar = ProgressBar.new()
	bar.show_percentage = false
	bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bar.offset_left = 96
	bar.offset_right = -200
	bar.offset_top = -78
	bar.offset_bottom = -50
	add_child(bar)
	spinner = TextureRect.new()
	spinner.texture = Backlands.MEDALLION
	spinner.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	spinner.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	spinner.offset_left = -164
	spinner.offset_right = -84
	spinner.offset_top = -104
	spinner.offset_bottom = -24
	spinner.pivot_offset = Vector2(40, 40)
	add_child(spinner)
	ResourceLoader.load_threaded_request(next_scene)


func _shade() -> TextureRect:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(0.02, 0.01, 0.0, 0.92))
	gradient.set_color(1, Color(0.02, 0.01, 0.0, 0.0))
	gradient.set_offset(1, 0.7)
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0, 1)
	texture.fill_to = Vector2(0.75, 0.25)
	var shade := TextureRect.new()
	shade.texture = texture
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	shade.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	shade.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return shade


func _process(delta: float) -> void:
	elapsed += delta
	spinner.rotation = elapsed * 1.6
	var progress := []
	var status := ResourceLoader.load_threaded_get_status(next_scene, progress)
	bar.value = (progress[0] if progress else 0.0) * 100.0
	if status == ResourceLoader.THREAD_LOAD_LOADED and elapsed >= MIN_SECONDS:
		set_process(false)
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene))
	elif status == ResourceLoader.THREAD_LOAD_FAILED:
		set_process(false)
		push_error("falha ao carregar " + next_scene)


static func go(tree: SceneTree, path: String) -> void:
	next_scene = path
	tree.change_scene_to_file("res://game/ui/loading_screen.tscn")
