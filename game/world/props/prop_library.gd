class_name PropLibrary

const COLORS := {
	"earth": Color(0.42, 0.27, 0.16),
	"cactus": Color(0.22, 0.32, 0.2),
	"taipa": Color(0.55, 0.38, 0.25),
	"lime": Color(0.78, 0.72, 0.62),
	"tile": Color(0.5, 0.2, 0.12),
	"wood": Color(0.3, 0.2, 0.12),
	"dry_wood": Color(0.45, 0.4, 0.34),
	"stone": Color(0.45, 0.42, 0.38),
	"iron": Color(0.12, 0.11, 0.1),
	"flame": Color(1.0, 0.6, 0.25),
	"canvas": Color(0.52, 0.47, 0.36),
	"cloth": Color(0.3, 0.24, 0.17),
	"leather": Color(0.36, 0.22, 0.12),
	"ash": Color(0.12, 0.11, 0.1),
	"ember": Color(1.0, 0.35, 0.1),
	"bone": Color(0.82, 0.78, 0.68),
	"rot": Color(0.22, 0.05, 0.04),
}

const TEXTURES := {
	"earth": ["terra", 0.25],
	"cactus": ["mandacaru", 1.0],
	"taipa": ["taipa", 0.4],
	"lime": ["reboco", 0.4],
	"tile": ["telha", 0.6],
	"wood": ["madeira", 0.8],
	"dry_wood": ["madeira", 1.2],
	"stone": ["rock", 0.5],
}
const TEXTURE_DIR := "res://resources/sertao/textures/%s.png"

static var _materials := {}


static func build(kind: String, rng: RandomNumberGenerator) -> Node3D:
	var root := _build(kind, rng)
	_merge(root)
	return root


static func _merge(root: Node3D) -> void:
	var tools := {}
	for mi in root.find_children("*", "MeshInstance3D", true, false):
		var xform := Transform3D.IDENTITY
		var node: Node = mi
		while node != root:
			xform = node.transform * xform
			node = node.get_parent()
		var mat: Material = mi.material_override
		if not tools.has(mat):
			var st := SurfaceTool.new()
			st.begin(Mesh.PRIMITIVE_TRIANGLES)
			tools[mat] = st
		for surface in mi.mesh.get_surface_count():
			var part := SurfaceTool.new()
			part.create_from(mi.mesh, surface)
			tools[mat].append_from(part.commit(), 0, xform)
		mi.get_parent().remove_child(mi)
		mi.free()
	for mat in tools:
		var merged := MeshInstance3D.new()
		merged.mesh = tools[mat].commit()
		merged.material_override = mat
		root.add_child(merged)


static func _build(kind: String, rng: RandomNumberGenerator) -> Node3D:
	match kind:
		"terrain": return terrain(rng, 60.0)
		"terrain_large": return terrain(rng, 140.0)
		"cave_floor": return surface(load("res://game/world/chapters/chapter_01/cave_field.gd"), "floor_height", false, "stone")
		"cave_ceiling": return surface(load("res://game/world/chapters/chapter_01/cave_field.gd"), "ceiling_height", true, "stone")
		"cave_top": return surface(load("res://game/world/chapters/chapter_01/cave_field.gd"), "top_height", false, "earth")
		"farm_terrain": return terrain(rng, 96.0, 0.2)
		"xique_xique": return xique_xique(rng)
		"horse_carcass": return carcass(rng, 1.0)
		"barbed_fence", "horse", "stone_arch", "idol_totem", "tomb_slab", "bone_niche", "cauldron", "coin_pile", "torch", "wall_lamp", "sleeping_mat", "chapel", "manor":
			return load("res://game/world/props/chapter_01_pieces.gd").call(kind, rng)
		"goat_carcass": return carcass(rng, 0.5)
		"dead_vulture": return carcass(rng, 0.25)
		"mandacaru": return mandacaru(rng)
		"mud_house": return mud_house(rng)
		"stick_fence": return stick_fence(rng, 8.0)
		"cross": return cross(rng)
		"rock": return rock(rng)
		"dead_tree": return dead_tree(rng)
		"well": return well(rng)
		"campfire": return campfire(rng, true)
		"campfire_out": return campfire(rng, false)
		"canvas_tent": return canvas_tent(rng, false)
		"torn_tent": return canvas_tent(rng, true)
		"overturned_cart": return overturned_cart(rng)
		"crate": return crate(rng)
		"stone_wall": return stone_wall(rng, 8.0)
		"grave": return grave(rng)
		"cliff": return cliff(rng)
		"corpse": return corpse(rng)
		"roadside_cross": return roadside_cross(rng)
	push_error("PropLibrary: unknown kind '%s'" % kind)
	return Node3D.new()


static func material(name: String) -> StandardMaterial3D:
	if not _materials.has(name):
		var m := StandardMaterial3D.new()
		m.albedo_color = COLORS[name]
		m.roughness = 0.95
		if TEXTURES.has(name) and ResourceLoader.exists(TEXTURE_DIR % TEXTURES[name][0]):
			m.albedo_texture = load(TEXTURE_DIR % TEXTURES[name][0])
			m.albedo_color = Color.WHITE.lerp(COLORS[name], 0.25)
			m.uv1_triplanar = true
			m.uv1_world_triplanar = true
			m.uv1_scale = Vector3.ONE * TEXTURES[name][1]
		if name == "flame" or name == "ember":
			m.emission_enabled = true
			m.emission = COLORS[name]
			m.emission_energy_multiplier = 3.0
		_materials[name] = m
	return _materials[name]


static func terrain(rng: RandomNumberGenerator, size: float, amplitude := 1.2) -> Node3D:
	var plane := PlaneMesh.new()
	plane.size = Vector2(size, size)
	plane.subdivide_width = int(size / 2)
	plane.subdivide_depth = int(size / 2)
	var noise := FastNoiseLite.new()
	noise.seed = rng.randi()
	noise.frequency = 0.04
	var mesh := _displace(plane, func(v: Vector3) -> Vector3:
		var flatten := clampf(Vector2(v.x, v.z).length() / (size * 0.25), 0.0, 1.0)
		return v + Vector3.UP * noise.get_noise_2d(v.x, v.z) * amplitude * flatten)
	var root := _static_body()
	root.add_child(_mesh_instance(mesh, "earth"))
	var shape := CollisionShape3D.new()
	shape.shape = mesh.create_trimesh_shape()
	root.add_child(shape)
	return root



static func surface(field: Script, fn: String, flip: bool, mat: String) -> Node3D:
	var cell: float = field.CELL
	var lo: Vector2 = field.MIN
	var hi: Vector2 = field.MAX
	var cols := int((hi.x - lo.x) / cell) + 1
	var rows := int((hi.y - lo.y) / cell) + 1
	var noise := FastNoiseLite.new()
	noise.seed = 1938
	noise.frequency = 0.35
	var heights := PackedFloat32Array()
	heights.resize(cols * rows)
	var floor_ref := PackedFloat32Array()
	floor_ref.resize(cols * rows)
	for r in rows:
		for c in cols:
			var x := lo.x + c * cell
			var z := lo.y + r * cell
			heights[r * cols + c] = field.call(fn, x, z)
			floor_ref[r * cols + c] = field.call("floor_height", x, z) if fn != "floor_height" else heights[r * cols + c]
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for r in rows - 1:
		for c in cols - 1:
			var ids := [r * cols + c, r * cols + c + 1, (r + 1) * cols + c, (r + 1) * cols + c + 1]
			var ok := true
			for id in ids:
				var i: int = id
				if is_nan(heights[i]):
					ok = false
			if not ok:
				continue
			var v := []
			for id in ids:
				var i: int = id
				var x := lo.x + (i % cols) * cell
				var z := lo.y + int(i / cols) * cell
				var y: float = heights[i]
				var rough := clampf(absf(y - floor_ref[i]) / 3.0, 0.0, 1.0) if fn == "ceiling_height" else clampf((y - floor_ref[i] + 0.01) / 3.0, 0.0, 1.0)
				if fn == "floor_height":
					var base: float = field.call("sample", x, z).y
					rough = clampf(absf(y - base) / 3.0, 0.0, 1.0)
				y += noise.get_noise_2d(x, z) * (0.06 + rough * 0.45)
				v.append(Vector3(x + noise.get_noise_2d(z, x) * rough * 0.2, y, z))
			var tris := [[0, 1, 2], [2, 1, 3]]
			for t in tris:
				var order: Array = t if not flip else [t[0], t[2], t[1]]
				for k in order:
					st.add_vertex(v[k])
	st.generate_normals()
	var mesh := st.commit()
	var root := _static_body()
	root.add_child(_mesh_instance(mesh, mat))
	var shape := CollisionShape3D.new()
	shape.shape = mesh.create_trimesh_shape()
	root.add_child(shape)
	return root


static func xique_xique(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	for i in rng.randi_range(3, 6):
		var h := rng.randf_range(0.4, 1.0)
		var a := rng.randf() * TAU
		var tilt := Basis(Vector3(cos(a), 0, sin(a)), rng.randf_range(0.2, 0.6))
		_add_cylinder(root, 0.08, h, tilt * Vector3(0, h / 2, 0), "cactus", 6, tilt)
	_add_box_shape(root, Vector3(0.8, 0.8, 0.8), Vector3(0, 0.4, 0))
	return root


static func carcass(rng: RandomNumberGenerator, size: float) -> Node3D:
	var root := Node3D.new()
	var length := 1.6 * size
	var meat := SphereMesh.new()
	meat.radius = 0.35 * size
	meat.height = 0.4 * size
	meat.radial_segments = 8
	meat.rings = 4
	var meat_mi := _mesh_instance(meat, "rot")
	meat_mi.scale = Vector3(1.0, 0.6, length / (0.7 * size))
	meat_mi.position.y = 0.08 * size
	root.add_child(meat_mi)
	var ribs := int(7 * maxf(size, 0.5))
	for i in ribs:
		var z := -length * 0.35 + i * (length * 0.6 / ribs)
		for side in [-1.0, 1.0]:
			_add_cylinder(root, 0.025 * size + 0.01, 0.55 * size, Vector3(side * 0.18 * size, 0.28 * size, z), "bone", 5, Basis(Vector3.FORWARD, side * 0.5 + rng.randf_range(-0.1, 0.1)))
	_add_cylinder(root, 0.04 * size + 0.01, length, Vector3(0, 0.38 * size, 0), "bone", 5, Basis(Vector3.RIGHT, PI / 2))
	var skull := SphereMesh.new()
	skull.radius = 0.16 * size
	skull.height = 0.26 * size
	skull.radial_segments = 8
	skull.rings = 4
	var skull_mi := _mesh_instance(skull, "bone")
	skull_mi.scale = Vector3(0.8, 0.8, 1.8)
	skull_mi.position = Vector3(0.1 * size, 0.12 * size, length * 0.62)
	skull_mi.rotation.y = rng.randf_range(-0.6, 0.6)
	root.add_child(skull_mi)
	for leg in 4:
		var x := (0.25 if leg % 2 == 0 else -0.25) * size
		var z := (0.4 if leg < 2 else -0.4) * length * 0.6
		_add_cylinder(root, 0.03 * size + 0.008, 0.8 * size, Vector3(x * 1.8, 0.04, z), "bone", 5, Basis(Vector3.UP, rng.randf() * TAU) * Basis(Vector3.FORWARD, PI / 2))
	return root


static func mandacaru(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var height := rng.randf_range(2.5, 4.5)
	_add_cylinder(root, 0.22, height, Vector3(0, height / 2, 0), "cactus", 8)
	for i in rng.randi_range(1, 4):
		var side := 1.0 if i % 2 == 0 else -1.0
		var y := rng.randf_range(1.0, height - 0.8)
		var arm := rng.randf_range(0.8, 1.6)
		var reach := rng.randf_range(0.4, 0.7)
		var turn := rng.randf() * TAU
		var dir := Vector3(cos(turn), 0, sin(turn)) * side
		_add_cylinder(root, 0.13, reach, Vector3(0, y, 0) + dir * reach / 2, "cactus", 8, Basis(dir.cross(Vector3.UP).normalized(), PI / 2))
		_add_cylinder(root, 0.14, arm, Vector3(0, y + arm / 2, 0) + dir * reach, "cactus", 8)
	_add_box_shape(root, Vector3(0.5, height, 0.5), Vector3(0, height / 2, 0))
	return root


static func mud_house(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var w := rng.randf_range(5.0, 7.0)
	var d := rng.randf_range(4.0, 5.5)
	var h := 2.6
	var t := 0.25
	var door := 1.0
	var wall := "lime" if rng.randf() < 0.4 else "taipa"
	_add_wall(root, Vector3(0, 0, -d / 2), w, h, t, wall)
	_add_wall(root, Vector3(-w / 2, 0, 0), d, h, t, wall, true)
	_add_wall(root, Vector3(w / 2, 0, 0), d, h, t, wall, true)
	var side := (w - door) / 2
	_add_wall(root, Vector3(-(door + side) / 2, 0, d / 2), side, h, t, wall)
	_add_wall(root, Vector3((door + side) / 2, 0, d / 2), side, h, t, wall)
	_add_box(root, Vector3(door + 0.1, h - 2.0, t), Vector3(0, 2.0 + (h - 2.0) / 2, d / 2), wall)
	var gable := Basis(Vector3.RIGHT, deg_to_rad(28))
	var slope := d / 2 / cos(deg_to_rad(28)) + 0.4
	_add_box(root, Vector3(w + 0.6, 0.08, slope), Vector3(0, h + 0.55, d / 4 + 0.05), "tile", gable.inverse())
	_add_box(root, Vector3(w + 0.6, 0.08, slope), Vector3(0, h + 0.55, -d / 4 - 0.05), "tile", gable)
	_add_box(root, Vector3(door - 0.1, 2.0, 0.05), Vector3(-door / 2 + 0.05, 1.0, d / 2 + 0.45), "wood", Basis(Vector3.UP, deg_to_rad(-70)), Vector3(door / 2, 0, 0))
	return root


static func stick_fence(rng: RandomNumberGenerator, length: float) -> Node3D:
	var root := _static_body()
	var x := -length / 2
	while x < length / 2:
		var h := rng.randf_range(1.1, 1.5)
		var tilt := Basis(Vector3.FORWARD, rng.randf_range(-0.12, 0.12))
		_add_cylinder(root, 0.04, h, Vector3(x, h / 2, 0), "dry_wood", 5, tilt)
		x += rng.randf_range(0.18, 0.35)
	for y in [0.45, 0.95]:
		_add_cylinder(root, 0.035, length, Vector3(0, y, 0.05), "dry_wood", 5, Basis(Vector3.FORWARD, PI / 2))
	_add_box_shape(root, Vector3(length, 1.4, 0.2), Vector3(0, 0.7, 0))
	return root


static func cross(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var h := rng.randf_range(1.0, 1.6)
	var lean := Basis(Vector3.RIGHT, rng.randf_range(-0.15, 0.15))
	_add_box(root, Vector3(0.1, h, 0.08), lean * Vector3(0, h / 2, 0), "wood", lean)
	_add_box(root, Vector3(h * 0.55, 0.09, 0.08), lean * Vector3(0, h * 0.72, 0), "wood", lean)
	_add_box_shape(root, Vector3(0.3, h, 0.3), Vector3(0, h / 2, 0))
	return root


static func rock(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var radius := rng.randf_range(0.4, 1.4)
	var sphere := SphereMesh.new()
	sphere.radius = radius
	sphere.height = radius * rng.randf_range(1.0, 1.6)
	sphere.radial_segments = 10
	sphere.rings = 6
	var noise := FastNoiseLite.new()
	noise.seed = rng.randi()
	noise.frequency = 1.2
	var mesh := _displace(sphere, func(v: Vector3) -> Vector3:
		return v * (1.0 + noise.get_noise_3dv(v) * 0.35))
	var rock := _mesh_instance(mesh, "stone")
	rock.position.y = radius * 0.3
	root.add_child(rock)
	var shape := CollisionShape3D.new()
	shape.shape = mesh.create_convex_shape()
	shape.position.y = radius * 0.3
	root.add_child(shape)
	return root


static func dead_tree(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var height := rng.randf_range(2.0, 3.2)
	_add_cylinder(root, 0.14, height, Vector3(0, height / 2, 0), "dry_wood", 6)
	_branch(root, rng, Vector3(0, height, 0), Vector3.UP, height * 0.6, 0.1, 3)
	_add_box_shape(root, Vector3(0.35, height, 0.35), Vector3(0, height / 2, 0))
	return root


static func well(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	for i in 12:
		var a := TAU * i / 12.0
		_add_box(root, Vector3(0.5, rng.randf_range(0.7, 0.85), 0.3), Vector3(cos(a), 0.4, sin(a)) * Vector3(1.0, 1.0, 1.0), "stone", Basis(Vector3.UP, -a + PI / 2))
	for x in [-1.1, 1.1]:
		_add_box(root, Vector3(0.12, 2.0, 0.12), Vector3(x, 1.0, 0), "wood")
	_add_cylinder(root, 0.06, 2.4, Vector3(0, 1.85, 0), "wood", 6, Basis(Vector3.FORWARD, PI / 2))
	_add_cylinder(root, 1.25, 0.8, Vector3(0, 0.4, 0), "", 12, Basis.IDENTITY, true)
	return root



static func campfire(rng: RandomNumberGenerator, lit: bool) -> Node3D:
	var root := _static_body()
	for i in 9:
		var a := TAU * i / 9.0
		_add_box(root, Vector3(0.22, 0.16, 0.18), Vector3(cos(a), 0.08, sin(a)) * Vector3(0.55, 1.0, 0.55), "stone", Basis(Vector3.UP, rng.randf() * TAU))
	for i in 4:
		var a := TAU * i / 4.0 + rng.randf()
		_add_cylinder(root, 0.05, 0.7, Vector3(0, 0.12, 0), "ash" if not lit else "wood", 5, Basis(Vector3.UP, a) * Basis(Vector3.FORWARD, PI / 2 - 0.35))
	_add_cylinder(root, 0.35, 0.04, Vector3(0, 0.02, 0), "ember" if lit else "ash", 10)
	if lit:
		var light := OmniLight3D.new()
		light.light_color = COLORS["flame"]
		light.light_energy = 3.0
		light.omni_range = 9.0
		light.position.y = 0.6
		light.set_script(load("res://game/world/components/flicker.gd"))
		root.add_child(light)
	_add_cylinder(root, 0.65, 0.3, Vector3(0, 0.15, 0), "", 8, Basis.IDENTITY, true)
	return root


static func canvas_tent(rng: RandomNumberGenerator, torn: bool) -> Node3D:
	var root := _static_body()
	var w := 2.4
	var length := rng.randf_range(2.6, 3.4)
	var h := 1.7
	var slope := sqrt(pow(w / 2, 2) + h * h)
	var tilt := atan2(w / 2, h)
	_add_box(root, Vector3(0.04, slope, length), Vector3(-w / 4, h / 2, 0), "canvas", Basis(Vector3.FORWARD, tilt))
	if not torn:
		_add_box(root, Vector3(0.04, slope, length), Vector3(w / 4, h / 2, 0), "canvas", Basis(Vector3.FORWARD, -tilt))
	else:
		_add_box(root, Vector3(0.04, slope * 0.5, length * 0.7), Vector3(w / 2 + 0.2, 0.15, 0.3), "canvas", Basis(Vector3.FORWARD, 1.35))
	for z in [-length / 2, length / 2]:
		_add_cylinder(root, 0.03, h + 0.1, Vector3(0, (h + 0.1) / 2, z), "wood", 5)
	_add_box_shape(root, Vector3(w, h, length), Vector3(0, h / 2, 0))
	return root


static func overturned_cart(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var lie := Basis(Vector3.FORWARD, deg_to_rad(rng.randf_range(95, 110)))
	var bed := Node3D.new()
	bed.transform = Transform3D(lie, Vector3(0, 0.75, 0))
	root.add_child(bed)
	_add_box(bed, Vector3(1.6, 0.08, 3.0), Vector3.ZERO, "wood")
	for side in [-0.8, 0.8]:
		_add_box(bed, Vector3(0.06, 0.5, 3.0), Vector3(side, 0.25, 0), "wood")
	for x in [-0.88, 0.88]:
		_add_cylinder(bed, 0.55, 0.1, Vector3(x, -0.25, 0.3), "wood", 10, Basis(Vector3.FORWARD, PI / 2))
	_add_cylinder(bed, 0.04, 2.2, Vector3(0, -0.1, -2.4), "wood", 5, Basis(Vector3.RIGHT, PI / 2))
	_add_box_shape(root, Vector3(1.0, 1.6, 3.0), Vector3(0, 0.8, 0))
	return root


static func crate(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var size := rng.randf_range(0.55, 0.8)
	_add_box(root, Vector3.ONE * size, Vector3(0, size / 2, 0), "wood", Basis(Vector3.UP, rng.randf() * 0.4))
	_add_box_shape(root, Vector3.ONE * size, Vector3(0, size / 2, 0))
	return root


static func stone_wall(rng: RandomNumberGenerator, length: float) -> Node3D:
	var root := _static_body()
	var h := rng.randf_range(1.0, 1.3)
	_add_box(root, Vector3(length, h, 0.5), Vector3(0, h / 2, 0), "stone")
	var x := -length / 2 + 0.3
	while x < length / 2:
		var stone := rng.randf_range(0.3, 0.55)
		_add_box(root, Vector3(stone, rng.randf_range(0.15, 0.3), 0.45), Vector3(x, h + 0.08, rng.randf_range(-0.04, 0.04)), "stone", Basis(Vector3.UP, rng.randf_range(-0.2, 0.2)))
		x += stone + rng.randf_range(0.05, 0.4)
	_add_box_shape(root, Vector3(length, h + 0.2, 0.5), Vector3(0, (h + 0.2) / 2, 0))
	return root


static func grave(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	var mound := SphereMesh.new()
	mound.radius = 0.5
	mound.height = 0.5
	mound.radial_segments = 8
	mound.rings = 4
	var mi := _mesh_instance(mound, "earth")
	mi.scale = Vector3(1.4, 0.5, 2.4)
	mi.position.y = 0.0
	root.add_child(mi)
	if rng.randf() < 0.6:
		var cross := cross(rng)
		cross.position = Vector3(0, 0, -1.1)
		root.add_child(cross)
	return root


static func cliff(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var size := Vector3(rng.randf_range(10, 14), rng.randf_range(6, 9), 3.0)
	var box := BoxMesh.new()
	box.size = size
	box.subdivide_width = 8
	box.subdivide_height = 6
	box.subdivide_depth = 2
	var noise := FastNoiseLite.new()
	noise.seed = rng.randi()
	noise.frequency = 0.25
	var mesh := _displace(box, func(v: Vector3) -> Vector3:
		return v + Vector3(noise.get_noise_3dv(v) * 0.6, noise.get_noise_3dv(v + Vector3(9, 0, 0)) * 0.5, noise.get_noise_3dv(v + Vector3(0, 9, 0)) * 1.2))
	var mi := _mesh_instance(mesh, "stone")
	mi.position.y = size.y / 2 - 0.5
	root.add_child(mi)
	_add_box_shape(root, size, Vector3(0, size.y / 2 - 0.5, 0))
	return root


static func corpse(rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	var lie := Basis(Vector3.FORWARD, PI / 2) * Basis(Vector3.UP, rng.randf_range(-0.3, 0.3))
	var body := CapsuleMesh.new()
	body.radius = 0.2
	body.height = 1.4
	body.radial_segments = 8
	body.rings = 2
	var mi := _mesh_instance(body, "cloth")
	mi.transform = Transform3D(lie, Vector3(0, 0.18, 0))
	root.add_child(mi)
	_add_box(root, Vector3(0.12, 0.12, 0.5), Vector3(-0.2, 0.08, 0.25), "leather", Basis(Vector3.UP, rng.randf_range(-0.4, 0.4)))
	var hat := CylinderMesh.new()
	hat.top_radius = 0.18
	hat.bottom_radius = 0.32
	hat.height = 0.14
	hat.radial_segments = 10
	var hat_mi := _mesh_instance(hat, "leather")
	hat_mi.position = Vector3(1.05 + rng.randf_range(0.0, 0.5), 0.07, rng.randf_range(-0.4, 0.4))
	root.add_child(hat_mi)
	return root


static func roadside_cross(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	_add_box(root, Vector3(0.14, 2.2, 0.12), Vector3(0, 1.1, 0), "wood")
	_add_box(root, Vector3(1.2, 0.12, 0.1), Vector3(0, 1.6, 0), "wood")
	for i in 5:
		var x := -0.5 + i * 0.25
		var drop := rng.randf_range(0.15, 0.35)
		_add_cylinder(root, 0.005, drop, Vector3(x, 1.54 - drop / 2, 0.06), "dry_wood", 3)
		var head := SphereMesh.new()
		head.radius = 0.06
		head.height = 0.14
		head.radial_segments = 6
		head.rings = 3
		var mi := _mesh_instance(head, "dry_wood")
		mi.position = Vector3(x, 1.54 - drop - 0.06, 0.06)
		root.add_child(mi)
	for i in 6:
		var a := TAU * i / 6.0
		_add_box(root, Vector3(0.2, 0.12, 0.16), Vector3(cos(a) * 0.35, 0.06, sin(a) * 0.35), "stone")
	_add_box_shape(root, Vector3(0.4, 2.2, 0.4), Vector3(0, 1.1, 0))
	return root


static func _branch(root: Node3D, rng: RandomNumberGenerator, from: Vector3, dir: Vector3, length: float, radius: float, depth: int) -> void:
	if depth == 0:
		return
	for i in 2:
		var bent := dir.rotated(Vector3.UP, rng.randf() * TAU).rotated(Vector3.RIGHT, rng.randf_range(0.4, 0.9)).normalized()
		var to := from + bent * length
		var basis := Basis(Quaternion(Vector3.UP, bent))
		_add_cylinder(root, radius, length, (from + to) / 2, "dry_wood", 5, basis)
		_branch(root, rng, to, bent, length * 0.65, radius * 0.6, depth - 1)


static func _add_wall(root: Node3D, center: Vector3, length: float, h: float, t: float, mat: String, rotated := false) -> void:
	var size := Vector3(t, h, length) if rotated else Vector3(length, h, t)
	_add_box(root, size, center + Vector3(0, h / 2, 0), mat)
	_add_box_shape(root, size, center + Vector3(0, h / 2, 0))


static func _add_box(root: Node3D, size: Vector3, pos: Vector3, mat: String, basis := Basis.IDENTITY, pivot := Vector3.ZERO) -> void:
	var box := BoxMesh.new()
	box.size = size
	var mi := _mesh_instance(box, mat)
	mi.transform = Transform3D(basis, pos + basis * -pivot + pivot)
	root.add_child(mi)


static func _add_cylinder(root: Node3D, radius: float, height: float, pos: Vector3, mat: String, segments: int, basis := Basis.IDENTITY, shape_only := false) -> void:
	if shape_only:
		var shape := CollisionShape3D.new()
		var cyl := CylinderShape3D.new()
		cyl.radius = radius
		cyl.height = height
		shape.shape = cyl
		shape.transform = Transform3D(basis, pos)
		root.add_child(shape)
		return
	var mesh := CylinderMesh.new()
	mesh.top_radius = radius * 0.85
	mesh.bottom_radius = radius
	mesh.height = height
	mesh.radial_segments = segments
	mesh.rings = 1
	var mi := _mesh_instance(mesh, mat)
	mi.transform = Transform3D(basis, pos)
	root.add_child(mi)


static func _add_box_shape(root: Node3D, size: Vector3, pos: Vector3) -> void:
	var shape := CollisionShape3D.new()
	var box := BoxShape3D.new()
	box.size = size
	shape.shape = box
	shape.position = pos
	root.add_child(shape)


static func _mesh_instance(mesh: Mesh, mat: String) -> MeshInstance3D:
	var mi := MeshInstance3D.new()
	mi.mesh = mesh
	mi.material_override = material(mat)
	return mi


static func _static_body() -> StaticBody3D:
	return StaticBody3D.new()


static func _displace(source: PrimitiveMesh, fn: Callable) -> ArrayMesh:
	var arrays := source.get_mesh_arrays()
	var verts: PackedVector3Array = arrays[Mesh.ARRAY_VERTEX]
	for i in verts.size():
		verts[i] = fn.call(verts[i])
	arrays[Mesh.ARRAY_VERTEX] = verts
	var temp := ArrayMesh.new()
	temp.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
	var st := SurfaceTool.new()
	st.create_from(temp, 0)
	st.generate_normals()
	return st.commit()
