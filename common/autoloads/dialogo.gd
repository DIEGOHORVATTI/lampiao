extends CanvasLayer

signal _choice_made(index: int)

const SPEAKER_COLORS := {
	"ENCOSTO": Color(0.75, 0.15, 0.2),
	"LAMPIÃO": Color(0.95, 0.65, 0.25),
}
const SECONDS_PER_CHAR := 0.055
const MIN_LINE_SECONDS := 2.2

var subtitle: Label
var prompt: Label
var choice_buttons: Array[TouchScreenButton] = []
var talking := false


func _ready() -> void:
	layer = 15
	process_mode = Node.PROCESS_MODE_ALWAYS
	subtitle = _label(40, Control.PRESET_BOTTOM_WIDE, -260)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.offset_left = 260
	subtitle.offset_right = -260
	prompt = _label(38, Control.PRESET_CENTER, 120)
	for action in ["escolha_1", "escolha_2", "escolha_3"]:
		if not InputMap.has_action(action):
			InputMap.add_action(action)
			var key := InputEventKey.new()
			key.physical_keycode = KEY_1 + choice_buttons.size()
			InputMap.action_add_event(action, key)
		var button := TouchScreenButton.new()
		button.action = action
		button.visible = false
		var label := Label.new()
		label.name = "Texto"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 34)
		label.add_theme_color_override("font_color", Color(0.95, 0.88, 0.72))
		button.add_child(label)
		add_child(button)
		choice_buttons.append(button)


func falar(lines: Array) -> void:
	talking = true
	for line in lines:
		var speaker: String = line[0]
		var text: String = line[1]
		var color: Color = SPEAKER_COLORS.get(speaker, Color(0.88, 0.84, 0.76))
		subtitle.add_theme_color_override("font_color", color)
		subtitle.text = text if speaker == "" else "%s: %s" % [speaker, text]
		await get_tree().create_timer(maxf(MIN_LINE_SECONDS, text.length() * SECONDS_PER_CHAR)).timeout
	subtitle.text = ""
	talking = false


func mostrar_prompt(text: String) -> void:
	prompt.text = text


func esconder_prompt() -> void:
	prompt.text = ""


func escolher(options: Array, timeout := 0.0, on_timeout := Callable()) -> int:
	var screen := get_viewport().get_visible_rect().size
	var width := 620.0
	var gap := 40.0
	var total := options.size() * width + (options.size() - 1) * gap
	for i in choice_buttons.size():
		var button := choice_buttons[i]
		button.visible = i < options.size()
		if not button.visible:
			continue
		button.texture_normal = _rect_texture(Vector2(width, 110), Color(0.25, 0.05, 0.03, 0.8))
		button.texture_pressed = _rect_texture(Vector2(width, 110), Color(0.6, 0.25, 0.08, 0.9))
		button.position = Vector2((screen.x - total) / 2.0 + i * (width + gap), screen.y * 0.55)
		var label: Label = button.get_node("Texto")
		label.size = Vector2(width, 110)
		label.text = "%d · %s" % [i + 1, options[i]]
	var timer := 0.0
	var choice := -1
	while choice == -1:
		await get_tree().process_frame
		for i in options.size():
			if Input.is_action_just_pressed("escolha_%d" % (i + 1)):
				choice = i
		timer += get_process_delta_time()
		if timeout > 0.0 and timer >= timeout:
			timer = 0.0
			if on_timeout.is_valid():
				on_timeout.call()
	for button in choice_buttons:
		button.visible = false
	return choice


func segurar(text: String, seconds: float, nag := Callable()) -> void:
	var held := 0.0
	var idle := 0.0
	while held < seconds:
		await get_tree().process_frame
		var dt := get_process_delta_time()
		if Input.is_action_pressed("activate"):
			held += dt
			idle = 0.0
		else:
			held = 0.0
			idle += dt
			if idle > 6.0 and nag.is_valid():
				idle = 0.0
				nag.call()
		prompt.text = "%s  %s" % [text, "▮".repeat(int(held / seconds * 10.0)) + "▯".repeat(10 - int(held / seconds * 10.0))]
	prompt.text = ""


func _label(font_size: int, preset: int, offset: float) -> Label:
	var label := Label.new()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_and_offsets_preset(preset)
	if preset == Control.PRESET_BOTTOM_WIDE:
		label.offset_top = offset
		label.offset_bottom = offset + 140
	else:
		label.offset_left = -700
		label.offset_right = 700
		label.offset_top = offset
		label.offset_bottom = offset + 60
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 10)
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(label)
	return label


func _rect_texture(size: Vector2, color: Color) -> ImageTexture:
	var image := Image.create(int(size.x), int(size.y), false, Image.FORMAT_RGBA8)
	image.fill(color)
	return ImageTexture.create_from_image(image)
