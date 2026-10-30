extends Node


func _ready() -> void:
	add_child(load("res://game/world/sandbox/sandbox.tscn").instantiate())
	await get_tree().create_timer(1.5).timeout
	Pact.hunger = float(OS.get_environment("FOME")) if OS.has_environment("FOME") else 30.0
	if OS.has_environment("DANO"):
		Global.player.get_damage(float(OS.get_environment("DANO")), Vector3.ZERO)
	Global.reload_input.emit()
	if OS.has_environment("SEM_VINHETA"):
		GameUI.overlay.visible = false
	if OS.has_environment("SEM_HUD"):
		find_child("HUD", true, false).visible = false
	await get_tree().create_timer(0.6).timeout
	get_viewport().get_texture().get_image().save_png(OS.get_environment("SHOT"))
	get_tree().quit()
