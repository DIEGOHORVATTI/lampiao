class_name ChapterDirector
extends Node3D

const NPC := preload("res://game/world/components/npc.gd")
const SOLDIER := preload("res://game/enemies/soldier.tscn")
const INTERACTABLE := preload("res://game/world/components/interactable.gd")
const HIT_TARGET := preload("res://game/world/components/hit_target.gd")

var environment: Environment
var cast := {}
var soldiers: Array = []
var beat := 0
var trail: Node3D


func _ready() -> void:
	await get_tree().process_frame
	environment = find_child("WorldEnvironment", true, false).environment
	await run_chapter()


func run_chapter() -> void:
	pass


func run_beats(beats: Array) -> void:
	for beat_script in beats:
		await beat_script.new().run(self)


func marker(marker_name: String) -> Vector3:
	return (find_child(marker_name, true, false) as Node3D).global_position


func trigger(trigger_name: String) -> Trigger:
	return find_child(trigger_name, true, false) as Trigger


func await_trigger(trigger_name: String) -> void:
	var area := trigger(trigger_name)
	if not area.triggered:
		await area.entered


func objective(text_key: String, path: Array = []) -> void:
	GameUI.set_objective(text_key)
	if is_instance_valid(trail):
		trail.queue_free()
	if not path.is_empty():
		trail = Effects.blood_trail(self, path.map(func(marker_name): return marker(marker_name)))


func interactable(marker_name: String, label: String) -> Interactable:
	var area: Interactable = INTERACTABLE.new()
	area.label = label
	find_child(marker_name, true, false).add_child(area)
	return area


func add_talk(npc: Node3D, lines: Array) -> void:
	var area: Interactable = INTERACTABLE.new()
	area.label = "UI_TALK"
	area.radius = 2.2
	area.once = false
	npc.add_child(area)
	area.used.connect(func(): Dialogue.say(lines))


func spawn_npc(marker_name: String, shirt: Color, hat: String, carries_rifle := true) -> Node3D:
	var npc := NPC.new()
	npc.shirt_color = shirt
	npc.hat = hat
	npc.carries_rifle = carries_rifle
	add_child(npc)
	npc.global_position = marker(marker_name)
	return npc


func spawn_soldier(marker_name: String, accuracy: float, speed: float) -> CharacterBody3D:
	var soldier: CharacterBody3D = SOLDIER.instantiate()
	soldier.accuracy = accuracy
	soldier.move_speed = speed
	add_child(soldier)
	soldier.global_position = marker(marker_name)
	soldiers.append(soldier)
	return soldier


func alive_soldiers() -> int:
	return soldiers.filter(func(s): return is_instance_valid(s) and s.is_alive).size()


func clear_soldiers() -> void:
	for soldier in soldiers:
		if is_instance_valid(soldier):
			soldier.queue_free()
	soldiers.clear()


func attach_hit_target(npc: Node3D) -> HitTarget:
	var target: HitTarget = HIT_TARGET.new()
	npc.add_child(target)
	return target


func teleport_player(marker_name: String, yaw_degrees: float) -> void:
	var player := Global.player
	player.global_position = marker(marker_name) + Vector3.UP * 0.3
	player.velocity = Vector3.ZERO
	player.camera_pivot.rotation.y = deg_to_rad(yaw_degrees)
	player.camera_holder.rotation.x = 0.0


func face_player_to(marker_name: String) -> void:
	var direction := marker(marker_name) - Global.player.global_position
	Global.player.camera_pivot.rotation.y = atan2(-direction.x, -direction.z)


func lock_player(locked: bool) -> void:
	Pact.active = not locked
	Global.player.set_physics_process(not locked)
	Global.player.set_process_unhandled_input(not locked)


func set_hud_visible(visible_now: bool) -> void:
	var hud := find_child("HUD", true, false)
	if hud:
		hud.visible = visible_now


func start_god_mode() -> Timer:
	var timer := Timer.new()
	timer.wait_time = 0.1
	timer.timeout.connect(func():
		if is_instance_valid(Global.player):
			Global.player.current_health = Global.player.MAX_HEALTH)
	add_child(timer)
	timer.start()
	return timer


func rockfall(marker_name: String, count: int) -> void:
	Effects.rockfall(self, marker(marker_name), count)
	Scares.shake(0.15, 1.0)


func wait_until(condition: Callable, timeout: float) -> void:
	var elapsed := 0.0
	while not condition.call() and elapsed < timeout:
		await get_tree().process_frame
		elapsed += get_process_delta_time()
