const P := preload("res://game/world/props/prop_library.gd")
const MANOR_OUTER := [
	[-16.0, -10.0, -10.0, -10.0], [-9.0, -10.0, 9.0, -10.0], [11.0, -10.0, 16.0, -10.0],
	[-16.0, 10.0, -11.0, 10.0], [-9.0, 10.0, -1.0, 10.0], [1.0, 10.0, 16.0, 10.0],
	[-16.0, -10.0, -16.0, 10.0], [16.0, -10.0, 16.0, 10.0],
]
const MANOR_INNER := [
	[-2.0, -10.0, -2.0, -5.0], [-2.0, -3.0, -2.0, 4.0], [-2.0, 6.0, -2.0, 10.0],
	[2.0, -10.0, 2.0, -5.0], [2.0, -3.0, 2.0, 0.0],
	[-16.0, 0.0, -2.0, 0.0], [2.0, 0.0, 16.0, 0.0],
]
const MANOR_DOORS := [[Vector3(10, 0, -10), false], [Vector3(0, 0, 10), false], [Vector3(-2, 0, -4), true], [Vector3(2, 0, -4), true], [Vector3(-2, 0, 5), true]]


static func barbed_fence(rng: RandomNumberGenerator, length := 12.0) -> Node3D:
	var root := P._static_body()
	var posts: Array = []
	var x := -length / 2.0
	while x <= length / 2.0 + 0.01:
		var tilt := Basis(Vector3.FORWARD, rng.randf_range(-0.12, 0.12)) * Basis(Vector3.RIGHT, rng.randf_range(-0.08, 0.08))
		var h := rng.randf_range(1.35, 1.65)
		P._add_cylinder(root, rng.randf_range(0.09, 0.13), h + 0.3, Vector3(x, 0, 0) + tilt * Vector3(0, (h - 0.3) / 2.0, 0), "dry_wood", 7, tilt)
		posts.append([Vector3(x, 0, 0), tilt])
		x += rng.randf_range(2.4, 3.2)
	for y in [0.45, 0.85, 1.25]:
		for i in posts.size() - 1:
			var a: Vector3 = posts[i][0] + posts[i][1] * Vector3(0, y, 0.11)
			var b: Vector3 = posts[i + 1][0] + posts[i + 1][1] * Vector3(0, y, 0.11)
			P._add_tube(root, [a, (a + b) / 2.0 + Vector3(0, -0.05, 0), b], 0.007, 0.007, "iron", 3)
			_barbs(root, a, b)
	P._add_box_shape(root, Vector3(length, 1.5, 0.3), Vector3(0, 0.75, 0))
	return root


static func _barbs(root: Node3D, a: Vector3, b: Vector3) -> void:
	var count := int(a.distance_to(b) / 0.4)
	for i in count:
		var t := (i + 0.5) / count
		var p := a.lerp(b, t) + Vector3(0, -0.05 * (1.0 - absf(t * 2.0 - 1.0)), 0)
		for spin in [0.8, -0.8]:
			P._add_box(root, Vector3(0.012, 0.09, 0.012), p, "iron", Basis(Vector3.RIGHT, spin) * Basis(Vector3.FORWARD, 0.4))


static func rail_fence(rng: RandomNumberGenerator, length := 14.0) -> Node3D:
	var root := P._static_body()
	var tops: Array = []
	var x := -length / 2.0
	while x <= length / 2.0 + 0.01:
		var lean := Basis(Vector3.FORWARD, rng.randf_range(-0.06, 0.06))
		P._add_box(root, Vector3(0.16, 1.5, 0.16), Vector3(x, 0.7, 0), "wood", lean)
		tops.append(Vector3(x, 0, 0))
		x += 2.5
	for y in [0.6, 1.15]:
		for i in tops.size() - 1:
			var a: Vector3 = tops[i] + Vector3(0, y + rng.randf_range(-0.04, 0.04), 0.1)
			var b: Vector3 = tops[i + 1] + Vector3(0, y + rng.randf_range(-0.04, 0.04), 0.1)
			P._add_tube(root, [a - Vector3(0.15, 0, 0), (a + b) / 2.0 + Vector3(0, -0.03, 0), b + Vector3(0.15, 0, 0)], 0.06, 0.05, "dry_wood", 6)
	P._add_box_shape(root, Vector3(length, 1.4, 0.3), Vector3(0, 0.7, 0))
	return root


static func horse(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var coat := "horse_hide"
	var body := CapsuleMesh.new()
	body.radius = 0.4
	body.height = 1.95
	body.radial_segments = 12
	body.rings = 4
	var mi := P._mesh_instance(body, coat)
	mi.transform = Transform3D(Basis(Vector3.RIGHT, PI / 2), Vector3(0, 1.3, 0))
	root.add_child(mi)
	P._add_cylinder(root, 0.19, 0.95, Vector3(0, 1.82, 0.98), coat, 8, Basis(Vector3.RIGHT, 0.55))
	P._add_box(root, Vector3(0.24, 0.28, 0.62), Vector3(0, 2.12, 1.45), coat, Basis(Vector3.RIGHT, 1.0))
	for side in [-1.0, 1.0]:
		P._add_box(root, Vector3(0.05, 0.16, 0.06), Vector3(side * 0.08, 2.43, 1.3), coat)
	P._add_box(root, Vector3(0.07, 0.2, 0.95), Vector3(0, 2.0, 0.9), "ash", Basis(Vector3.RIGHT, 0.55))
	P._add_tube(root, [Vector3(0, 1.5, -1.1), Vector3(0, 1.25, -1.32), Vector3(rng.randf_range(-0.1, 0.1), 0.75, -1.38)], 0.08, 0.035, "ash", 5)
	for leg in [Vector3(0.2, 0, 0.62), Vector3(-0.2, 0, 0.62), Vector3(0.2, 0, -0.68), Vector3(-0.2, 0, -0.68)]:
		P._add_tube(root, [leg + Vector3(0, 1.25, 0), leg + Vector3(0, 0.6, rng.randf_range(-0.05, 0.05)), leg + Vector3(0, 0.1, 0)], 0.1, 0.05, coat, 6)
		P._add_cylinder(root, 0.075, 0.1, leg + Vector3(0, 0.05, 0), "ash", 6)
	P._add_box(root, Vector3(0.84, 0.04, 0.8), Vector3(0, 1.69, -0.05), "cloth")
	P._add_box(root, Vector3(0.5, 0.14, 0.58), Vector3(0, 1.77, -0.05), "leather")
	P._add_tube(root, [Vector3(0, 1.95, 1.72), Vector3(0, 1.45, 2.0), Vector3(0, 1.15, 2.3)], 0.015, 0.015, "leather", 4)
	P._add_box_shape(root, Vector3(0.8, 1.6, 2.2), Vector3(0, 0.8, 0))
	return root


static func tomb_slab(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	P._add_box(root, Vector3(2.9, 0.45, 4.0), Vector3(-1.55, 0.22, 0), "stone", Basis(Vector3.FORWARD, 0.03))
	P._add_box(root, Vector3(2.9, 0.45, 4.0), Vector3(1.55, 0.2, 0), "stone", Basis(Vector3.FORWARD, -0.04))
	for i in 6:
		P._add_box(root, Vector3(0.5, 0.02, 0.06), Vector3(-2.2 + i * 0.85, 0.46, -1.2 + (i % 2) * 0.6), "ash")
	P._add_box_shape(root, Vector3(6.0, 0.45, 4.0), Vector3(0, 0.22, 0))
	return root


static func bone_niche(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	for i in rng.randi_range(2, 4):
		var skull := SphereMesh.new()
		skull.radius = 0.12
		skull.height = 0.2
		var mi := P._mesh_instance(skull, "bone")
		mi.position = Vector3(rng.randf_range(-0.5, 0.5), 0.1, rng.randf_range(-0.3, 0.3))
		root.add_child(mi)
	for i in 8:
		P._add_cylinder(root, 0.02, rng.randf_range(0.3, 0.5), Vector3(rng.randf_range(-0.6, 0.6), 0.03, rng.randf_range(-0.4, 0.4)), "bone", 4, Basis(Vector3.UP, rng.randf() * TAU) * Basis(Vector3.FORWARD, PI / 2))
	for i in 4:
		P._add_box(root, Vector3(0.15, 0.1, 0.1), Vector3(rng.randf_range(-0.6, 0.6), 0.05, rng.randf_range(-0.4, 0.4)), "tile", Basis(Vector3.UP, rng.randf() * TAU))
	P._add_box(root, Vector3(0.7, 0.6, 0.15), Vector3(0, 1.6, -0.5), "stone")
	P._add_box(root, Vector3(0.4, 0.15, 0.05), Vector3(0, 1.45, -0.42), "ash")
	return root


static func torch(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_cylinder(root, 0.025, 0.9, Vector3(0, 0.45, 0), "wood", 5)
	P._add_cylinder(root, 0.05, 0.15, Vector3(0, 0.95, 0), "flame", 6)
	var light := OmniLight3D.new()
	light.name = "Luz"
	light.light_color = P.COLORS["flame"]
	light.light_energy = 2.2
	light.omni_range = 5.0
	light.position.y = 1.1
	light.set_script(load("res://game/world/components/flicker.gd"))
	root.add_child(light)
	return root


static func wall_lamp(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_box(root, Vector3(0.14, 0.2, 0.14), Vector3(0, 0, 0), "iron")
	P._add_cylinder(root, 0.04, 0.08, Vector3(0, 0.02, 0), "flame", 6)
	var light := OmniLight3D.new()
	light.light_color = P.COLORS["flame"]
	light.light_energy = 1.4
	light.omni_range = 5.0
	light.set_script(load("res://game/world/components/flicker.gd"))
	root.add_child(light)
	return root


static func chapel(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var w := 8.0
	var d := 14.0
	var h := 5.0
	var front := -d / 2.0
	P._add_wall(root, Vector3(0, 0, d / 2.0), w, h, 0.4, "lime")
	P._add_wall(root, Vector3(-w / 2.0, 0, 0), d, h, 0.4, "lime", true)
	P._add_wall(root, Vector3(w / 2.0, 0, 0), d, h, 0.4, "lime", true)
	P._add_wall(root, Vector3(-2.4, 0, front), 3.2, h, 0.4, "lime")
	P._add_wall(root, Vector3(2.4, 0, front), 3.2, h, 0.4, "lime")
	P._add_box(root, Vector3(1.6, 1.6, 0.4), Vector3(0, h - 0.8, front), "lime")
	P._add_wall(root, Vector3(0, 0, front - 0.05), 1.6, 3.4, 0.12, "wood")
	P._add_box(root, Vector3(0.05, 3.3, 0.04), Vector3(0, 1.7, front - 0.12), "iron")
	var pitch := deg_to_rad(32.0)
	var slope := (w / 2.0) / cos(pitch) + 0.4
	P._add_box(root, Vector3(slope, 0.12, d + 0.6), Vector3(-w / 4.0, h + 1.2, 0), "tile", Basis(Vector3.FORWARD, -pitch))
	P._add_box(root, Vector3(slope, 0.12, d + 0.6), Vector3(w / 4.0, h + 1.2, 0), "tile", Basis(Vector3.FORWARD, pitch))
	var gable := PrismMesh.new()
	gable.size = Vector3(w + 0.4, 3.2, 0.45)
	var gable_mi := P._mesh_instance(gable, "lime")
	gable_mi.position = Vector3(0, h + 1.6, front)
	root.add_child(gable_mi)
	P._add_box(root, Vector3(w + 0.8, 0.22, 0.6), Vector3(0, h + 0.05, front - 0.05), "lime")
	var rise := atan2(3.2, (w + 0.4) / 2.0)
	var edge := sqrt(pow((w + 0.4) / 2.0, 2) + 3.2 * 3.2) + 0.2
	for side in [-1.0, 1.0]:
		P._add_box(root, Vector3(edge, 0.2, 0.6), Vector3(side * (w + 0.4) / 4.0, h + 1.65, front - 0.05), "lime", Basis(Vector3.FORWARD, side * rise))
	_rose_window(root, Vector3(0, h + 1.15, front - 0.24))
	P._add_box(root, Vector3(0.15, 1.4, 0.15), Vector3(0, h + 3.9, front), "wood")
	P._add_box(root, Vector3(0.8, 0.15, 0.15), Vector3(0, h + 4.2, front), "wood")
	return root


static func _rose_window(root: Node3D, center: Vector3) -> void:
	var ring := TorusMesh.new()
	ring.inner_radius = 0.6
	ring.outer_radius = 0.8
	ring.rings = 20
	ring.ring_segments = 6
	var mi := P._mesh_instance(ring, "lime")
	mi.transform = Transform3D(Basis(Vector3.RIGHT, PI / 2), center)
	root.add_child(mi)
	P._add_cylinder(root, 0.62, 0.05, center, "void", 16, Basis(Vector3.RIGHT, PI / 2))
	for spin in [0.0, PI / 2, PI / 4, -PI / 4]:
		P._add_box(root, Vector3(1.2, 0.06, 0.06), center, "wood", Basis(Vector3.BACK, spin))


static func manor(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var h := 3.4
	var t := 0.35
	for w in MANOR_OUTER:
		_manor_wall(root, w, h, t, true)
	for w in MANOR_INNER:
		_manor_wall(root, w, h, t, false)
	for windowsill in [Vector3(-10, 0, -10), Vector3(-10, 0, 10)]:
		P._add_wall(root, windowsill, 2.0, 1.0, t, "lime")
		P._add_box(root, Vector3(2.0, 0.8, t), windowsill + Vector3(0, h - 0.4, 0), "lime")
		_shutters(root, windowsill + Vector3(0, 1.8, signf(windowsill.z) * (t / 2.0 + 0.05)), 2.0, 1.6)
	for door in MANOR_DOORS:
		_door_frame(root, door[0], door[1], h, t)
	P._add_box(root, Vector3(0.95, 2.15, 0.05), Vector3(1.0, 1.08, 10.5), "planks", Basis(Vector3.UP, deg_to_rad(70.0)), Vector3(0.47, 0, 0))
	P._add_box(root, Vector3(0.05, 0.8, 0.65), Vector3(-1.8, 1.75, -7.5), "wood")
	P._add_box(root, Vector3(0.03, 0.64, 0.5), Vector3(-1.77, 1.75, -7.5), "cloth")
	P._add_box(root, Vector3(32.4, 0.1, 20.4), Vector3(0, 0.05, 0), "planks")
	P._add_box(root, Vector3(32.4, 0.2, 20.4), Vector3(0, h, 0), "planks")
	_upper_floor(root, h, t)
	return root


static func _manor_wall(root: Node3D, w: Array, h: float, t: float, outer: bool) -> void:
	var a := Vector3(w[0], 0, w[1])
	var b := Vector3(w[2], 0, w[3])
	var length := a.distance_to(b)
	var center := (a + b) / 2.0
	var vertical: bool = absf(w[0] - w[2]) < 0.01
	if not outer:
		P._add_wall(root, center, length, h, t, "planks", vertical)
		return
	P._add_wall(root, center, length, h, t, "lime", vertical)
	var inward := Vector3(-signf(a.x), 0, 0) if vertical else Vector3(0, 0, -signf(a.z))
	var size := Vector3(0.05, h - 0.1, length) if vertical else Vector3(length, h - 0.1, 0.05)
	P._add_box(root, size, center + inward * (t / 2.0 + 0.03) + Vector3(0, h / 2.0, 0), "planks")


static func _door_frame(root: Node3D, center: Vector3, vertical: bool, h: float, t: float) -> void:
	var along := Vector3(0, 0, 1) if vertical else Vector3(1, 0, 0)
	var turn := Basis(Vector3.UP, PI / 2) if vertical else Basis.IDENTITY
	for side in [-1.0, 1.0]:
		P._add_box(root, Vector3(0.14, 2.2, t + 0.1), center + along * side * 0.93 + Vector3(0, 1.1, 0), "wood", turn)
	P._add_box(root, Vector3(2.0, 0.16, t + 0.1), center + Vector3(0, 2.25, 0), "wood", turn)
	P._add_box(root, Vector3(2.0, h - 2.33, t), center + Vector3(0, (h + 2.33) / 2.0, 0), "planks" if vertical else "lime", turn)


static func _shutters(root: Node3D, center: Vector3, width: float, height: float) -> void:
	for side in [-1.0, 1.0]:
		P._add_box(root, Vector3(width / 2.0, height, 0.05), center + Vector3(side * width * 0.75, 0, 0), "wood")


static func _upper_floor(root: Node3D, h: float, t: float) -> void:
	var upper := 3.0
	for z in [-10.0, 10.0]:
		P._add_box(root, Vector3(32.0 + t, upper, t), Vector3(0, h + upper / 2.0, z), "lime")
		for x in [-12.0, -6.0, 6.0, 12.0]:
			var face := Vector3(x, h + 1.6, z + signf(z) * (t / 2.0 + 0.02))
			P._add_box(root, Vector3(1.1, 1.5, 0.05), face, "void")
			_shutters(root, face + Vector3(0, 0, signf(z) * 0.03), 1.1, 1.5)
	for x in [-16.0, 16.0]:
		P._add_box(root, Vector3(t, upper, 20.0 + t), Vector3(x, h + upper / 2.0, 0), "lime")
	P._add_box(root, Vector3(32.8, 0.25, 20.8), Vector3(0, h + 0.1, 0), "lime")
	var pitch := deg_to_rad(24.0)
	var slope := 10.2 / cos(pitch) + 0.6
	P._add_box(root, Vector3(33.4, 0.15, slope), Vector3(0, h + upper + 2.2, -5.2), "tile", Basis(Vector3.RIGHT, -pitch))
	P._add_box(root, Vector3(33.4, 0.15, slope), Vector3(0, h + upper + 2.2, 5.2), "tile", Basis(Vector3.RIGHT, pitch))
	for x in [-16.0, 16.0]:
		var gable := PrismMesh.new()
		gable.size = Vector3(20.4, 4.4, t)
		var mi := P._mesh_instance(gable, "lime")
		mi.transform = Transform3D(Basis(Vector3.UP, PI / 2), Vector3(x, h + upper + 2.2, 0))
		root.add_child(mi)


static func porch_house(rng: RandomNumberGenerator) -> Node3D:
	return P.mud_house(rng, true)


static func great_dead_tree(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var trunk: Array = []
	for i in 8:
		trunk.append(Vector3(i * 0.32 + sin(i * 0.9) * 0.25, i * 0.95, cos(i * 0.7) * 0.25))
	P._add_tube(root, trunk, 0.6, 0.22, "dry_wood", 9)
	for i in 5:
		var from: Vector3 = trunk[rng.randi_range(4, 7)]
		var a := TAU * i / 5.0 + rng.randf_range(-0.3, 0.3)
		var dir := Vector3(cos(a) * 1.4 - 0.5, rng.randf_range(0.5, 1.1), sin(a)).normalized()
		_limb(root, rng, from, dir, rng.randf_range(2.4, 3.4), 0.2, 4)
	P._add_cylinder(root, 0.6, 6.0, Vector3(1.0, 3.0, 0), "", 8, Basis.IDENTITY, true)
	return root


static func _limb(root: Node3D, rng: RandomNumberGenerator, from: Vector3, dir: Vector3, length: float, radius: float, depth: int) -> void:
	var points: Array = [from]
	var p := from
	var heading := dir
	for i in 4:
		heading = (heading + Vector3(rng.randf_range(-0.35, 0.35), rng.randf_range(-0.25, 0.2), rng.randf_range(-0.35, 0.35))).normalized()
		p += heading * length / 4.0
		points.append(p)
	P._add_tube(root, points, radius, radius * 0.55, "dry_wood", 5 if depth > 2 else 4)
	if depth <= 1:
		return
	for i in rng.randi_range(2, 3):
		var turn := Basis(Vector3.UP, rng.randf_range(-1.2, 1.2)) * Basis(Vector3.RIGHT, rng.randf_range(-0.5, 0.5))
		_limb(root, rng, points[rng.randi_range(2, 4)], (turn * heading).normalized(), length * 0.62, radius * 0.55, depth - 1)


static func dry_stakes(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	for i in rng.randi_range(4, 6):
		var base := Vector3(rng.randf_range(-3.0, 3.0), -0.2, rng.randf_range(-3.0, 3.0))
		var height := rng.randf_range(1.8, 3.6)
		var bend := Vector3(rng.randf_range(-0.3, 0.3), 0, rng.randf_range(-0.3, 0.3))
		P._add_tube(root, [base, base + Vector3(0, height * 0.5, 0) + bend * 0.4, base + Vector3(0, height, 0) + bend], rng.randf_range(0.06, 0.1), 0.004, "dry_wood", 5)
		P._add_cylinder(root, 0.1, height, base + Vector3(0, height / 2.0, 0), "", 6, Basis.IDENTITY, true)
	return root
