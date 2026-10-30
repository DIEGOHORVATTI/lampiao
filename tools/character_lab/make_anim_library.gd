extends SceneTree


func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var source: Node = load(args[0]).instantiate()
	var player: AnimationPlayer = source.find_children("*", "AnimationPlayer", true, false)[0]
	var library := AnimationLibrary.new()
	for anim_name in player.get_animation_list():
		var anim: Animation = player.get_animation(anim_name).duplicate(true)
		anim.compress()
		library.add_animation(anim_name, anim)
	var err := ResourceSaver.save(library, args[1])
	print("SAVED ", args[1], " ", library.get_animation_list().size(), " err=", err)
	source.free()
	quit()
