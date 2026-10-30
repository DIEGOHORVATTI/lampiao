extends RefCounted

const MeshKit := preload("res://resources/weapons/mesh_kit.gd")

const WALNUT := Color(0.46, 0.27, 0.15)
const BLUED := Color(0.2, 0.21, 0.25)
const SOOT := Color(0.12, 0.12, 0.13)
const CAGE := Color(0.62, 0.61, 0.6)
const BORE := 0.15
const MUZZLE_Z := -0.86
const JACKET_END := -0.68
const ROD_END := -0.93
const FLUTES := 10


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
	kit.block(-0.3, -0.36, Rect2(-0.024, 0.098, 0.048, 0.054), Rect2(-0.02, 0.115, 0.04, 0.035))
	kit.block(0.0, -0.3, Rect2(-0.024, 0.09, 0.048, 0.05), Rect2(-0.024, 0.098, 0.048, 0.054))
	kit.block(0.12, 0.0, Rect2(-0.018, 0.074, 0.036, 0.056), Rect2(-0.024, 0.09, 0.048, 0.05))
	kit.block(0.33, 0.12, Rect2(-0.024, -0.01, 0.048, 0.135), Rect2(-0.018, 0.074, 0.036, 0.056))
	return kit


static func _metal(kit: MeshKit) -> MeshKit:
	kit.tube(Vector2(0.0, BORE), Vector2(0.02, 0.02), -0.3, 0.0, 12)
	_jacket(kit)
	_muzzle_cage(kit)
	_cleaning_rod(kit)
	_sights(kit)
	_trigger(kit)
	kit.block(0.338, 0.33, Rect2(-0.025, -0.012, 0.05, 0.139), Rect2(-0.025, -0.012, 0.05, 0.139))
	return kit


static func _jacket(kit: MeshKit) -> void:
	kit.tube(Vector2(0.0, BORE), Vector2(0.034, 0.034), -0.31, -0.29, 16)
	var sections: Array[PackedVector3Array] = []
	for z in [-0.3, -0.5, JACKET_END]:
		sections.append(_fluted_ring(lerpf(0.033, 0.031, z / JACKET_END), z))
	kit.loft(sections)
	kit.tube(Vector2(0.0, BORE), Vector2(0.036, 0.036), JACKET_END - 0.03, JACKET_END, 16)


static func _fluted_ring(radius: float, z: float) -> PackedVector3Array:
	var ring := PackedVector3Array()
	for i in FLUTES * 2:
		var angle := TAU * i / (FLUTES * 2)
		var r := radius if i % 2 == 0 else radius * 0.86
		ring.append(Vector3(cos(angle) * r, BORE + sin(angle) * r, z))
	return ring


static func _muzzle_cage(kit: MeshKit) -> void:
	var rear := JACKET_END - 0.03
	kit.color = CAGE
	kit.tube(Vector2(0.0, BORE), Vector2(0.047, 0.047), rear - 0.018, rear, 16)
	kit.tube(Vector2(0.0, BORE), Vector2(0.047, 0.047), MUZZLE_Z + 0.012, MUZZLE_Z + 0.03, 16)
	for i in 8:
		var angle := TAU * (i + 0.5) / 8.0
		kit.box(Vector3(cos(angle) * 0.043, BORE + sin(angle) * 0.043, (rear - 0.018 + MUZZLE_Z + 0.03) * 0.5), Vector3(0.011, 0.011, rear - 0.018 - MUZZLE_Z - 0.03))
	kit.color = SOOT
	kit.tube(Vector2(0.0, BORE), Vector2(0.028, 0.028), MUZZLE_Z + 0.012, rear - 0.018, 12)
	kit.tube(Vector2(0.0, BORE), Vector2(0.02, 0.02), MUZZLE_Z, MUZZLE_Z + 0.012, 12)
	kit.color = BLUED


static func _cleaning_rod(kit: MeshKit) -> void:
	var y := BORE - 0.05
	kit.tube(Vector2(0.0, y), Vector2(0.0045, 0.0045), ROD_END, JACKET_END + 0.09, 8)
	kit.tube(Vector2(0.0, y), Vector2(0.0065, 0.0065), ROD_END, ROD_END + 0.012, 8)
	for z in [JACKET_END + 0.01, JACKET_END + 0.08]:
		kit.box(Vector3(0.0, y + 0.012, z), Vector3(0.012, 0.024, 0.014))


static func _sights(kit: MeshKit) -> void:
	kit.box(Vector3(0.0, BORE + 0.02, -0.29), Vector3(0.022, 0.012, 0.06))
	kit.box(Vector3(0.0, BORE + 0.029, -0.275), Vector3(0.016, 0.006, 0.012))
	kit.box(Vector3(0.0, BORE + 0.04, JACKET_END - 0.015), Vector3(0.012, 0.012, 0.02))
	kit.box(Vector3(0.0, BORE + 0.05, JACKET_END - 0.015), Vector3(0.0025, 0.014, 0.008))


static func _trigger(kit: MeshKit) -> void:
	kit.box(Vector3(0.0, 0.088, -0.1), Vector3(0.03, 0.006, 0.09))
	kit.box(Vector3(0.0, 0.058, -0.02), Vector3(0.012, 0.005, 0.07))
	kit.box(Vector3(0.0, 0.073, -0.055), Vector3(0.012, 0.03, 0.005))
	kit.box(Vector3(0.0, 0.073, 0.015), Vector3(0.012, 0.03, 0.005))
	kit.box(Vector3(0.0, 0.075, -0.025), Vector3(0.004, 0.025, 0.006))
