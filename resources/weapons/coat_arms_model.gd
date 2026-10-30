extends RefCounted

const SkinKit := preload("res://resources/weapons/skin_kit.gd")

const SOURCE := "res://resources/player/fps_demo_arms.glb"
const SKIN := Color(0.43, 0.26, 0.16)
const COAT := Color(0.14, 0.12, 0.11)
const SHIRT := Color(0.74, 0.7, 0.6)
const FINGERS := {
	"index": Vector3(0.0094, 0.0084, 0.05),
	"middle": Vector3(0.0097, 0.0087, 0.056),
	"ring": Vector3(0.0091, 0.0082, 0.052),
	"pink": Vector3(0.0078, 0.007, 0.042),
	"thumb": Vector3(0.0125, 0.011, 0.036),
}
const SLEEVE := [
	[0.3, 0.078, 0.078, 1.0],
	[0.45, 0.075, 0.077, 1.0],
	[0.6, 0.072, 0.074, 1.0],
	[0.683, 0.074, 0.072, 0.5],
	[0.77, 0.067, 0.066, 0.0],
	[0.87, 0.062, 0.061, 0.45],
	[0.915, 0.064, 0.063, 0.85],
	[0.94, 0.067, 0.066, 0.9],
]
const CUFF := [[0.915, 0.061, 0.06, 0.9], [0.935, 0.047, 0.049, 0.95], [0.97, 0.043, 0.046, 1.0]]
const PALM := [
	[0.93, 0.026, 0.031, Vector2(0.004, 0.2), 0.95],
	[0.975, 0.025, 0.033, Vector2(0.004, 0.2), 1.0],
	[1.005, 0.022, 0.038, Vector2(0.0, 0.203), 1.0],
	[1.035, 0.021, 0.043, Vector2(-0.004, 0.206), 1.0],
	[1.065, 0.019, 0.046, Vector2(-0.008, 0.209), 1.0],
	[1.088, 0.017, 0.045, Vector2(-0.009, 0.211), 1.0],
	[1.1, 0.011, 0.038, Vector2(-0.009, 0.212), 1.0],
]


static func build(material: Material) -> ArrayMesh:
	var scene: Node = load(SOURCE).instantiate()
	var skeleton: Skeleton3D = scene.get_node("Armature/Skeleton3D")
	var kit := SkinKit.new()
	for side in ["R", "L"]:
		_arm(kit, skeleton, side)
	scene.free()
	return kit.commit(material)


static func _arm(kit: SkinKit, skeleton: Skeleton3D, side: String) -> void:
	var mirror := 1.0 if side == "R" else -1.0
	var bones := {}
	for name in ["upper_arm", "lower_arm", "hand", "thumb1"]:
		bones[name] = skeleton.find_bone(name + "." + side)
	var basis := skeleton.get_bone_global_rest(bones.lower_arm).basis
	kit.limb(_sleeve_stations(SLEEVE, mirror, basis, bones), 14, COAT, 0.05, true)
	kit.limb(_sleeve_stations(CUFF, mirror, basis, bones), 14, SHIRT)
	kit.limb(_palm_stations(mirror, basis, bones), 12, SKIN)
	kit.limb(_thenar_stations(skeleton, mirror, bones), 10, SKIN)
	for finger in FINGERS:
		kit.limb(_finger_stations(skeleton, finger, side, bones.hand), 8, SKIN)


static func _sleeve_stations(rows: Array, mirror: float, basis: Basis, bones: Dictionary) -> Array[Dictionary]:
	var stations: Array[Dictionary] = []
	for row in rows:
		var upper: float = row[3] if row[0] < 0.8 else 0.0
		var hand: float = row[3] if row[0] >= 0.8 else 0.0
		var influences := {bones.upper_arm: upper, bones.lower_arm: 1.0 - upper - hand, bones.hand: hand}
		stations.append(SkinKit.station(Vector3(row[0] * mirror, lerpf(0.033, 0.005, row[0] / 0.986), 0.2), basis, Vector2(row[1], row[2]), _nonzero(influences)))
	return stations


static func _palm_stations(mirror: float, basis: Basis, bones: Dictionary) -> Array[Dictionary]:
	var stations: Array[Dictionary] = []
	for row in PALM:
		var center := Vector3(row[0] * mirror, row[3].x, row[3].y)
		var influences := {bones.lower_arm: 1.0 - row[4], bones.hand: row[4]}
		stations.append(SkinKit.station(center, basis, Vector2(row[1], row[2]), _nonzero(influences)))
	return stations


static func _thenar_stations(skeleton: Skeleton3D, mirror: float, bones: Dictionary) -> Array[Dictionary]:
	var root := skeleton.get_bone_global_rest(bones.thumb1).origin
	var start := Vector3(0.99 * mirror, 0.014, 0.2)
	var frame := _along(root - start)
	return [
		SkinKit.station(start, frame, Vector2(0.017, 0.017), {bones.hand: 1.0}),
		SkinKit.station(start.lerp(root, 0.55), frame, Vector2(0.015, 0.017), {bones.hand: 0.8, bones.thumb1: 0.2}),
		SkinKit.station(root, frame, Vector2(0.012, 0.013), {bones.hand: 0.4, bones.thumb1: 0.6}),
		SkinKit.station(root + frame.y * 0.008, frame, Vector2(0.005, 0.006), {bones.thumb1: 1.0}),
	]


static func _along(direction: Vector3) -> Basis:
	var y := direction.normalized()
	var x := Vector3.BACK.cross(y).normalized()
	return Basis(x, y, x.cross(y))


static func _finger_stations(skeleton: Skeleton3D, finger: String, side: String, hand: int) -> Array[Dictionary]:
	var size: Vector3 = FINGERS[finger]
	var base := skeleton.find_bone(finger + "1." + side)
	var tip_bone := skeleton.find_bone(finger + "2." + side)
	var proximal := skeleton.get_bone_global_rest(base)
	var distal := skeleton.get_bone_global_rest(tip_bone)
	var width := Vector2(size.x, size.y)
	var along := distal.basis.y.normalized()
	var tip := distal.origin + along * size.z
	return [
		SkinKit.station(proximal.origin - proximal.basis.y.normalized() * 0.016, proximal.basis, width * 1.1, {hand: 1.0}),
		SkinKit.station(proximal.origin, proximal.basis, width * 1.08, {hand: 0.4, base: 0.6}),
		SkinKit.station(proximal.origin.lerp(distal.origin, 0.5), proximal.basis, width, {base: 1.0}),
		SkinKit.station(distal.origin, distal.basis, width * 1.04, {base: 0.5, tip_bone: 0.5}),
		SkinKit.station(distal.origin.lerp(tip, 0.45), distal.basis, width * 0.92, {tip_bone: 1.0}),
		SkinKit.station(tip - along * 0.009, distal.basis, width * 0.86, {tip_bone: 1.0}),
		SkinKit.station(tip - along * 0.003, distal.basis, width * 0.7, {tip_bone: 1.0}),
		SkinKit.station(tip, distal.basis, width * 0.3, {tip_bone: 1.0}),
	]


static func _nonzero(influences: Dictionary) -> Dictionary:
	var result := {}
	for bone in influences:
		if influences[bone] > 0.0:
			result[bone] = influences[bone]
	return result
