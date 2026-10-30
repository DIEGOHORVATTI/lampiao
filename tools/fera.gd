extends Node


func _ready() -> void:
	var level: Node = load("res://world/sertao/sertao.tscn").instantiate()
	add_child(level)
	await get_tree().create_timer(1.0).timeout
	for i in 3:
		var corpo: Node3D = load("res://enemies/corpo_seco.tscn").instantiate()
		level.add_child(corpo)
		corpo.global_position = Global.player.global_position + Vector3(-2.5 + i * 2.5, -0.9, -4.0 - i * 6.0)
		corpo.character_root.rotation.y = PI
	await get_tree().create_timer(1.2).timeout
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
