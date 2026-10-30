extends CanvasLayer

signal _choice_made(index: int)

const SPEAKER_COLORS := {
	"SPEAKER_ELA": Color(0.75, 0.15, 0.2),
	"SPEAKER_LAMPIAO": Color(0.95, 0.65, 0.25),
}
const SECONDS_PER_CHAR := 0.085
const BASE_LINE_SECONDS := 1.5
const MIN_LINE_SECONDS := 3.0
const MIN_BEFORE_SKIP := 0.6
const VOICE_PATH := "res://resources/voices/%s.ogg"
const VOICE_TAIL := 0.35

var subtitle: Label
var prompt: Label
var choice_buttons: Array[TouchScreenButton] = []
var talking := false
var fader: ColorRect
var card: Label
var hold_bar: ProgressBar
var screen_held := false
var advance_requested := false
var continue_hint: Label
var voice: AudioStreamPlayer


func _ready() -> void:
	layer = 15
	process_mode = Node.PROCESS_MODE_ALWAYS
	voice = AudioStreamPlayer.new()
	add_child(voice)
	subtitle = _label(40, Control.PRESET_BOTTOM_WIDE, -260)
	subtitle.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle.offset_left = 260
	subtitle.offset_right = -260
	prompt = _label(38, Control.PRESET_CENTER, 120)
	fader = ColorRect.new()
	fader.color = Color(0, 0, 0, 0)
	fader.set_anchors_preset(Control.PRESET_FULL_RECT)
	fader.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fader)
	move_child(fader, 0)
	card = Label.new()
	card.set_anchors_preset(Control.PRESET_FULL_RECT)
	card.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	card.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	card.add_theme_font_size_override("font_size", 44)
	card.add_theme_color_override("font_color", Color(0.91, 0.84, 0.69))
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(card)
	continue_hint = _label(26, Control.PRESET_BOTTOM_WIDE, -90)
	continue_hint.text = tr("UI_CONTINUE")
	continue_hint.modulate.a = 0.6
	continue_hint.visible = false
	hold_bar = ProgressBar.new()
	hold_bar.show_percentage = false
	hold_bar.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	hold_bar.offset_left = -260
	hold_bar.offset_right = 260
	hold_bar.offset_top = 190
	hold_bar.offset_bottom = 204
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color(0.6, 0.08, 0.1)
	var back := StyleBoxFlat.new()
	back.bg_color = Color(1, 1, 1, 0.12)
	hold_bar.add_theme_stylebox_override("fill", fill)
	hold_bar.add_theme_stylebox_override("background", back)
	hold_bar.visible = false
	add_child(hold_bar)
	for action in ["choice_1", "choice_2", "choice_3"]:
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


func say(lines: Array) -> void:
	talking = true
	for line in lines:
		var speaker: String = line[0]
		var text: String = line[1]
		var color: Color = SPEAKER_COLORS.get(speaker, Color(0.88, 0.84, 0.76))
		subtitle.add_theme_color_override("font_color", color)
		subtitle.text = tr(text) if speaker == "" else "%s: %s" % [tr(speaker), tr(text)]
		await _wait_line(maxf(reading_time(subtitle.text), _speak(text)))
		voice.stop()
	subtitle.text = ""
	talking = false


func reading_time(text: String) -> float:
	return maxf(MIN_LINE_SECONDS, BASE_LINE_SECONDS + text.length() * SECONDS_PER_CHAR)


func _in_cutscene() -> bool:
	return not Pact.active


func _wait_line(auto_seconds: float) -> void:
	var elapsed := 0.0
	advance_requested = false
	while elapsed < auto_seconds:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
		continue_hint.visible = _in_cutscene() and elapsed > MIN_BEFORE_SKIP
		if advance_requested and elapsed > MIN_BEFORE_SKIP and _in_cutscene():
			break
	continue_hint.visible = false
	advance_requested = false


func fade(alpha: float, seconds: float, color := Color.BLACK) -> void:
	color.a = fader.color.a
	fader.color = color
	await create_tween().tween_property(fader, "color:a", alpha, seconds).finished


func show_card(text: String, seconds: float) -> void:
	card.text = tr(text)
	card.modulate.a = 0.0
	await create_tween().tween_property(card, "modulate:a", 1.0, 1.0).finished
	await _wait_line(maxf(maxf(seconds, reading_time(text)), _speak(text)))
	voice.stop()
	await create_tween().tween_property(card, "modulate:a", 0.0, 1.0).finished
	card.text = ""


func _speak(key: String) -> float:
	var path := VOICE_PATH % key
	if not ResourceLoader.exists(path):
		return 0.0
	voice.stream = load(path)
	voice.play()
	return voice.stream.get_length() + VOICE_TAIL


func clear() -> void:
	voice.stop()
	subtitle.text = ""
	prompt.text = ""
	card.text = ""
	fader.color.a = 0.0
	talking = false
	for button in choice_buttons:
		button.visible = false


func show_prompt(text: String) -> void:
	prompt.text = tr(text)


func hide_prompt() -> void:
	prompt.text = ""


func choose(options: Array, timeout := 0.0, on_timeout := Callable()) -> int:
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
		label.text = "%d · %s" % [i + 1, tr(options[i])]
	var timer := 0.0
	var choice := -1
	while choice == -1:
		await get_tree().process_frame
		for i in options.size():
			if Input.is_action_pressed("choice_%d" % (i + 1)):
				choice = i
		timer += get_process_delta_time()
		if timeout > 0.0 and timer >= timeout:
			timer = 0.0
			if on_timeout.is_valid():
				on_timeout.call()
	for button in choice_buttons:
		button.visible = false
	return choice


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		screen_held = event.pressed
		if event.pressed:
			advance_requested = true
	elif event.is_action_pressed("ui_accept"):
		advance_requested = true


func hold(text: String, seconds: float, nag := Callable()) -> void:
	var held := 0.0
	var idle := 0.0
	prompt.text = tr(text)
	hold_bar.visible = true
	while held < seconds:
		await get_tree().process_frame
		var dt := get_process_delta_time()
		if Input.is_action_pressed("activate") or screen_held:
			held += dt
			idle = 0.0
		else:
			held = 0.0
			idle += dt
			if idle > 6.0 and nag.is_valid():
				idle = 0.0
				nag.call()
		hold_bar.value = held / seconds * 100.0
	prompt.text = ""
	hold_bar.visible = false


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
