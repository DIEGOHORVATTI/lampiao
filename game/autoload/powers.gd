extends Node

const TENTACLE_RANGE := 5.0
const TENTACLE_HUNGER := 10.0
const TENTACLE_COOLDOWN := 1.5

var cooldown := 0.0
var rosary_active := false
var entity_mode := false
var root_material: StandardMaterial3D


func _ready() -> void:
	if not InputMap.has_action("tentacles"):
		InputMap.add_action("tentacles")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_Q
		InputMap.action_add_event("tentacles", key)
	if not InputMap.has_action("rosary"):
		InputMap.add_action("rosary")
		var key_t := InputEventKey.new()
		key_t.physical_keycode = KEY_T
		InputMap.action_add_event("rosary", key_t)
	root_material = StandardMaterial3D.new()
	root_material.albedo_color = Color(0.02, 0.02, 0.02)
	root_material.roughness = 0.6


func _process(delta: float) -> void:
	cooldown = maxf(0.0, cooldown - delta)
	rosary_active = Input.is_action_pressed("rosary") and Pact.active
	if Input.is_action_just_pressed("tentacles") and cooldown == 0.0 and (Pact.active or entity_mode) and not rosary_active:
		tentacles()


func tentacles() -> bool:
	var player: Node3D = Global.player
	var target := _target(player)
	cooldown = 0.6 if entity_mode else TENTACLE_COOLDOWN
	if not entity_mode:
		Pact.hunger = minf(99.0, Pact.hunger + TENTACLE_HUNGER)
	var hand: Vector3 = player.camera.global_position + player.camera.global_basis * Vector3(0.3, -0.4, -0.3)
	var end: Vector3 = target.global_position + Vector3.UP * 1.0 if target else hand + -player.camera.global_basis.z * TENTACLE_RANGE
	for i in 3:
		_tentacle(hand, end + Vector3(randf_range(-0.3, 0.3), randf_range(-0.3, 0.3), randf_range(-0.3, 0.3)))
	if target:
		target.get_damage(10000.0, Vector3.ZERO)
	return target != null


func _target(player: Node3D) -> Node3D:
	var forward: Vector3 = -player.camera.global_basis.z
	var best: Node3D = null
	var best_distance := 6.0 if entity_mode else TENTACLE_RANGE
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if not enemy.is_alive:
			continue
		var to: Vector3 = enemy.global_position - player.global_position
		var distance := to.length()
		if distance < best_distance and forward.dot(to.normalized()) > 0.5:
			best = enemy
			best_distance = distance
	return best


func _tentacle(from: Vector3, to: Vector3) -> void:
	var mesh := CylinderMesh.new()
	mesh.top_radius = 0.02
	mesh.bottom_radius = 0.045
	mesh.height = 1.0
	mesh.radial_segments = 5
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = root_material
	get_tree().current_scene.add_child(mi)
	var length := from.distance_to(to)
	mi.global_position = from
	mi.look_at(to, Vector3.UP if absf((to - from).normalized().y) < 0.99 else Vector3.RIGHT)
	mi.rotate_object_local(Vector3.RIGHT, -PI / 2)
	mi.scale = Vector3(1, 0.01, 1)
	var tween := mi.create_tween()
	tween.tween_property(mi, "scale", Vector3(1, length, 1), 0.12)
	tween.parallel().tween_property(mi, "global_position", from + (to - from) / 2.0, 0.12)
	tween.tween_interval(0.25)
	tween.tween_property(mi, "scale", Vector3(0.2, 0.01, 0.2), 0.15)
	tween.tween_callback(mi.queue_free)
