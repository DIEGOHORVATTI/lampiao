extends SceneTree


func _init() -> void:
	var paths := OS.get_cmdline_user_args()
	for path in paths:
		var root: Node = load(path).instantiate()
		print("SCENE ", path)
		_dump(root, root, 1)
		var players := root.find_children("*", "AnimationPlayer", true, false)
		if players.size() > 0:
			var anim: AnimationPlayer = players[0]
			var names := anim.get_animation_list()
			print("  ANIMS ", names.size(), " ", ",".join(names))
			if anim.has_animation("Idle"):
				print("  IDLE_LOOP ", anim.get_animation("Idle").loop_mode, " TRACK0 ", anim.get_animation("Idle").track_get_path(0))
		root.free()
	quit()


func _dump(node: Node, root: Node, depth: int) -> void:
	if depth > 4:
		return
	var extra := ""
	if node is MeshInstance3D:
		extra = " surfaces=%d" % node.mesh.get_surface_count()
	if node is Skeleton3D:
		extra = " bones=%d" % node.get_bone_count()
	print("  ".repeat(depth), node.name, " [", node.get_class(), "]", extra)
	for child in node.get_children():
		_dump(child, root, depth + 1)
