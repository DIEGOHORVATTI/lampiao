extends CanvasLayer

signal hunger_changed(value: float)

const HUNGER_PER_SECOND := 0.8
const ROSARY_HUNGER_FACTOR := 0.15
const HUNGER_PER_MEAL := 30.0
const HEAL_PER_MEAL := 15.0
const POSSESSION_DAMAGE := 1000.0

var hunger := 0.0
var meal_value := HUNGER_PER_MEAL
var hunger_enabled := true
var lens_crack: Line2D
var active := false
var fps_log_timer := 0.0

var vignette: ShaderMaterial
var pause_screen: Control
var hit_flash := 0.0
var death_screen: Control
var death_message: Label


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_vignette()
	_build_lens_crack()
	pause_screen = _build_pause_screen()
	if not InputMap.has_action("pause"):
		InputMap.add_action("pause")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_P
		InputMap.action_add_event("pause", key)
	Global.player_health_changed.connect(_on_health_changed)
	death_screen = _build_death_screen()
	Global.player_dead.connect(_on_player_dead)
	_set_hud_visible(false)


func _build_vignette() -> void:
	var holder := CanvasLayer.new()
	holder.name = "Vinheta"
	holder.layer = 4
	add_child(holder)
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette = ShaderMaterial.new()
	vignette.shader = preload("res://resources/shaders/vinheta.gdshader")
	rect.material = vignette
	holder.add_child(rect)


func _build_lens_crack() -> void:
	lens_crack = Line2D.new()
	lens_crack.width = 2.0
	lens_crack.default_color = Color(0.85, 0.85, 0.8, 0.55)
	lens_crack.points = PackedVector2Array([Vector2(1920, 120), Vector2(1840, 210), Vector2(1862, 260), Vector2(1790, 360), Vector2(1808, 420), Vector2(1745, 520)])
	lens_crack.visible = Story.flag("lens") == "cracked"
	get_node("Vinheta").add_child(lens_crack)


func crack_lens() -> void:
	Story.set_flag("lens", "cracked")
	lens_crack.visible = true


func _on_health_changed(change: float, current: float, max_health: float, _enemy: bool) -> void:
	vignette.set_shader_parameter("blood", 1.0 - current / max_health)
	if change < 0.0:
		hit_flash = 1.0


func _build_pause_screen() -> Control:
	var screen := ColorRect.new()
	screen.color = Color(0.03, 0.02, 0.02, 0.88)
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.visible = false
	add_child(screen)
	var title := Label.new()
	title.text = tr("UI_PAUSE_TITLE")
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	title.offset_top = 200
	title.add_theme_font_size_override("font_size", 64)
	title.add_theme_color_override("font_color", Color(0.72, 0.53, 0.17))
	screen.add_child(title)
	for i in 2:
		var action := "pause_resume" if i == 0 else "pause_to_menu"
		if not InputMap.has_action(action):
			InputMap.add_action(action)
		var button := TouchScreenButton.new()
		button.action = action
		var image := Image.create(560, 110, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.43, 0.08, 0.08, 0.55))
		button.texture_normal = ImageTexture.create_from_image(image)
		button.position = Vector2(680, 430 + i * 160)
		var label := Label.new()
		label.text = tr("UI_PAUSE_RESUME") if i == 0 else tr("UI_PAUSE_TO_MENU")
		label.size = Vector2(560, 110)
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		label.add_theme_font_size_override("font_size", 40)
		label.add_theme_color_override("font_color", Color(0.91, 0.86, 0.75))
		button.add_child(label)
		screen.add_child(button)
	return screen


func pause(paused: bool) -> void:
	pause_screen.visible = paused
	get_tree().paused = paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED)


func start_level(start_hunger := 0.0) -> void:
	hunger = start_hunger
	active = true
	Global.enemies_killed = 0
	get_tree().paused = false
	death_screen.visible = false
	_set_hud_visible(true)
	_emit()


func stop() -> void:
	active = false
	_set_hud_visible(false)


func feed(amount: float) -> void:
	hunger = maxf(0.0, hunger - amount)
	_emit()


func eat() -> void:
	feed(meal_value)
	heal(HEAL_PER_MEAL)


func heal(amount: float) -> void:
	var player := Global.player
	if not player:
		return
	player.current_health = minf(player.MAX_HEALTH, player.current_health + amount)
	Global.player_health_changed.emit(amount, player.current_health, player.MAX_HEALTH, false)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and active:
		stop()
		Dialogue.clear()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://game/ui/menu.tscn")


func _process(delta: float) -> void:
	hit_flash = maxf(0.0, hit_flash - delta * 2.5)
	vignette.set_shader_parameter("hit", hit_flash)
	vignette.set_shader_parameter("hunger", hunger / 100.0 if active and hunger_enabled else 0.0)
	if Input.is_action_just_pressed("pause") and (active or pause_screen.visible):
		pause(not pause_screen.visible)
	if pause_screen.visible:
		if Input.is_action_just_pressed("pause_resume"):
			pause(false)
		elif Input.is_action_just_pressed("pause_to_menu"):
			pause(false)
			stop()
			Dialogue.clear()
			get_tree().change_scene_to_file("res://game/ui/menu.tscn")
		return
	fps_log_timer += delta
	if OS.is_debug_build() and OS.has_feature("mobile") and fps_log_timer > 5.0:
		fps_log_timer = 0.0
		print("LAMPIAO_FPS %d draw_calls %d" % [Engine.get_frames_per_second(), Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)])
	if not active or get_tree().paused:
		return
	var rate := HUNGER_PER_SECOND * (ROSARY_HUNGER_FACTOR if Powers.rosary_active else 1.0) * (1.0 if hunger_enabled else 0.0)
	hunger = minf(100.0, hunger + rate * delta)
	_emit()
	if hunger_enabled and not Powers.entity_mode and hunger >= 100.0 and Global.player and Global.player.is_alive:
		death_message.text = tr("UI_DEATH_HUNGER")
		Global.player.get_damage(POSSESSION_DAMAGE, Vector3.ZERO)


func _on_player_dead() -> void:
	if death_message.text == "":
		death_message.text = tr("UI_DEATH_DEFAULT")
	active = false
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death_screen.visible = true


func _input(event: InputEvent) -> void:
	if not death_screen.visible:
		return
	var tapped: bool = event is InputEventScreenTouch and event.pressed
	var clicked: bool = event is InputEventMouseButton and event.pressed
	if tapped or clicked:
		death_screen.visible = false
		death_message.text = ""
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().reload_current_scene()


func _emit() -> void:
	hunger_changed.emit(hunger)


func _set_hud_visible(visible_now: bool) -> void:
	get_node("Vinheta").visible = visible_now




func _build_death_screen() -> Control:
	var screen := ColorRect.new()
	screen.color = Color(0.08, 0.0, 0.0, 0.85)
	screen.set_anchors_preset(Control.PRESET_FULL_RECT)
	screen.visible = false
	add_child(screen)
	death_message = Label.new()
	death_message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	death_message.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	death_message.set_anchors_preset(Control.PRESET_FULL_RECT)
	death_message.add_theme_font_size_override("font_size", 56)
	death_message.add_theme_color_override("font_color", Color(0.85, 0.45, 0.15))
	screen.add_child(death_message)
	var hint := Label.new()
	hint.text = tr("UI_DEATH_RETRY")
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	hint.offset_top = -120
	hint.add_theme_font_size_override("font_size", 36)
	screen.add_child(hint)
	return screen
