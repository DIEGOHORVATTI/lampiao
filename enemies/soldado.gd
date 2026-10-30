extends CharacterBody3D

const MODEL := preload("res://resources/personagens/ual/UAL1_Standard.glb")
const SHOT := preload("res://resources/sfx/weapons/pistol.wav")
const GRAVITY := -20.0
const LOOPS := ["Idle", "Walk", "Jog_Fwd", "Sitting_Idle", "Pistol_Idle", "Pistol_Aim_Neutral", "Idle_Torch"]

@export var max_health := 60.0
@export var vision_range := 20.0
@export var shoot_range := 16.0
@export var hearing_range := 30.0
@export var flash_sight_range := 30.0
@export var alert_range := 15.0
@export var move_speed := 2.4
@export var damage := 9.0
@export var accuracy := 0.55
@export var fire_interval := 1.5
@export var chase_time := 10.0
@export var uniform := Color(0.6, 0.53, 0.38)
@export var sentado := false
@export var edible_seconds := 30.0

var health := 60.0
var is_alive := true
var player: Node3D
var character_root: Node3D
var anim: AnimationPlayer
var nav_agent: NavigationAgent3D
var alerted_until := 0.0
var next_shot := 0.0
var current_anim := ""
var muzzle: OmniLight3D


func _ready() -> void:
	health = max_health
	collision_layer = 3
	collision_mask = 1
	add_to_group("inimigos")
	var shape := CollisionShape3D.new()
	var capsule := CapsuleShape3D.new()
	capsule.radius = 0.35
	capsule.height = 1.8
	shape.shape = capsule
	shape.position.y = 0.9
	add_child(shape)
	nav_agent = NavigationAgent3D.new()
	nav_agent.path_desired_distance = 0.8
	nav_agent.target_desired_distance = 1.0
	add_child(nav_agent)
	_build_model()
	player = Global.player
	Global.fire_input.connect(func(): _hear(hearing_range))
	Global.muzzle_flash.connect(func(): _hear(flash_sight_range))
	_play("Sitting_Idle" if sentado else "Idle")


func _build_model() -> void:
	character_root = MODEL.instantiate()
	add_child(character_root)
	anim = character_root.find_children("*", "AnimationPlayer", true, false)[0]
	for name in LOOPS:
		if anim.has_animation(name):
			anim.get_animation(name).loop_mode = Animation.LOOP_LINEAR
	var mesh: MeshInstance3D = character_root.find_children("*", "MeshInstance3D", true, false)[0]
	for i in mesh.mesh.get_surface_count():
		var cloth := (mesh.get_active_material(i) as StandardMaterial3D).duplicate() as StandardMaterial3D
		cloth.albedo_color = uniform if i == 0 else uniform.darkened(0.45)
		cloth.roughness = 1.0
		mesh.set_surface_override_material(i, cloth)
	var skeleton: Skeleton3D = character_root.find_children("*", "Skeleton3D", true, false)[0]
	var dark := StandardMaterial3D.new()
	dark.albedo_color = Color(0.12, 0.1, 0.08)
	var head := _attach(skeleton, "DEF-head")
	var cap := CylinderMesh.new()
	cap.top_radius = 0.11
	cap.bottom_radius = 0.12
	cap.height = 0.09
	_part(head, cap, dark, Vector3(0, 0.17, 0))
	var visor := BoxMesh.new()
	visor.size = Vector3(0.2, 0.015, 0.1)
	_part(head, visor, dark, Vector3(0, 0.13, 0.1))
	var hand := _attach(skeleton, "DEF-hand.R")
	var rifle := BoxMesh.new()
	rifle.size = Vector3(0.05, 0.06, 0.95)
	_part(hand, rifle, dark, Vector3(0, 0.25, 0.05)).rotation_degrees = Vector3(90, 0, 0)
	muzzle = OmniLight3D.new()
	muzzle.light_color = Color(1.0, 0.75, 0.4)
	muzzle.light_energy = 0.0
	muzzle.omni_range = 16.0
	muzzle.position = Vector3(0, 0.75, 0.05)
	hand.add_child(muzzle)


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if not is_alive:
		move_and_slide()
		return
	player = Global.player
	if player == null or not player.is_alive:
		velocity.x = 0
		velocity.z = 0
		move_and_slide()
		return
	var now := Time.get_ticks_msec() / 1000.0
	var distance := global_position.distance_to(player.global_position)
	var sees := distance < vision_range and _line_of_sight()
	if sees:
		alert(global_position, alert_range)
	if now > alerted_until:
		velocity.x = 0
		velocity.z = 0
		_play("Sitting_Idle" if sentado else "Idle")
	elif sees and distance < shoot_range:
		sentado = false
		velocity.x = 0
		velocity.z = 0
		_face(player.global_position, delta)
		_play("Pistol_Aim_Neutral")
		if now >= next_shot:
			next_shot = now + fire_interval * randf_range(0.8, 1.3)
			_shoot(distance)
	else:
		sentado = false
		nav_agent.target_position = player.global_position
		var next := nav_agent.get_next_path_position()
		var direction := (next - global_position)
		direction.y = 0
		direction = direction.normalized()
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
		_face(next, delta)
		_play("Jog_Fwd")
	move_and_slide()


func _hear(radius: float) -> void:
	if player and is_alive and global_position.distance_to(player.global_position) < radius:
		alert(global_position, 1.0)


func alert(from: Vector3, radius: float) -> void:
	if not is_alive or global_position.distance_to(from) > radius:
		return
	var was_calm := Time.get_ticks_msec() / 1000.0 > alerted_until
	alerted_until = Time.get_ticks_msec() / 1000.0 + chase_time
	if was_calm and radius > 1.0:
		get_tree().call_group("inimigos", "alert", global_position, alert_range * 0.5)


func get_damage(amount: float, _direction: Vector3) -> void:
	if not is_alive:
		return
	health -= amount
	alert(global_position, 1.0)
	if health <= 0.0:
		die()
	else:
		anim.play("Hit_Chest")
		current_anim = "Hit_Chest"


func die() -> void:
	is_alive = false
	remove_from_group("inimigos")
	collision_layer = 0
	velocity = Vector3.ZERO
	Global.enemy_killed.emit()
	anim.play("Death01")
	current_anim = "Death01"
	_blood_pool()
	if edible_seconds > 0.0:
		var carcass := Area3D.new()
		carcass.set_script(preload("res://world/interagivel.gd"))
		carcass.texto = "Deixar Ela comer"
		carcass.raio = 1.9
		carcass.usado.connect(_eaten)
		add_child(carcass)


func _eaten() -> void:
	Pacto.comer()
	Pacto.hit_flash = 1.0
	Sustos.shake(0.12, 0.8)
	var t := create_tween()
	t.tween_property(character_root, "scale", Vector3(1.0, 0.05, 1.0), 0.9).set_trans(Tween.TRANS_EXPO)
	t.tween_callback(character_root.hide)


func _shoot(distance: float) -> void:
	muzzle.light_energy = 7.0
	create_tween().tween_property(muzzle, "light_energy", 0.0, 0.15)
	var p := AudioStreamPlayer3D.new()
	p.stream = SHOT
	p.volume_db = 2.0
	add_child(p)
	p.global_position = muzzle.global_position
	p.play()
	p.finished.connect(p.queue_free)
	anim.stop()
	anim.play("Pistol_Shoot")
	current_anim = "Pistol_Shoot"
	var hit_chance := clampf(accuracy * (10.0 / maxf(distance, 4.0)), 0.08, 0.85)
	if player.get("is_moving") == true:
		hit_chance *= 0.6
	if randf() < hit_chance:
		player.get_damage(damage, global_position.direction_to(player.global_position), true)


func _line_of_sight() -> bool:
	var from := global_position + Vector3.UP * 1.6
	var to: Vector3 = player.global_position + Vector3.UP * 1.4
	var query := PhysicsRayQueryParameters3D.create(from, to, 1, [get_rid()])
	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	return hit.is_empty() or hit.collider == player


func _face(target: Vector3, delta: float) -> void:
	var dir := target - global_position
	dir.y = 0
	if dir.length_squared() < 0.01:
		return
	var yaw := atan2(dir.x, dir.z)
	character_root.rotation.y = lerp_angle(character_root.rotation.y, yaw, minf(delta * 8.0, 1.0))


func _play(name: String) -> void:
	if current_anim == name:
		return
	if current_anim in ["Pistol_Shoot", "Hit_Chest"] and anim.is_playing():
		return
	current_anim = name
	anim.play(name, 0.25)


func _blood_pool() -> void:
	var pool := MeshInstance3D.new()
	var disc := CylinderMesh.new()
	disc.top_radius = 0.9
	disc.bottom_radius = 0.9
	disc.height = 0.01
	disc.radial_segments = 14
	pool.mesh = disc
	var mat := StandardMaterial3D.new()
	mat.albedo_color = Color(0.05, 0.0, 0.0)
	mat.roughness = 0.15
	pool.material_override = mat
	pool.position = Vector3(0, 0.02, -0.4)
	pool.scale = Vector3(0.1, 1, 0.1)
	add_child(pool)
	create_tween().tween_property(pool, "scale", Vector3(1.3, 1, 1.0), 2.5).set_trans(Tween.TRANS_SINE)


func _attach(skeleton: Skeleton3D, bone: String) -> BoneAttachment3D:
	var a := BoneAttachment3D.new()
	a.bone_name = bone
	skeleton.add_child(a)
	return a


func _part(parent: Node3D, mesh: Mesh, mat: Material, pos: Vector3) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = mat
	mi.position = pos
	parent.add_child(mi)
	return mi
