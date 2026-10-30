extends Node3D

const MODEL := preload("res://resources/characters/ual/UAL1_Standard.glb")
const LOOPS := ["Idle", "Walk", "Jog_Fwd", "Sitting_Idle", "Pistol_Idle", "Idle_Torch", "Idle_Talking", "Crouch_Idle"]

@export var shirt_color := Color(0.45, 0.33, 0.2)
@export var pants_color := Color(0.2, 0.16, 0.12)
@export_enum("half_moon", "kepi", "beret", "none") var hat := "half_moon"
@export var carries_torch := false
@export var carries_rifle := true
@export var character: PackedScene

var model: Node3D
var anim: AnimationPlayer
var skeleton: Skeleton3D
var torch_light: OmniLight3D


func _ready() -> void:
	model = (character if character else MODEL).instantiate()
	add_child(model)
	anim = model.find_children("*", "AnimationPlayer", true, false)[0]
	for name in LOOPS:
		if anim.has_animation(name):
			anim.get_animation(name).loop_mode = Animation.LOOP_LINEAR
	skeleton = model.find_children("*", "Skeleton3D", true, false)[0]
	if character:
		_dress_character()
	else:
		_dress_mannequin()
	if carries_torch:
		_torch(_attach("hand_l" if character else "DEF-hand.L"))
	pose("Idle")


func _dress_character() -> void:
	var rifle := skeleton.get_node_or_null("Rifle")
	if rifle:
		rifle.visible = carries_rifle


func _dress_mannequin() -> void:
	var mesh: MeshInstance3D = model.find_children("*", "MeshInstance3D", true, false)[0]
	for i in mesh.mesh.get_surface_count():
		var cloth := (mesh.get_active_material(i) as StandardMaterial3D).duplicate() as StandardMaterial3D
		cloth.albedo_color = shirt_color if i == 0 else pants_color
		cloth.roughness = 1.0
		mesh.set_surface_override_material(i, cloth)
	_hat()
	if carries_rifle:
		var rifle := BoxMesh.new()
		rifle.size = Vector3(0.05, 0.06, 0.95)
		var mi := _part(_attach("DEF-spine.003"), rifle, _dark(), Vector3(0.0, 0.0, -0.18))
		mi.rotation_degrees = Vector3(0, 0, 40)


func _torch(hand: BoneAttachment3D) -> void:
	var stick := CylinderMesh.new()
	stick.top_radius = 0.025
	stick.bottom_radius = 0.025
	stick.height = 0.8
	_part(hand, stick, _dark(), Vector3(0, 0.25, 0))
	torch_light = OmniLight3D.new()
	torch_light.light_color = Color(1.0, 0.6, 0.25)
	torch_light.light_energy = 2.4
	torch_light.omni_range = 5.0
	torch_light.position = Vector3(0, 0.7, 0)
	torch_light.set_script(load("res://game/world/components/flicker.gd"))
	hand.add_child(torch_light)


func pose(name: String, blend := 0.3) -> void:
	if anim.has_animation(name):
		anim.play(name, blend)


func lie_down() -> void:
	anim.play("Death01")
	anim.seek(anim.current_animation_length - 0.01, true)
	anim.pause()


func die() -> void:
	anim.play("Death01", 0.15)


func look_at_point(target: Vector3, seconds := 0.4) -> void:
	var dir := target - global_position
	dir.y = 0
	if dir.length_squared() < 0.001:
		return
	var yaw := atan2(dir.x, dir.z)
	var t := create_tween()
	t.tween_property(model, "rotation:y", yaw, seconds)
	await t.finished


func walk_to(target: Vector3, speed := 1.6, run := false) -> void:
	await look_at_point(target, 0.25)
	pose("Jog_Fwd" if run else "Walk", 0.2)
	var seconds := global_position.distance_to(target) / (speed * (2.0 if run else 1.0))
	var t := create_tween()
	t.tween_property(self, "global_position", target, seconds)
	await t.finished
	pose("Idle_Torch" if carries_torch else "Idle", 0.25)


func walk_path(points: Array, speed := 1.6, run := false) -> void:
	for point in points:
		await walk_to(point, speed, run)


func _hat() -> void:
	if hat == "none":
		return
	var head := _attach("DEF-head")
	var leather := StandardMaterial3D.new()
	leather.albedo_color = Color(0.36, 0.22, 0.12)
	match hat:
		"half_moon":
			var brim := CylinderMesh.new()
			brim.top_radius = 0.14
			brim.bottom_radius = 0.3
			brim.height = 0.12
			var mi := _part(head, brim, leather, Vector3(0, 0.2, 0))
			mi.scale = Vector3(1.0, 1.0, 0.55)
			var gold := StandardMaterial3D.new()
			gold.albedo_color = Color(0.8, 0.62, 0.3)
			gold.metallic = 0.6
			for x in [-0.12, 0.0, 0.12]:
				var medal := CylinderMesh.new()
				medal.top_radius = 0.035
				medal.bottom_radius = 0.035
				medal.height = 0.01
				var m := _part(head, medal, gold, Vector3(x, 0.24, 0.12))
				m.rotation_degrees = Vector3(80, 0, 0)
		"kepi":
			var cap := CylinderMesh.new()
			cap.top_radius = 0.12
			cap.bottom_radius = 0.12
			cap.height = 0.1
			_part(head, cap, _dark(), Vector3(0, 0.18, 0))
			var visor := BoxMesh.new()
			visor.size = Vector3(0.2, 0.015, 0.1)
			_part(head, visor, _dark(), Vector3(0, 0.14, 0.11))
		"beret":
			var beret := SphereMesh.new()
			beret.radius = 0.14
			beret.height = 0.12
			_part(head, beret, leather, Vector3(0, 0.18, 0))


func _attach(bone: String) -> BoneAttachment3D:
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


func _dark() -> StandardMaterial3D:
	var m := StandardMaterial3D.new()
	m.albedo_color = Color(0.1, 0.08, 0.06)
	return m
