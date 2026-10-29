class_name SertaoProps

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
}

const TEXTURES := {
	"earth": ["terra", 0.25],
	"cactus": ["mandacaru", 1.0],
	"taipa": ["taipa", 0.4],
	"lime": ["reboco", 0.4],
	"tile": ["telha", 0.6],
	"wood": ["madeira", 0.8],
	"dry_wood": ["madeira", 1.2],
	"stone": ["pedra", 0.5],
}
const TEXTURE_DIR := "res://resources/sertao/textures/%s.png"

static var _materials := {}


static func build(kind: String, rng: RandomNumberGenerator) -> Node3D:
	match kind:
		"terreno": return terreno(rng, 60.0)
		"mandacaru": return mandacaru(rng)
		"casa_taipa": return casa_taipa(rng)
		"cerca_varas": return cerca_varas(rng, 8.0)
		"cruz": return cruz(rng)
		"pedra": return pedra(rng)
		"arvore_seca": return arvore_seca(rng)
		"poco": return poco(rng)
		"lampiao": return lampiao(rng)
	push_error("SertaoProps: peça desconhecida '%s'" % kind)
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
		if name == "flame":
			m.emission_enabled = true
			m.emission = COLORS[name]
			m.emission_energy_multiplier = 3.0
		_materials[name] = m
	return _materials[name]


static func terreno(rng: RandomNumberGenerator, size: float) -> Node3D:
	var plane := PlaneMesh.new()
	plane.size = Vector2(size, size)
	plane.subdivide_width = int(size / 2)
	plane.subdivide_depth = int(size / 2)
	var noise := FastNoiseLite.new()
	noise.seed = rng.randi()
	noise.frequency = 0.04
	var mesh := _displace(plane, func(v: Vector3) -> Vector3:
		var flatten := clampf(Vector2(v.x, v.z).length() / (size * 0.25), 0.0, 1.0)
		return v + Vector3.UP * noise.get_noise_2d(v.x, v.z) * 1.2 * flatten)
	var root := _static_body()
	root.add_child(_mesh_instance(mesh, "earth"))
	var shape := CollisionShape3D.new()
	shape.shape = mesh.create_trimesh_shape()
	root.add_child(shape)
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


static func casa_taipa(rng: RandomNumberGenerator) -> Node3D:
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


static func cerca_varas(rng: RandomNumberGenerator, length: float) -> Node3D:
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


static func cruz(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var h := rng.randf_range(1.0, 1.6)
	var lean := Basis(Vector3.RIGHT, rng.randf_range(-0.15, 0.15))
	_add_box(root, Vector3(0.1, h, 0.08), lean * Vector3(0, h / 2, 0), "wood", lean)
	_add_box(root, Vector3(h * 0.55, 0.09, 0.08), lean * Vector3(0, h * 0.72, 0), "wood", lean)
	_add_box_shape(root, Vector3(0.3, h, 0.3), Vector3(0, h / 2, 0))
	return root


static func pedra(rng: RandomNumberGenerator) -> Node3D:
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


static func arvore_seca(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	var height := rng.randf_range(2.0, 3.2)
	_add_cylinder(root, 0.14, height, Vector3(0, height / 2, 0), "dry_wood", 6)
	_branch(root, rng, Vector3(0, height, 0), Vector3.UP, height * 0.6, 0.1, 3)
	_add_box_shape(root, Vector3(0.35, height, 0.35), Vector3(0, height / 2, 0))
	return root


static func poco(rng: RandomNumberGenerator) -> Node3D:
	var root := _static_body()
	for i in 12:
		var a := TAU * i / 12.0
		_add_box(root, Vector3(0.5, rng.randf_range(0.7, 0.85), 0.3), Vector3(cos(a), 0.4, sin(a)) * Vector3(1.0, 1.0, 1.0), "stone", Basis(Vector3.UP, -a + PI / 2))
	for x in [-1.1, 1.1]:
		_add_box(root, Vector3(0.12, 2.0, 0.12), Vector3(x, 1.0, 0), "wood")
	_add_cylinder(root, 0.06, 2.4, Vector3(0, 1.85, 0), "wood", 6, Basis(Vector3.FORWARD, PI / 2))
	_add_cylinder(root, 1.25, 0.8, Vector3(0, 0.4, 0), "", 12, Basis.IDENTITY, true)
	return root


static func lampiao(_rng: RandomNumberGenerator) -> Node3D:
	var root := Node3D.new()
	_add_box(root, Vector3(0.16, 0.04, 0.16), Vector3(0, 0.02, 0), "iron")
	_add_cylinder(root, 0.07, 0.18, Vector3(0, 0.13, 0), "flame", 8)
	_add_box(root, Vector3(0.12, 0.03, 0.12), Vector3(0, 0.24, 0), "iron")
	var light := OmniLight3D.new()
	light.light_color = COLORS["flame"]
	light.light_energy = 2.5
	light.omni_range = 7.0
	light.position.y = 0.15
	light.set_script(load("res://world/sertao/flicker.gd"))
	root.add_child(light)
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
