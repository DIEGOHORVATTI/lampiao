extends RefCounted

var tool := SurfaceTool.new()
var points := PackedVector3Array()


func _init() -> void:
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)


func commit(material: Material) -> ArrayMesh:
	tool.generate_normals()
	var mesh := tool.commit()
	mesh.surface_set_material(0, material)
	return mesh


static func station(center: Vector3, basis: Basis, radius: Vector2, influences: Dictionary) -> Dictionary:
	return {"center": center, "basis": basis.orthonormalized(), "radius": radius, "influences": influences}


func limb(stations: Array[Dictionary], segments: int, color: Color, wobble: float = 0.0, closed: bool = false) -> void:
	var first := points.size()
	for k in stations.size():
		_ring(stations[k], segments, color, wobble * float(k % 2 * 2 - 1))
	for k in stations.size() - 1:
		var reference: Vector3 = (stations[k].center + stations[k + 1].center) * 0.5
		for i in segments:
			var j := (i + 1) % segments
			var near := first + k * segments
			var far := near + segments
			_triangle(near + i, near + j, far + j, reference)
			_triangle(near + i, far + j, far + i, reference)
	if closed:
		_cap(stations[0], first, segments, color, stations[1].center)


func _cap(spec: Dictionary, first: int, segments: int, color: Color, reference: Vector3) -> void:
	var center := points.size()
	_vertex(spec.center, spec.influences, color)
	for i in segments:
		_triangle(center, first + i, first + (i + 1) % segments, reference)


func _ring(spec: Dictionary, segments: int, color: Color, wobble: float) -> void:
	var basis: Basis = spec.basis
	var radius: Vector2 = spec.radius
	for i in segments:
		var angle := TAU * i / segments
		var fold := 1.0 + wobble * sin(angle * 3.0 + spec.center.x * 40.0)
		var offset: Vector3 = basis.x * cos(angle) * radius.x + basis.z * sin(angle) * radius.y
		_vertex(spec.center + offset * fold, spec.influences, color)


func _vertex(point: Vector3, influences: Dictionary, color: Color) -> void:
	var bones := PackedInt32Array([0, 0, 0, 0])
	var weights := PackedFloat32Array([0.0, 0.0, 0.0, 0.0])
	var total := 0.0
	for weight in influences.values():
		total += weight
	var slot := 0
	for bone in influences:
		bones[slot] = bone
		weights[slot] = influences[bone] / total
		slot += 1
	tool.set_color(color)
	tool.set_bones(bones)
	tool.set_weights(weights)
	tool.add_vertex(point)
	points.append(point)


func _triangle(a: int, b: int, c: int, reference: Vector3) -> void:
	var normal := (points[b] - points[a]).cross(points[c] - points[a])
	var outward := (points[a] + points[b] + points[c]) / 3.0 - reference
	var order := [a, c, b] if normal.dot(outward) > 0.0 else [a, b, c]
	for index in order:
		tool.add_index(index)
