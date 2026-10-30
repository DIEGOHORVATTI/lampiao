const P := preload("res://world/sertao/props.gd")


static func cerca_arame(rng: RandomNumberGenerator, length := 12.0) -> Node3D:
	var root := P._static_body()
	var x := -length / 2.0
	while x <= length / 2.0:
		P._add_cylinder(root, 0.09, 1.5, Vector3(x, 0.75, 0), "wood", 6, Basis(Vector3.FORWARD, rng.randf_range(-0.05, 0.05)))
		x += 3.0
	for y in [0.4, 0.8, 1.2]:
		P._add_cylinder(root, 0.008, length, Vector3(0, y, 0.06), "iron", 3, Basis(Vector3.FORWARD, PI / 2))
	P._add_box_shape(root, Vector3(length, 1.5, 0.3), Vector3(0, 0.75, 0))
	return root


static func cavalo(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var coat := "leather" if rng.randf() < 0.5 else "cloth"
	var body := CapsuleMesh.new()
	body.radius = 0.38
	body.height = 1.9
	var mi := P._mesh_instance(body, coat)
	mi.transform = Transform3D(Basis(Vector3.RIGHT, PI / 2), Vector3(0, 1.25, 0))
	root.add_child(mi)
	P._add_cylinder(root, 0.16, 0.9, Vector3(0, 1.75, 0.95), coat, 8, Basis(Vector3.RIGHT, 0.6))
	P._add_box(root, Vector3(0.22, 0.24, 0.6), Vector3(0, 2.05, 1.35), coat, Basis(Vector3.RIGHT, 0.9))
	for leg in [Vector3(0.22, 0.55, 0.65), Vector3(-0.22, 0.55, 0.65), Vector3(0.22, 0.55, -0.65), Vector3(-0.22, 0.55, -0.65)]:
		P._add_cylinder(root, 0.07, 1.1, leg, coat, 6)
	P._add_cylinder(root, 0.05, 0.8, Vector3(0, 1.2, -1.05), "ash", 5, Basis(Vector3.RIGHT, -0.4))
	P._add_box_shape(root, Vector3(0.8, 1.6, 2.2), Vector3(0, 0.8, 0))
	return root


static func arco_pedra(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	for side in [-1.0, 1.0]:
		var tilt := Basis(Vector3.FORWARD, side * rng.randf_range(0.04, 0.12))
		P._add_box(root, Vector3(1.4, 6.0, 1.4), Vector3(side * 6.2, 3.0, 0), "stone", tilt)
		P._add_box(root, Vector3(1.0, 0.4, 1.0), Vector3(side * 6.2, 4.5, 0.75), "ash", tilt)
		P._add_box_shape(root, Vector3(1.4, 6.0, 1.4), Vector3(side * 6.2, 3.0, 0))
	P._add_box(root, Vector3(14.0, 1.6, 2.0), Vector3(0, 6.6, 0), "stone", Basis(Vector3.FORWARD, rng.randf_range(-0.04, 0.04)))
	return root


static func totem_idolo(rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var h := rng.randf_range(3.0, 4.0)
	P._add_box(root, Vector3(1.1, h, 1.0), Vector3(0, h / 2.0, 0), "stone", Basis(Vector3.UP, rng.randf_range(-0.1, 0.1)))
	P._add_box(root, Vector3(0.8, 0.5, 0.2), Vector3(0, h - 1.3, 0.52), "ash")
	for i in 5:
		P._add_box(root, Vector3(0.08, 0.18, 0.1), Vector3(-0.32 + i * 0.16, h - 1.1, 0.6), "bone")
		P._add_box(root, Vector3(0.08, 0.18, 0.1), Vector3(-0.32 + i * 0.16, h - 1.5, 0.6), "bone")
	var eyes := Node3D.new()
	eyes.name = "Olhos"
	root.add_child(eyes)
	for x in [-0.22, 0.22]:
		var eye := SphereMesh.new()
		eye.radius = 0.1
		eye.height = 0.2
		var mi := P._mesh_instance(eye, "ash")
		mi.position = Vector3(x, h - 0.6, 0.52)
		eyes.add_child(mi)
	P._add_box_shape(root, Vector3(1.1, h, 1.0), Vector3(0, h / 2.0, 0))
	return root


static func laje_sepultura(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	P._add_box(root, Vector3(2.9, 0.45, 4.0), Vector3(-1.55, 0.22, 0), "stone", Basis(Vector3.FORWARD, 0.03))
	P._add_box(root, Vector3(2.9, 0.45, 4.0), Vector3(1.55, 0.2, 0), "stone", Basis(Vector3.FORWARD, -0.04))
	for i in 6:
		P._add_box(root, Vector3(0.5, 0.02, 0.06), Vector3(-2.2 + i * 0.85, 0.46, -1.2 + (i % 2) * 0.6), "ash")
	P._add_box_shape(root, Vector3(6.0, 0.45, 4.0), Vector3(0, 0.22, 0))
	return root


static func nicho_ossada(rng: RandomNumberGenerator) -> Node3D:
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


static func caldeirao(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_cylinder(root, 0.35, 0.45, Vector3(0, 0.45, 0), "iron", 12)
	P._add_cylinder(root, 0.3, 0.02, Vector3(0, 0.66, 0), "rot", 12)
	return root


static func monte_moedas(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	for i in 24:
		P._add_cylinder(root, 0.03, 0.01, Vector3(rng.randf_range(-0.5, 0.5), 0.01 + rng.randf() * 0.04, rng.randf_range(-0.4, 0.4)), "flame", 6, Basis(Vector3.RIGHT, rng.randf_range(-0.3, 0.3)))
	for x in [-0.6, 0.6]:
		var sack := SphereMesh.new()
		sack.radius = 0.25
		sack.height = 0.45
		var mi := P._mesh_instance(sack, "canvas")
		mi.position = Vector3(x, 0.2, 0.3)
		root.add_child(mi)
	return root


static func facho(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_cylinder(root, 0.025, 0.9, Vector3(0, 0.45, 0), "wood", 5)
	P._add_cylinder(root, 0.05, 0.15, Vector3(0, 0.95, 0), "flame", 6)
	var light := OmniLight3D.new()
	light.name = "Luz"
	light.light_color = P.COLORS["flame"]
	light.light_energy = 2.2
	light.omni_range = 5.0
	light.position.y = 1.1
	light.set_script(load("res://world/sertao/flicker.gd"))
	root.add_child(light)
	return root


static func candeeiro(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_box(root, Vector3(0.14, 0.2, 0.14), Vector3(0, 0, 0), "iron")
	P._add_cylinder(root, 0.04, 0.08, Vector3(0, 0.02, 0), "flame", 6)
	var light := OmniLight3D.new()
	light.light_color = P.COLORS["flame"]
	light.light_energy = 1.4
	light.omni_range = 5.0
	light.set_script(load("res://world/sertao/flicker.gd"))
	root.add_child(light)
	return root


static func esteira(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	P._add_box(root, Vector3(1.0, 0.03, 2.0), Vector3(0, 0.015, 0), "canvas")
	return root


static func capela(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var w := 8.0
	var d := 14.0
	var h := 5.0
	P._add_wall(root, Vector3(0, 0, d / 2.0), w, h, 0.4, "lime")
	P._add_wall(root, Vector3(-w / 2.0, 0, 0), d, h, 0.4, "lime", true)
	P._add_wall(root, Vector3(w / 2.0, 0, 0), d, h, 0.4, "lime", true)
	P._add_wall(root, Vector3(-2.4, 0, -d / 2.0), 3.2, h, 0.4, "lime")
	P._add_wall(root, Vector3(2.4, 0, -d / 2.0), 3.2, h, 0.4, "lime")
	P._add_box(root, Vector3(1.6, 1.6, 0.4), Vector3(0, h - 0.8, -d / 2.0), "lime")
	var pitch := deg_to_rad(32.0)
	var slope := (w / 2.0) / cos(pitch) + 0.4
	P._add_box(root, Vector3(slope, 0.12, d + 0.6), Vector3(-w / 4.0, h + 1.2, 0), "tile", Basis(Vector3.FORWARD, -pitch))
	P._add_box(root, Vector3(slope, 0.12, d + 0.6), Vector3(w / 4.0, h + 1.2, 0), "tile", Basis(Vector3.FORWARD, pitch))
	P._add_box(root, Vector3(w, 2.6, 0.4), Vector3(0, h + 1.3, -d / 2.0), "lime")
	P._add_box(root, Vector3(0.15, 1.4, 0.15), Vector3(0, h + 3.3, -d / 2.0), "wood")
	P._add_box(root, Vector3(0.8, 0.15, 0.15), Vector3(0, h + 3.6, -d / 2.0), "wood")
	return root


static func casa_grande(_rng: RandomNumberGenerator) -> Node3D:
	var root := P._static_body()
	var h := 3.4
	var t := 0.35
	var walls := [
		[-16.0, -10.0, -10.0, -10.0], [-9.0, -10.0, 9.0, -10.0], [11.0, -10.0, 16.0, -10.0],
		[-16.0, 10.0, -11.0, 10.0], [-9.0, 10.0, -1.0, 10.0], [1.0, 10.0, 16.0, 10.0],
		[-16.0, -10.0, -16.0, 10.0], [16.0, -10.0, 16.0, 10.0],
		[-2.0, -10.0, -2.0, -5.0], [-2.0, -3.0, -2.0, 4.0], [-2.0, 6.0, -2.0, 10.0],
		[2.0, -10.0, 2.0, -5.0], [2.0, -3.0, 2.0, 0.0],
		[-16.0, 0.0, -2.0, 0.0], [2.0, 0.0, 16.0, 0.0],
	]
	for w in walls:
		var a := Vector3(w[0], 0, w[1])
		var b := Vector3(w[2], 0, w[3])
		var length := a.distance_to(b)
		var center := (a + b) / 2.0
		var vertical: bool = absf(w[0] - w[2]) < 0.01
		P._add_wall(root, center, length, h, t, "lime", vertical)
	for windowsill in [Vector3(-10, 0, -10), Vector3(-10, 0, 10)]:
		P._add_wall(root, windowsill, 2.0, 1.0, t, "lime")
		P._add_box(root, Vector3(2.0, 0.8, t), windowsill + Vector3(0, h - 0.4, 0), "lime")
	P._add_box(root, Vector3(2.0, h - 2.2, t), Vector3(10, 2.2 + (h - 2.2) / 2.0, -10), "lime")
	P._add_box(root, Vector3(2.0, h - 2.2, t), Vector3(0, 2.2 + (h - 2.2) / 2.0, 10), "lime")
	P._add_box(root, Vector3(32.4, 0.1, 20.4), Vector3(0, 0.05, 0), "wood")
	var pitch := deg_to_rad(24.0)
	var slope := 10.2 / cos(pitch) + 0.6
	P._add_box(root, Vector3(33.4, 0.15, slope), Vector3(0, h + 2.2, -5.2), "tile", Basis(Vector3.RIGHT, -pitch))
	P._add_box(root, Vector3(33.4, 0.15, slope), Vector3(0, h + 2.2, 5.2), "tile", Basis(Vector3.RIGHT, pitch))
	P._add_box(root, Vector3(32.4, 0.2, 20.4), Vector3(0, h, 0), "wood")
	return root
