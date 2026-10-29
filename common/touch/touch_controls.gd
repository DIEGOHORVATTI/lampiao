extends CanvasLayer

const STICK_RADIUS := 110.0
const LOOK_SENSITIVITY := 0.006
const BUTTON_SIZE := 150.0
const MOVE_ACTIONS := ["left", "right", "forward", "backward"]
const BUTTONS := [
	{"action": "fire", "label": "🔥", "anchor": Vector2(-200, -260), "scale": 1.3},
	{"action": "aim_mode", "label": "◎", "anchor": Vector2(-400, -200), "scale": 1.0},
	{"action": "jump", "label": "⤒", "anchor": Vector2(-200, -470), "scale": 0.8},
	{"action": "reload", "label": "↻", "anchor": Vector2(-380, -420), "scale": 0.8},
	{"action": "activate", "label": "✋", "anchor": Vector2(-560, -260), "scale": 0.8},
	{"action": "weapon_change_next", "label": "⇄", "anchor": Vector2(-200, -640), "scale": 0.7},
]

var move_finger := -1
var move_origin := Vector2.ZERO
var look_finger := -1
var stick_ring: TextureRect


func _ready() -> void:
	if not DisplayServer.is_touchscreen_available():
		queue_free()
		return
	layer = 10
	stick_ring = _circle_rect(STICK_RADIUS * 2, Color(0.91, 0.84, 0.69, 0.25))
	stick_ring.visible = false
	add_child(stick_ring)
	for spec in BUTTONS:
		add_child(_build_button(spec))
	get_viewport().size_changed.connect(_place_buttons)
	_place_buttons()


func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		_on_touch(event)
	elif event is InputEventScreenDrag:
		_on_drag(event)


func _on_touch(event: InputEventScreenTouch) -> void:
	var half := get_viewport().get_visible_rect().size.x / 2.0
	if event.pressed:
		if event.position.x < half and move_finger == -1:
			move_finger = event.index
			move_origin = event.position
			stick_ring.position = move_origin - stick_ring.size / 2.0
			stick_ring.visible = true
		elif event.position.x >= half and look_finger == -1 and not _over_button(event.position):
			look_finger = event.index
		return
	if event.index == move_finger:
		move_finger = -1
		stick_ring.visible = false
		for action in MOVE_ACTIONS:
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


func _build_button(spec: Dictionary) -> TouchScreenButton:
	var size: float = BUTTON_SIZE * spec.scale
	var button := TouchScreenButton.new()
	button.action = spec.action
	button.texture_normal = _circle_texture(size, Color(0.54, 0.11, 0.05, 0.45))
	button.texture_pressed = _circle_texture(size, Color(0.78, 0.39, 0.12, 0.7))
	button.set_meta("anchor", spec.anchor)
	var label := Label.new()
	label.text = spec.label
	label.size = Vector2(size, size)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", int(size * 0.4))
	button.add_child(label)
	return button


func _place_buttons() -> void:
	var screen := get_viewport().get_visible_rect().size
	for child in get_children():
		if child is TouchScreenButton:
			child.position = screen + child.get_meta("anchor")


func _over_button(point: Vector2) -> bool:
	for child in get_children():
		if child is TouchScreenButton:
			var size: Vector2 = child.texture_normal.get_size()
			if Rect2(child.position, size).has_point(point):
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
	gradient.offsets = PackedFloat32Array([0.0, 0.92, 1.0])
	gradient.colors = PackedColorArray([color, color, Color(color, 0.0)])
	var texture := GradientTexture2D.new()
	texture.gradient = gradient
	texture.fill = GradientTexture2D.FILL_RADIAL
	texture.fill_from = Vector2(0.5, 0.5)
	texture.fill_to = Vector2(0.5, 0.0)
	texture.width = int(diameter)
	texture.height = int(diameter)
	return texture
