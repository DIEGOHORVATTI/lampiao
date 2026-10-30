extends RefCounted

const MeshKit := preload("res://resources/weapons/mesh_kit.gd")

const BLUED := Color(0.17, 0.18, 0.21)
const GRIP := Color(0.36, 0.2, 0.11)
const BORE := 0.06
const AXIS := 0.046
const MUZZLE_Z := -0.2


static func body(wood: Material, steel: Material) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	_grip(_kit(GRIP)).commit_into(mesh, wood)
	_frame(_kit(BLUED)).commit_into(mesh, steel)
	return mesh


static func cylinder(steel: Material) -> ArrayMesh:
	var kit := _kit(BLUED)
	kit.tube(Vector2.ZERO, Vector2(0.019, 0.019), -0.025, 0.025, 12)
	kit.color = Color(0.05, 0.05, 0.05)
	for i in 6:
		var angle := TAU * i / 6.0 + PI * 0.5
		kit.tube(Vector2(cos(angle), sin(angle)) * 0.0125, Vector2(0.0042, 0.0042), -0.026, -0.024, 6)
	var mesh := ArrayMesh.new()
	kit.commit_into(mesh, steel)
	return mesh


static func _kit(color: Color) -> MeshKit:
	var kit := MeshKit.new()
	kit.color = color
	return kit


static func _grip(kit: MeshKit) -> MeshKit:
	var top := 0.03
	var bottom := -0.066
	var corners := PackedVector3Array()
	for i in 8:
		var low := not (i & 2)
		var x := 0.0135 * (1.0 if i & 1 else -1.0)
		var z := (0.04 if low else 0.005) + (0.038 if i & 4 else 0.0)
		corners.append(Vector3(x, bottom if low else top, z))
	kit.hexahedron(corners)
	return kit


static func _frame(kit: MeshKit) -> MeshKit:
	kit.tube(Vector2(0.0, BORE), Vector2(0.0075, 0.0075), MUZZLE_Z, -0.055, 10)
	kit.tube(Vector2(0.0, BORE - 0.014), Vector2(0.0045, 0.0045), -0.13, -0.055, 6)
	kit.box(Vector3(0.0, BORE + 0.01, MUZZLE_Z + 0.008), Vector3(0.003, 0.008, 0.012))
	kit.box(Vector3(0.0, 0.071, -0.03), Vector3(0.016, 0.006, 0.06))
	kit.box(Vector3(0.0, 0.026, -0.015), Vector3(0.02, 0.012, 0.1))
	kit.box(Vector3(0.0, 0.048, -0.058), Vector3(0.018, 0.04, 0.008))
	kit.box(Vector3(0.0, 0.05, 0.016), Vector3(0.022, 0.05, 0.03))
	kit.tube(Vector2(0.0, AXIS), Vector2(0.003, 0.003), -0.062, 0.0, 6)
	_hammer(kit)
	_trigger(kit)
	kit.box(Vector3(0.0, -0.068, 0.059), Vector3(0.029, 0.005, 0.04))
	return kit


static func _hammer(kit: MeshKit) -> void:
	kit.block(0.03, 0.044, Rect2(-0.004, 0.06, 0.008, 0.016), Rect2(-0.004, 0.066, 0.008, 0.022))
	kit.box(Vector3(0.0, 0.088, 0.05), Vector3(0.01, 0.005, 0.014))


static func _trigger(kit: MeshKit) -> void:
	kit.box(Vector3(0.0, 0.004, -0.004), Vector3(0.006, 0.004, 0.05))
	kit.box(Vector3(0.0, 0.012, -0.027), Vector3(0.006, 0.016, 0.004))
	kit.box(Vector3(0.0, 0.01, -0.004), Vector3(0.004, 0.02, 0.005))
