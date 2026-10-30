extends Node

signal hunger_changed(value: float)

const HUNGER_PER_SECOND := 0.8
const ROSARY_HUNGER_FACTOR := 0.15
const HUNGER_PER_MEAL := 30.0
const HEAL_PER_MEAL := 15.0
const POSSESSION_DAMAGE := 1000.0

var hunger := 0.0
var meal_value := HUNGER_PER_MEAL
var hunger_enabled := true
var active := false
var fps_log_timer := 0.0


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS


func start_level(start_hunger := 0.0) -> void:
	hunger = start_hunger
	active = true
	Global.enemies_killed = 0
	get_tree().paused = false
	GameUI.reset()
	hunger_changed.emit(hunger)


func stop() -> void:
	active = false
	GameUI.set_overlay_visible(false)


func feed(amount: float) -> void:
	hunger = maxf(0.0, hunger - amount)
	hunger_changed.emit(hunger)


func eat() -> void:
	feed(meal_value)
	heal(HEAL_PER_MEAL)


func heal(amount: float) -> void:
	var player := Global.player
	if not player:
		return
	player.current_health = minf(player.MAX_HEALTH, player.current_health + amount)
	Global.player_health_changed.emit(amount, player.current_health, player.MAX_HEALTH, false)


func _process(delta: float) -> void:
	_log_fps(delta)
	if not active or get_tree().paused:
		return
	var rate := HUNGER_PER_SECOND * (ROSARY_HUNGER_FACTOR if Powers.rosary_active else 1.0) * (1.0 if hunger_enabled else 0.0)
	hunger = minf(100.0, hunger + rate * delta)
	hunger_changed.emit(hunger)
	if hunger_enabled and not Powers.entity_mode and hunger >= 100.0 and Global.player and Global.player.is_alive:
		GameUI.death_reason = "UI_DEATH_HUNGER"
		Global.player.get_damage(POSSESSION_DAMAGE, Vector3.ZERO)


func _log_fps(delta: float) -> void:
	fps_log_timer += delta
	if OS.is_debug_build() and OS.has_feature("mobile") and fps_log_timer > 5.0:
		fps_log_timer = 0.0
		print("LAMPIAO_FPS %d draw_calls %d" % [Engine.get_frames_per_second(), Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)])
