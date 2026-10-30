extends Control

const ARTS := ["res://resources/ui/carregamento/1.jpg", "res://resources/ui/carregamento/2.jpg", "res://resources/ui/carregamento/3.jpg"]
const VERSES := [
	"Quem vende o bando por moeda\nnão dorme mais em paz:\no sertão tem boca grande\ne cobra o que se faz.",
	"Cortaram a cabeça do Capitão\npra mostrar na feira.\nMas o que mora no pescoço\nnão cabe numa lata inteira.",
	"Na noite sem lua do sertão\nquem clareia é o fuzil:\ncada tiro é um lampião\nque o inimigo nunca viu.",
]
const MIN_SECONDS := 2.5

static var next_scene := ""

var bar: ProgressBar
var elapsed := 0.0


func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	var pick := randi() % ARTS.size()
	var art := TextureRect.new()
	art.texture = load(ARTS[pick])
	art.set_anchors_preset(Control.PRESET_FULL_RECT)
	art.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	art.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	add_child(art)
	var shade := ColorRect.new()
	shade.color = Color(0, 0, 0, 0.35)
	shade.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(shade)
	var verse := Label.new()
	verse.text = VERSES[pick]
	verse.add_theme_font_size_override("font_size", 34)
	verse.add_theme_color_override("font_color", Color(0.91, 0.84, 0.69))
	verse.add_theme_color_override("font_outline_color", Color.BLACK)
	verse.add_theme_constant_override("outline_size", 10)
	verse.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_LEFT)
	verse.offset_left = 80
	verse.offset_top = -260
	add_child(verse)
	bar = ProgressBar.new()
	bar.show_percentage = false
	bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bar.offset_top = -14
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.45, 0.02, 0.02)
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0, 0, 0, 0.6)
	bar.add_theme_stylebox_override("fill", fill)
	bar.add_theme_stylebox_override("background", back)
	add_child(bar)
	ResourceLoader.load_threaded_request(next_scene)


func _process(delta: float) -> void:
	elapsed += delta
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
	tree.change_scene_to_file("res://ui/carregamento.tscn")
