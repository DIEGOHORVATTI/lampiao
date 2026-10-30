extends RefCounted

const MeshKit := preload("res://resources/weapons/mesh_kit.gd")

const BLADE := Color(0.78, 0.79, 0.8)
const BRASS := Color(0.62, 0.46, 0.22)
const HANDLE := Color(0.33, 0.19, 0.1)
const HANDLE_LENGTH := 0.105
const BLADE_LENGTH := 0.29
const BLADE_WIDTH := 0.027
const SPINE := 0.0019


static func body(wood: Material, steel: Material) -> ArrayMesh:
	var mesh := ArrayMesh.new()
	_handle(_kit(HANDLE)).commit_into(mesh, wood)
	_metal(_kit(BLADE)).commit_into(mesh, steel)
	return mesh


static func _kit(color: Color) -> MeshKit:
	var kit := MeshKit.new()
	kit.color = color
	return kit


static func _handle(kit: MeshKit) -> MeshKit:
	kit.xform = _along_y()
	kit.tube(Vector2(0.0, 0.004), Vector2(0.0105, 0.0155), -HANDLE_LENGTH, -0.004, 8)
	return kit


static func _metal(kit: MeshKit) -> MeshKit:
	kit.color = BRASS
	kit.xform = _along_y()
	kit.tube(Vector2(0.0, 0.004), Vector2(0.012, 0.017), -0.004, 0.01, 8)
	kit.tube(Vector2(0.0, 0.004), Vector2(0.0115, 0.0165), -HANDLE_LENGTH - 0.008, -HANDLE_LENGTH, 8)
	kit.color = BLADE
	kit.xform = Transform3D.IDENTITY
	kit.loft(_blade_sections())
	return kit


static func _along_y() -> Transform3D:
	return Transform3D(Basis(Vector3.RIGHT, -PI * 0.5), Vector3.ZERO)


static func _blade_sections() -> Array[PackedVector3Array]:
	var sections: Array[PackedVector3Array] = []
	for t in [0.0, 0.15, 0.3, 0.45, 0.6, 0.72, 0.82, 0.9, 0.96, 1.0]:
		sections.append(_blade_section(t))
	return sections


static func _blade_section(t: float) -> PackedVector3Array:
	var y := 0.01 + t * BLADE_LENGTH
	var bow := 0.012 * t * t
	var spine_z := -0.008 + bow
	var width := BLADE_WIDTH * (1.0 - pow(t, 2.6)) + 0.0006
	var half := SPINE * (1.0 - t * 0.7)
	return PackedVector3Array([Vector3(-half, y, spine_z), Vector3(half, y, spine_z), Vector3(0.0, y, spine_z + width)])
