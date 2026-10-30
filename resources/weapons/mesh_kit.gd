extends RefCounted

const GRAIN_SCALE := 6.0

var tool := SurfaceTool.new()
var color := Color.WHITE
var xform := Transform3D.IDENTITY


func _init() -> void:
	tool.begin(Mesh.PRIMITIVE_TRIANGLES)


func commit_into(mesh: ArrayMesh, material: Material) -> void:
	tool.index()
	tool.commit(mesh)
	mesh.surface_set_material(mesh.get_surface_count() - 1, material)


func box(center: Vector3, size: Vector3) -> void:
	var half := size * 0.5
	var corners := PackedVector3Array()
	for i in 8:
		corners.append(center + Vector3(half.x * _sign(i & 1), half.y * _sign(i & 2), half.z * _sign(i & 4)))
	hexahedron(corners)


func block(z_back: float, z_front: float, back: Rect2, front: Rect2) -> void:
	var corners := PackedVector3Array()
	for i in 8:
		var rect := front if i & 4 else back
		var x := rect.position.x + (rect.size.x if i & 1 else 0.0)
		var y := rect.position.y + (rect.size.y if i & 2 else 0.0)
		corners.append(Vector3(x, y, z_front if i & 4 else z_back))
	hexahedron(corners)


func hexahedron(corners: PackedVector3Array) -> void:
	var inner := Vector3.ZERO
	for c in corners:
		inner += c / 8.0
	for face in [[1, 3, 7, 5], [0, 4, 6, 2], [2, 6, 7, 3], [0, 1, 5, 4], [4, 5, 7, 6], [0, 2, 3, 1]]:
		quad(corners[face[0]], corners[face[1]], corners[face[2]], corners[face[3]], inner)


func tube(center: Vector2, radius: Vector2, z_from: float, z_to: float, segments: int = 10) -> void:
	var near := _ring(center, radius, z_from, segments)
	var far := _ring(center, radius, z_to, segments)
	var axis_mid := Vector3(center.x, center.y, (z_from + z_to) * 0.5)
	for i in segments:
		var j := (i + 1) % segments
		var normals := PackedVector3Array([_radial(near[i], center, radius), _radial(near[j], center, radius), _radial(far[j], center, radius), _radial(far[i], center, radius)])
		polygon(PackedVector3Array([near[i], near[j], far[j], far[i]]), axis_mid, normals)
	polygon(near, axis_mid)
	polygon(far, axis_mid)


func loft(sections: Array[PackedVector3Array], cap_ends: bool = true) -> void:
	for k in sections.size() - 1:
		var a := sections[k]
		var b := sections[k + 1]
		var inner := (_centroid(a) + _centroid(b)) * 0.5
		for i in a.size():
			var j := (i + 1) % a.size()
			polygon(PackedVector3Array([a[i], a[j], b[j], b[i]]), inner)
	if cap_ends:
		polygon(sections[0], _centroid(sections[1]))
		polygon(sections[-1], _centroid(sections[-2]))


func quad(a: Vector3, b: Vector3, c: Vector3, d: Vector3, inner: Vector3) -> void:
	polygon(PackedVector3Array([a, b, c, d]), inner)


func polygon(points: PackedVector3Array, inner: Vector3, normals: PackedVector3Array = PackedVector3Array()) -> void:
	var flat := _face_normal(points)
	if flat.dot(_centroid(points) - inner) < 0.0:
		points.reverse()
		normals.reverse()
		flat = -flat
	for i in range(1, points.size() - 1):
		for k in [0, i + 1, i]:
			_vertex(points[k], normals[k] if normals.size() > k else flat, flat)


func _vertex(point: Vector3, normal: Vector3, flat: Vector3) -> void:
	tool.set_color(color)
	tool.set_normal((xform.basis * normal).normalized())
	tool.set_uv(_grain_uv(point, flat))
	tool.add_vertex(xform * point)


func _grain_uv(point: Vector3, flat: Vector3) -> Vector2:
	var n := flat.abs()
	if n.x >= n.y and n.x >= n.z:
		return Vector2(point.z, point.y) * GRAIN_SCALE
	if n.y >= n.z:
		return Vector2(point.z, point.x) * GRAIN_SCALE
	return Vector2(point.y, point.x) * GRAIN_SCALE


func _face_normal(points: PackedVector3Array) -> Vector3:
	var normal := Vector3.ZERO
	for i in points.size():
		var p := points[i]
		var q := points[(i + 1) % points.size()]
		normal += Vector3((p.y - q.y) * (p.z + q.z), (p.z - q.z) * (p.x + q.x), (p.x - q.x) * (p.y + q.y))
	return normal.normalized() if normal.length() > 0.0 else Vector3.UP


func _ring(center: Vector2, radius: Vector2, z: float, segments: int) -> PackedVector3Array:
	var ring := PackedVector3Array()
	for i in segments:
		var angle := TAU * i / segments
		ring.append(Vector3(center.x + cos(angle) * radius.x, center.y + sin(angle) * radius.y, z))
	return ring


func _radial(point: Vector3, center: Vector2, radius: Vector2) -> Vector3:
	var offset := Vector2(point.x - center.x, point.y - center.y)
	return Vector3(offset.x / (radius.x * radius.x), offset.y / (radius.y * radius.y), 0.0).normalized()


func _centroid(points: PackedVector3Array) -> Vector3:
	var sum := Vector3.ZERO
	for p in points:
		sum += p
	return sum / points.size()


func _sign(bit: int) -> float:
	return 1.0 if bit else -1.0
