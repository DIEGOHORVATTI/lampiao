class_name ThirdPersonView
extends Node

const BODY := preload("res://resources/characters/lampiao/lampiao.tscn")
const OFFSET := Vector3(0.45, 0.25, 2.6)
const WALL_MARGIN := 0.25
const RUN_SPEED := 6.0
const LOOPS := ["Idle", "Walk", "Jog_Fwd"]

var player: CharacterBody3D
var body: Node3D
var anim: AnimationPlayer
var active := false


func _ready() -> void:
	player = get_parent()
	body = BODY.instantiate()
	player.add_child.call_deferred(body)
	anim = body.find_children("*", "AnimationPlayer", true, false)[0]
	for name in LOOPS:
		anim.get_animation(name).loop_mode = Animation.LOOP_LINEAR
	if not InputMap.has_action("toggle_view"):
		InputMap.add_action("toggle_view")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_V
		InputMap.action_add_event("toggle_view", key)
	Settings.changed.connect(func(): _set_active(Settings.get_value("third_person")))
	_set_active.call_deferred(Settings.get_value("third_person"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_view"):
		Settings.set_value("third_person", not active)


func _set_active(on: bool) -> void:
	active = on
	body.visible = on
	player.get_node("WeaponSubViewport").visible = not on
	if not on:
		player.camera.position = Vector3.ZERO


func _physics_process(_delta: float) -> void:
	if not active:
		return
	player.get_node("WeaponSubViewport").visible = false
	body.rotation.y = player.camera_pivot.rotation.y + PI
	_place_camera()
	_animate()


func _place_camera() -> void:
	var holder: Node3D = player.camera_holder
	var desired: Vector3 = holder.global_transform * OFFSET
	var query := PhysicsRayQueryParameters3D.create(holder.global_position, desired, 1, [player.get_rid()])
	var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
	var target: Vector3 = desired if hit.is_empty() else hit.position + hit.normal * WALL_MARGIN
	player.camera.global_position = target


func _animate() -> void:
	var speed := Vector2(player.velocity.x, player.velocity.z).length()
	var clip := "Idle" if speed < 0.3 else ("Jog_Fwd" if speed > RUN_SPEED else "Walk")
	if anim.current_animation != clip:
		anim.play(clip, 0.2)
