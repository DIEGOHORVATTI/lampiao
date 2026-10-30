extends CanvasLayer

const STICK_RADIUS := 110.0
const LOOK_SENSITIVITY := 0.006
const ICON_DIR := "res://resources/ui/icons/%s.svg"
const INK := Color(0.91, 0.86, 0.75)
const DISC := Color(0.04, 0.03, 0.02)
const SAFE_X := 90.0
const SAFE_BOTTOM := 40.0
const BUTTONS := [
	{"action": "fire", "icon": "fire", "from": "br", "pos": Vector2(260, 280), "size": 210, "alpha": 0.4},
	{"action": "fire", "icon": "fire", "from": "tl", "pos": Vector2(300, 480), "size": 120, "alpha": 0.25},
	{"action": "aim_mode", "icon": "aim", "from": "br", "pos": Vector2(90, 470), "size": 130, "alpha": 0.35},
	{"action": "jump", "icon": "jump", "from": "br", "pos": Vector2(90, 120), "size": 110, "alpha": 0.3},
	{"action": "reload", "icon": "reload", "from": "br", "pos": Vector2(450, 120), "size": 110, "alpha": 0.3},
	{"action": "tentacles", "icon": "tentacles", "from": "br", "pos": Vector2(360, 520), "size": 110, "alpha": 0.35},
	{"action": "rosary", "icon": "rosary", "from": "tl", "pos": Vector2(300, 300), "size": 100, "alpha": 0.3},
	{"action": "activate", "icon": "use", "from": "br", "pos": Vector2(490, 460), "size": 120, "alpha": 0.5, "contextual": true},
	{"action": "weapon_change_next", "icon": "swap", "from": "tr", "pos": Vector2(220, 80), "size": 90, "alpha": 0.3},
	{"action": "pause", "icon": "", "label": "II", "from": "tl", "pos": Vector2(110, 80), "size": 72, "alpha": 0.3},
]

var move_finger := -1
var move_origin := Vector2.ZERO
var look_finger := -1
var stick_ring: TextureRect
var stick_ghost: TextureRect
var buttons: Array[TouchScreenButton] = []


func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		queue_free()
		return
	layer = 10
	if not InputMap.has_action("pause"):
		InputMap.add_action("pause")
	stick_ghost = _circle_rect(STICK_RADIUS * 1.6, Color(INK, 0.12))
	add_child(stick_ghost)
	stick_ring = _circle_rect(STICK_RADIUS * 2, Color(INK, 0.22))
	stick_ring.visible = false
	add_child(stick_ring)
	for spec in BUTTONS:
		var button := _build_button(spec)
		buttons.append(button)
		add_child(button)
	get_viewport().size_changed.connect(_place)
	_place()


func _process(_delta: float) -> void:
	visible = Pact.active
	for button in buttons:
		if button.get_meta("contextual", false):
			button.visible = Dialogue.prompt.text.begins_with("USAR")


func _input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventScreenTouch:
		_on_touch(event)
	elif event is InputEventScreenDrag:
		_on_drag(event)


func _on_touch(event: InputEventScreenTouch) -> void:
	var half := get_viewport().get_visible_rect().size.x / 2.0
	if event.pressed:
		if _over_button(event.position):
			return
		if event.position.x < half and move_finger == -1:
			move_finger = event.index
			move_origin = event.position
			stick_ring.position = move_origin - stick_ring.size / 2.0
			stick_ring.visible = true
			stick_ghost.visible = false
		elif event.position.x >= half and look_finger == -1:
			look_finger = event.index
		return
	if event.index == move_finger:
		move_finger = -1
		stick_ring.visible = false
		stick_ghost.visible = true
		for action in ["left", "right", "forward", "backward"]:
			Input.action_release(action)
	elif event.index == look_finger:
		look_finger = -1


func _on_drag(event: InputEventScreenDrag) -> void:
	if event.index == move_finger:
		var v := ((event.position - move_origin) / STICK_RADIUS).limit_length(1.0)
		_set_axis("left", "right", v.x)
		_set_axis("forward", "backward", v.y)
	elif event.index == look_finger and Global.player:
		Global.player.look(event.relative * LOOK_SENSITIVITY)


func _set_axis(negative: String, positive: String, value: float) -> void:
	if value < 0:
		Input.action_press(negative, -value)
		Input.action_release(positive)
	else:
		Input.action_press(positive, value)
		Input.action_release(negative)


func button_center(index: int) -> Vector2:
	var button := buttons[index]
	return button.position + button.texture_normal.get_size() / 2.0


func _build_button(spec: Dictionary) -> TouchScreenButton:
	var size: float = spec.size
	var button := TouchScreenButton.new()
	button.action = spec.action
	button.texture_normal = _circle_texture(size, Color(DISC, spec.alpha))
	button.texture_pressed = _circle_texture(size, Color(0.35, 0.05, 0.03, 0.6))
	button.set_meta("spec", spec)
	button.set_meta("contextual", spec.get("contextual", false))
	if spec.icon != "":
		var icon := Sprite2D.new()
		icon.texture = load(ICON_DIR % spec.icon)
		icon.centered = true
		icon.position = Vector2(size, size) / 2.0
		icon.scale = Vector2.ONE * (size * 0.58 / icon.texture.get_width())
		icon.modulate = Color(INK, minf(1.0, spec.alpha + 0.45))
		button.add_child(icon)
	else:
		var label := Label.new()
		label.text = spec.label
		label.size = Vector2(size, size)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", int(size * 0.4))
		label.add_theme_color_override("font_color", Color(INK, 0.8))
		button.add_child(label)
	return button


func _place() -> void:
	var screen := get_viewport().get_visible_rect().size
	for button in buttons:
		var spec: Dictionary = button.get_meta("spec")
		var half := Vector2(spec.size, spec.size) / 2.0
		var center: Vector2
		match spec.from:
			"br": center = Vector2(screen.x - spec.pos.x, screen.y - spec.pos.y)
			"tr": center = Vector2(screen.x - spec.pos.x, spec.pos.y)
			"tl": center = spec.pos
		center.x = clampf(center.x, SAFE_X + half.x, screen.x - SAFE_X - half.x)
		center.y = minf(center.y, screen.y - SAFE_BOTTOM - half.y)
		button.position = center - half
	stick_ghost.position = Vector2(260, screen.y - 260) - stick_ghost.size / 2.0


func _over_button(point: Vector2) -> bool:
	for button in buttons:
		if button.visible and Rect2(button.position, button.texture_normal.get_size()).has_point(point):
			return true
	return false


func _circle_rect(diameter: float, color: Color) -> TextureRect:
	var rect := TextureRect.new()
	rect.texture = _circle_texture(diameter, color)
	rect.size = Vector2(diameter, diameter)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rect


func _circle_texture(diameter: float, color: Color) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.offsets = PackedFloat32Array([0.0, 0.9, 0.97, 1.0])
	gradient.colors = PackedColorArray([color, color, Color(INK, color.a * 0.9), Color(INK, 0.0)])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0.5, 0.0)
	texture.width = int(diameter)
	texture.height = int(diameter)
	return texture
