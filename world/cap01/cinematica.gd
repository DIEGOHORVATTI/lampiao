extends Node3D

const SMG := preload("res://resources/sfx/weapons/smg.wav")
const PISTOL := preload("res://resources/sfx/weapons/pistol.wav")
const ENGINE := preload("res://resources/sfx/engine.wav")
const FOOTSTEP := preload("res://player/sfx/footstep_ground.ogg")
const UNDEAD := preload("res://enemies/undead.tscn")
const SILHOUETTE := Color(0.03, 0.03, 0.035)
const DAWN_SKY := Color(0.2, 0.21, 0.24)
const LYING_ROLL := 25.0

var player: Node3D
var env: Environment
var saved_env := {}
var rain: CPUParticles3D


func setup(level: Node3D) -> void:
	player = Global.player
	env = level.find_child("WorldEnvironment", true, false).environment
	for key in ["background_color", "ambient_light_energy", "ambient_light_color", "fog_light_color", "fog_density"]:
		saved_env[key] = env.get(key)


func begin(at: Vector3, yaw_deg: float, lying := true) -> void:
	player.global_position = at
	player.camera_pivot.rotation.y = deg_to_rad(yaw_deg)
	player.camera_pivot.position.y = 0.25 if lying else 1.7
	player.camera_holder.rotation.x = 0.0
	player.camera.rotation.z = deg_to_rad(LYING_ROLL) if lying else 0.0
	player.get_node("WeaponSubViewport").visible = false
	_hud(false)


func end() -> void:
	player.camera_pivot.position.y = 1.7
	player.camera.rotation.z = 0.0
	player.camera_holder.rotation.x = 0.0
	player.get_node("WeaponSubViewport").visible = true
	_hud(true)
	for key in saved_env:
		env.set(key, saved_env[key])
	Ambiente.rain_level = 0.0
	if rain:
		rain.queue_free()
		rain = null


func dawn_rain() -> void:
	env.background_color = DAWN_SKY
	env.ambient_light_energy = 0.55
	env.ambient_light_color = Color(0.5, 0.52, 0.6)
	env.fog_light_color = Color(0.22, 0.23, 0.27)
	env.fog_density = 0.03
	Ambiente.rain_level = 1.0
	rain = CPUParticles3D.new()
	rain.amount = 500
	rain.lifetime = 0.9
	rain.emission_shape = CPUParticles3D.EMISSION_SHAPE_BOX
	rain.emission_box_extents = Vector3(12, 0.5, 12)
	rain.direction = Vector3(0.1, -1, 0)
	rain.spread = 3.0
	rain.initial_velocity_min = 18.0
	rain.initial_velocity_max = 22.0
	rain.gravity = Vector3.ZERO
	var drop := QuadMesh.new()
	drop.size = Vector2(0.015, 0.45)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.7, 0.75, 0.85, 0.35)
	mat.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_FIXED_Y
	drop.material = mat
	rain.mesh = drop
	add_child(rain)
	rain.global_position = player.global_position + Vector3.UP * 9.0


func soldier(at: Vector3, yaw := 0.0) -> Node3D:
	var root := Node3D.new()
	var mat := StandardMaterial3D.new()
	mat.albedo_color = SILHOUETTE
	mat.roughness = 1.0
	var body := CapsuleMesh.new()
	body.radius = 0.24
	body.height = 1.6
	_part(root, body, mat, Vector3(0, 0.8, 0))
	var head := SphereMesh.new()
	head.radius = 0.13
	head.height = 0.26
	_part(root, head, mat, Vector3(0, 1.72, 0))
	var hat := CylinderMesh.new()
	hat.top_radius = 0.16
	hat.bottom_radius = 0.3
	hat.height = 0.08
	_part(root, hat, mat, Vector3(0, 1.84, 0))
	var rifle := BoxMesh.new()
	rifle.size = Vector3(0.05, 0.05, 1.1)
	_part(root, rifle, mat, Vector3(0.22, 1.25, -0.35))
	add_child(root)
	root.global_position = at
	root.rotation.y = yaw
	return root


func undead_walker(at: Vector3) -> Node3D:
	var walker: CharacterBody3D = UNDEAD.instantiate()
	walker.show_health_bar = false
	add_child(walker)
	walker.global_position = at
	walker.remove_from_group("inimigos")
	walker.set_physics_process(false)
	walker.animation_tree.set("parameters/conditions/move", true)
	return walker


func burst(from: Vector3, shots: int, gap: float, stream: AudioStream = SMG) -> void:
	var flash := OmniLight3D.new()
	flash.light_color = Color(1.0, 0.75, 0.4)
	flash.omni_range = 14.0
	add_child(flash)
	flash.global_position = from
	for i in shots:
		sound(stream, from, 2.0)
		flash.light_energy = 6.0
		await get_tree().create_timer(0.05).timeout
		flash.light_energy = 0.0
		await get_tree().create_timer(gap).timeout
	flash.queue_free()


func sound(stream: AudioStream, at: Vector3, volume_db := 0.0) -> void:
	var p := AudioStreamPlayer3D.new()
	p.stream = stream
	p.volume_db = volume_db
	p.max_distance = 80.0
	add_child(p)
	p.global_position = at
	p.play()
	p.finished.connect(p.queue_free)


func footsteps(at: Vector3, count: int, gap: float) -> void:
	for i in count:
		sound(FOOTSTEP, at, -4.0)
		await get_tree().create_timer(gap).timeout


func knock(at: Vector3) -> void:
	sound(_knock_stream(), at, 6.0)


func fall_to_side(seconds: float) -> void:
	var t := create_tween().set_parallel()
	t.tween_property(player.camera_pivot, "position:y", 0.25, seconds)
	t.tween_property(player.camera, "rotation:z", deg_to_rad(LYING_ROLL), seconds)
	await t.finished


func look(pitch_deg: float, seconds: float) -> void:
	await create_tween().tween_property(player.camera_holder, "rotation:x", deg_to_rad(pitch_deg), seconds).finished


func lift_head(seconds: float) -> void:
	var t := create_tween().set_parallel()
	t.tween_property(player.camera_pivot, "position:y", 1.7, seconds).set_trans(Tween.TRANS_SINE)
	t.tween_property(player.camera, "rotation:z", 0.0, seconds).set_trans(Tween.TRANS_SINE)
	t.tween_property(player.camera_holder, "rotation:x", 0.0, seconds)
	await t.finished


func _hud(visible_now: bool) -> void:
	var hud := get_parent().find_child("HUD", true, false)
	if hud:
		hud.visible = visible_now


func _part(root: Node3D, mesh: Mesh, mat: Material, pos: Vector3) -> void:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	root.add_child(mi)


func _knock_stream() -> AudioStreamWAV:
	var rate := 22050
	var data := PackedByteArray()
	var length := int(rate * 0.12)
	data.resize(length * 2)
	for i in length:
		var t := float(i) / rate
		var decay := exp(-t * 45.0)
		var v := (sin(TAU * 170.0 * t) * 0.7 + randf_range(-0.3, 0.3)) * decay
		data.encode_s16(i * 2, int(clampf(v, -1.0, 1.0) * 30000.0))
	var wav := AudioStreamWAV.new()
	wav.format = AudioStreamWAV.FORMAT_16_BITS
	wav.mix_rate = rate
	wav.data = data
	return wav
