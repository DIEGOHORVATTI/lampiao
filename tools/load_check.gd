extends Node


func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	preload("res://ui/carregamento.gd").go(get_tree(), "res://world/sertao/sertao.tscn")
	await get_tree().create_timer(1.2).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/carregando.png")
	await get_tree().create_timer(5.0).timeout
	print("cena atual: ", get_tree().current_scene.name if get_tree().current_scene else "nenhuma")
	get_tree().quit()
