extends CanvasLayer

signal hunger_changed(value: float)

const HUNGER_PER_SECOND := 0.8
const HUNGER_PER_MEAL := 30.0
const HEAL_PER_MEAL := 15.0
const POSSESSION_DAMAGE := 1000.0

var hunger := 0.0
var active := false
var fps_log_timer := 0.0

var hunger_bar: ProgressBar
var death_screen: Control
var death_message: Label


func _ready() -> void:
	layer = 20
	process_mode = Node.PROCESS_MODE_ALWAYS
	hunger_bar = _bar(Vector2(70, 135), Color(0.55, 0.08, 0.12), "FOME DO ENCOSTO")
	death_screen = _build_death_screen()
	Global.player_dead.connect(_on_player_dead)
	_set_hud_visible(false)


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


func comer() -> void:
	feed(HUNGER_PER_MEAL)
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
		Dialogo.limpar()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://ui/menu.tscn")


func _process(delta: float) -> void:
	fps_log_timer += delta
	if OS.is_debug_build() and OS.has_feature("mobile") and fps_log_timer > 5.0:
		fps_log_timer = 0.0
		print("LAMPIAO_FPS %d draw_calls %d" % [Engine.get_frames_per_second(), Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)])
	if not active or get_tree().paused:
		return
	hunger = minf(100.0, hunger + HUNGER_PER_SECOND * delta)
	_emit()
	if hunger >= 100.0 and Global.player and Global.player.is_alive:
		death_message.text = "O Encosto cansou de esperar.\nAgora a carniça é você."
		Global.player.get_damage(POSSESSION_DAMAGE, Vector3.ZERO)


func _on_player_dead() -> void:
	if death_message.text == "":
		death_message.text = "O sertão te engoliu."
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
	hunger_bar.value = hunger
	hunger_changed.emit(hunger)


func _set_hud_visible(visible_now: bool) -> void:
	get_node("Barras").visible = visible_now


func _bar(pos: Vector2, color: Color, caption: String) -> ProgressBar:
	var box := VBoxContainer.new()
	box.position = pos
	box.add_theme_constant_override("separation", 0)
	if not has_node("Barras"):
		var holder := Control.new()
		holder.name = "Barras"
		holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(holder)
	get_node("Barras").add_child(box)
	var label := Label.new()
	label.text = caption
	label.add_theme_font_size_override("font_size", 18)
	label.add_theme_color_override("font_color", Color(0.91, 0.84, 0.69))
	box.add_child(label)
	var bar := ProgressBar.new()
	bar.custom_minimum_size = Vector2(400, 14)
	bar.show_percentage = false
	var fill := StyleBoxFlat.new()
	fill.bg_color = color
	var back := StyleBoxFlat.new()
	back.bg_color = Color(0, 0, 0, 0.55)
	bar.add_theme_stylebox_override("fill", fill)
	bar.add_theme_stylebox_override("background", back)
	box.add_child(bar)
	return bar


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
	hint.text = "toque para tentar de novo"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	hint.offset_top = -120
	hint.add_theme_font_size_override("font_size", 36)
	screen.add_child(hint)
	return screen
