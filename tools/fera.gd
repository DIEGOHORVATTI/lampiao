extends Node


func _ready() -> void:
	var level: Node = load("res://world/sertao/sertao.tscn").instantiate()
	add_child(level)
	await get_tree().create_timer(1.0).timeout
	var corpo: Node3D = load("res://enemies/corpo_seco.tscn").instantiate()
	level.add_child(corpo)
	corpo.global_position = Global.player.global_position + Vector3(0.5, -0.9, -3.5)
	corpo.character_root.rotation.y = PI
	await get_tree().create_timer(0.8).timeout
	Global.player.camera_pivot.look_at(corpo.global_position, Vector3.UP)
	await get_tree().create_timer(0.01).timeout
	await get_tree().create_timer(0.2).timeout
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
