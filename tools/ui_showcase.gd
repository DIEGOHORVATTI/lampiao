extends Node


func _ready() -> void:
	add_child(load("res://game/ui/menu.tscn").instantiate())
	await get_tree().create_timer(1.0).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/ui-menu.png")
	add_child(SettingsMenu.new())
	await get_tree().create_timer(0.6).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/ui-settings.png")
	GameUI.set_paused(true)
	await get_tree().create_timer(0.6).timeout
	get_viewport().get_texture().get_image().save_png("/tmp/claude-1000/ui-pause.png")
	get_tree().paused = false
	get_tree().quit()
