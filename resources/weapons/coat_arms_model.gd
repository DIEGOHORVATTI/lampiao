extends RefCounted

const SOURCE := "res://resources/player/fps_demo_arms.glb"
const MESH_NODE := "Armature/Skeleton3D/fps_arms_extended"
const HAND_BONES := ["hand", "thumb", "index", "middle", "ring", "pink", "Holder"]
const SKIN := Color(0.45, 0.29, 0.19)
const COAT := Color(0.15, 0.13, 0.12)


static func build(material: Material) -> ArrayMesh:
	var scene: Node = load(SOURCE).instantiate()
	var source: MeshInstance3D = scene.get_node(MESH_NODE)
	var skeleton: Skeleton3D = scene.get_node("Armature/Skeleton3D")
	var arrays := source.mesh.surface_get_arrays(0)
	var hand_weight := _hand_weights(arrays, _hand_bone_ids(skeleton))
	var mesh := ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, _colored_faces(arrays, hand_weight), [], {}, source.mesh.surface_get_format(0) & Mesh.ARRAY_FLAG_USE_8_BONE_WEIGHTS)
	mesh.surface_set_material(0, material)
	scene.free()
	return mesh


static func _hand_bone_ids(skeleton: Skeleton3D) -> Array[int]:
	var ids: Array[int] = []
	for i in skeleton.get_bone_count():
		for prefix in HAND_BONES:
			if skeleton.get_bone_name(i).begins_with(prefix):
				ids.append(i)
	return ids


static func _hand_weights(arrays: Array, hand_ids: Array[int]) -> PackedFloat32Array:
	var bones: PackedInt32Array = arrays[Mesh.ARRAY_BONES]
	var weights: PackedFloat32Array = arrays[Mesh.ARRAY_WEIGHTS]
	var count: int = arrays[Mesh.ARRAY_VERTEX].size()
	var per_vertex := bones.size() / count
	var result := PackedFloat32Array()
	result.resize(count)
	for v in count:
		for k in per_vertex:
			if bones[v * per_vertex + k] in hand_ids:
				result[v] += weights[v * per_vertex + k]
	return result


static func _colored_faces(arrays: Array, hand_weight: PackedFloat32Array) -> Array:
	var indices: PackedInt32Array = arrays[Mesh.ARRAY_INDEX]
	var order := PackedInt32Array()
	var colors := PackedColorArray()
	for f in range(0, indices.size(), 3):
		var color := _face_color([hand_weight[indices[f]], hand_weight[indices[f + 1]], hand_weight[indices[f + 2]]])
		for k in 3:
			order.append(indices[f + k])
			colors.append(color)
	var out := []
	out.resize(Mesh.ARRAY_MAX)
	for slot in [Mesh.ARRAY_VERTEX, Mesh.ARRAY_NORMAL, Mesh.ARRAY_TEX_UV]:
		out[slot] = _gather(arrays[slot], order, 1)
	var per_vertex: int = arrays[Mesh.ARRAY_BONES].size() / arrays[Mesh.ARRAY_VERTEX].size()
	out[Mesh.ARRAY_BONES] = _gather(arrays[Mesh.ARRAY_BONES], order, per_vertex)
	out[Mesh.ARRAY_WEIGHTS] = _gather(arrays[Mesh.ARRAY_WEIGHTS], order, per_vertex)
	out[Mesh.ARRAY_COLOR] = colors
	return out


static func _gather(source: Variant, order: PackedInt32Array, stride: int) -> Variant:
	var result: Variant = source.duplicate()
	result.resize(order.size() * stride)
	for n in order.size():
		for k in stride:
			result[n * stride + k] = source[order[n] * stride + k]
	return result


static func _face_color(weights: Array) -> Color:
	var average: float = (weights[0] + weights[1] + weights[2]) / 3.0
	return SKIN if average > 0.5 else COAT
