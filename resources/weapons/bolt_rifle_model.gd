extends RefCounted

const MeshKit := preload("res://resources/weapons/mesh_kit.gd")

const WALNUT := Color(0.46, 0.27, 0.15)
const BLUED := Color(0.2, 0.21, 0.25)
const SOOT := Color(0.12, 0.12, 0.13)
const BORE := 0.15
const MUZZLE_Z := -0.97


static func body(wood: Material, steel: Material) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	_stock(_kit(WALNUT)).commit_into(mesh, wood)
	_metal(_kit(BLUED)).commit_into(mesh, steel)
	return mesh


static func bolt(steel: Material) -> ArrayMesh:
	var kit := _kit(BLUED)
	kit.tube(Vector2(0.0, 0.006), Vector2(0.009, 0.009), -0.11, 0.05, 8)
	kit.xform = Transform3D(Basis(Vector3.BACK, deg_to_rad(-25.0)) * Basis(Vector3.UP, PI * 0.5), Vector3(0.0, 0.006, 0.03))
	kit.tube(Vector2.ZERO, Vector2(0.0045, 0.0045), 0.0, 0.06, 6)
	kit.tube(Vector2.ZERO, Vector2(0.008, 0.008), 0.055, 0.072, 8)
	var mesh := ArrayMesh.new()
	kit.commit_into(mesh, steel)
	return mesh


static func _kit(color: Color) -> MeshKit:
	var kit := MeshKit.new()
	kit.color = color
	return kit


static func _stock(kit: MeshKit) -> MeshKit:
	kit.block(-0.3, -0.8, Rect2(-0.023, 0.098, 0.046, 0.054), Rect2(-0.017, 0.11, 0.034, 0.043))
	kit.block(-0.3, -0.56, Rect2(-0.015, BORE, 0.03, 0.018), Rect2(-0.014, BORE, 0.028, 0.016))
	kit.block(0.0, -0.3, Rect2(-0.024, 0.09, 0.048, 0.05), Rect2(-0.023, 0.098, 0.046, 0.054))
	kit.block(0.12, 0.0, Rect2(-0.018, 0.074, 0.036, 0.056), Rect2(-0.024, 0.09, 0.048, 0.05))
	kit.block(0.33, 0.12, Rect2(-0.024, -0.01, 0.048, 0.135), Rect2(-0.018, 0.074, 0.036, 0.056))
	return kit


static func _metal(kit: MeshKit) -> MeshKit:
	kit.tube(Vector2(0.0, BORE), Vector2(0.017, 0.017), -0.3, 0.0, 10)
	kit.tube(Vector2(0.0, BORE), Vector2(0.012, 0.012), -0.9, -0.3, 10)
	kit.tube(Vector2(0.0, BORE - 0.027), Vector2(0.0035, 0.0035), MUZZLE_Z - 0.02, -0.5, 6)
	for z in [-0.48, -0.72]:
		kit.tube(Vector2(0.0, 0.133), Vector2(0.027, 0.04), z - 0.012, z, 10)
	_muzzle_brake(kit)
	_sights(kit)
	_trigger(kit)
	kit.block(0.338, 0.33, Rect2(-0.025, -0.012, 0.05, 0.139), Rect2(-0.025, -0.012, 0.05, 0.139))
	return kit


static func _muzzle_brake(kit: MeshKit) -> void:
	kit.tube(Vector2(0.0, BORE), Vector2(0.018, 0.018), -0.875, -0.86, 10)
	kit.tube(Vector2(0.0, BORE), Vector2(0.022, 0.022), -0.9, -0.885, 10)
	kit.color = SOOT
	kit.tube(Vector2(0.0, BORE), Vector2(0.016, 0.016), -0.955, -0.9, 10)
	kit.color = BLUED
	for i in 6:
		var angle := TAU * i / 6.0
		kit.box(Vector3(cos(angle) * 0.02, BORE + sin(angle) * 0.02, -0.9275), Vector3(0.007, 0.007, 0.055))
	kit.tube(Vector2(0.0, BORE), Vector2(0.022, 0.022), MUZZLE_Z, -0.955, 10)


static func _sights(kit: MeshKit) -> void:
	kit.box(Vector3(0.0, BORE + 0.02, -0.29), Vector3(0.022, 0.012, 0.06))
	kit.box(Vector3(0.0, BORE + 0.029, -0.275), Vector3(0.016, 0.006, 0.012))
	kit.box(Vector3(0.0, BORE + 0.02, -0.85), Vector3(0.012, 0.01, 0.016))
	kit.box(Vector3(0.0, BORE + 0.029, -0.85), Vector3(0.0025, 0.012, 0.008))


static func _trigger(kit: MeshKit) -> void:
	kit.box(Vector3(0.0, 0.088, -0.1), Vector3(0.03, 0.006, 0.09))
	kit.box(Vector3(0.0, 0.058, -0.02), Vector3(0.012, 0.005, 0.07))
	kit.box(Vector3(0.0, 0.073, -0.055), Vector3(0.012, 0.03, 0.005))
	kit.box(Vector3(0.0, 0.073, 0.015), Vector3(0.012, 0.03, 0.005))
	kit.box(Vector3(0.0, 0.075, -0.025), Vector3(0.004, 0.025, 0.006))
