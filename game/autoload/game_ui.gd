extends CanvasLayer

const MENU_SCENE := "res://game/ui/menu.tscn"
const LENS_CRACK := [Vector2(1920, 120), Vector2(1840, 210), Vector2(1862, 260), Vector2(1790, 360), Vector2(1808, 420), Vector2(1745, 520)]

var hit_flash := 0.0
var death_reason := "UI_DEATH_DEFAULT"
var overlay: CanvasLayer
var vignette: ShaderMaterial
var lens_crack: Line2D
var objective_label: Label
var pause_menu: PauseMenu
var death_screen: DeathScreen


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	_build_overlay()
	pause_menu = PauseMenu.new()
	pause_menu.visible = false
	pause_menu.resume_requested.connect(func(): set_paused(false))
	pause_menu.settings_requested.connect(_open_settings)
	pause_menu.menu_requested.connect(_back_to_menu)
	add_child(pause_menu)
	death_screen = DeathScreen.new()
	death_screen.visible = false
	death_screen.retry_requested.connect(_retry)
	add_child(death_screen)
	if not InputMap.has_action("pause"):
		InputMap.add_action("pause")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_P
		InputMap.action_add_event("pause", key)
	Global.player_health_changed.connect(_on_health_changed)
	Global.player_dead.connect(_on_player_dead)
	set_overlay_visible(false)


func reset() -> void:
	hit_flash = 0.0
	death_reason = "UI_DEATH_DEFAULT"
	vignette.set_shader_parameter("blood", 0.0)
	vignette.set_shader_parameter("hit", 0.0)
	death_screen.visible = false
	lens_crack.visible = Story.flag("lens") == "cracked"
	set_objective("")
	set_overlay_visible(true)


func set_objective(text_key: String) -> void:
	objective_label.text = tr(text_key) if text_key != "" else ""
	if text_key != "":
		objective_label.modulate.a = 0.0
		create_tween().tween_property(objective_label, "modulate:a", 1.0, 0.8)


func set_overlay_visible(visible_now: bool) -> void:
	overlay.visible = visible_now


func crack_lens() -> void:
	Story.set_flag("lens", "cracked")
	lens_crack.visible = true


func set_paused(paused: bool) -> void:
	pause_menu.visible = paused
	get_tree().paused = paused
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE if paused else Input.MOUSE_MODE_CAPTURED)


func _process(delta: float) -> void:
	hit_flash = maxf(0.0, hit_flash - delta * 2.5)
	vignette.set_shader_parameter("hit", hit_flash)
	vignette.set_shader_parameter("hunger", Pact.hunger / 100.0 if Pact.active and Pact.hunger_enabled else 0.0)
	if Input.is_action_just_pressed("pause") and (Pact.active or pause_menu.visible):
		set_paused(not pause_menu.visible)


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST and Pact.active:
		_back_to_menu()


func _build_overlay() -> void:
	overlay = CanvasLayer.new()
	overlay.layer = 4
	add_child(overlay)
	var rect := ColorRect.new()
	rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	vignette = ShaderMaterial.new()
	vignette.shader = preload("res://resources/shaders/vignette.gdshader")
	rect.material = vignette
	overlay.add_child(rect)
	lens_crack = Line2D.new()
	lens_crack.width = 2.0
	lens_crack.default_color = Color(0.85, 0.85, 0.8, 0.55)
	lens_crack.points = PackedVector2Array(LENS_CRACK)
	lens_crack.visible = Story.flag("lens") == "cracked"
	overlay.add_child(lens_crack)
	objective_label = Label.new()
	objective_label.position = Vector2(48, 40)
	objective_label.add_theme_font_size_override("font_size", 30)
	objective_label.add_theme_color_override("font_color", Color(0.91, 0.86, 0.75))
	objective_label.add_theme_color_override("font_outline_color", Color(0.25, 0.0, 0.0))
	objective_label.add_theme_constant_override("outline_size", 8)
	overlay.add_child(objective_label)


func _on_health_changed(change: float, current: float, max_health: float, _enemy: bool) -> void:
	vignette.set_shader_parameter("blood", 1.0 - current / max_health)
	if change < 0.0:
		hit_flash = 1.0


func _on_player_dead() -> void:
	Pact.active = false
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death_screen.show_message(death_reason)


func _retry() -> void:
	death_screen.visible = false
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()


func _open_settings() -> void:
	var menu := SettingsMenu.new()
	add_child(menu)


func _back_to_menu() -> void:
	set_paused(false)
	Pact.stop()
	Dialogue.clear()
	get_tree().change_scene_to_file(MENU_SCENE)
