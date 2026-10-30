extends Node

const OUT := "/tmp/claude-1000/lampeao-ui"
const SIZES := [Vector2i(1920, 1080), Vector2i(2340, 1080)]

var view: SubViewport


func _ready() -> void:
	DirAccess.make_dir_recursive_absolute(OUT)
	view = SubViewport.new()
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	add_child(view)
	for size in SIZES:
		view.size = size
		await _shots("%dx%d" % [size.x, size.y])
	get_tree().quit()


func _shots(tag: String) -> void:
	var menu: Control = load("res://game/ui/menu.tscn").instantiate()
	await _shot(menu, tag + "-menu", 0.8, false)
	var settings := SettingsMenu.new()
	menu.add_child(settings)
	await _snap(tag + "-settings", 0.5)
	menu.queue_free()
	var pause := PauseMenu.new()
	await _shot(pause, tag + "-pause", 0.5)
	var death := DeathScreen.new()
	view.add_child(death)
	death.show_message("UI_DEATH_HUNGER")
	await _snap(tag + "-death", 0.5)
	death.queue_free()
	for pick in 3:
		var screen: Control = load("res://game/ui/loading_screen.tscn").instantiate()
		screen.next_scene = "res://game/ui/menu.tscn"
		seed(_seed_for(pick))
		await _shot(screen, "%s-loading%d" % [tag, pick + 1], 0.6)
	var hud := _hud()
	await _shot(hud, tag + "-hud", 0.5)


func _hud() -> Control:
	var root := ColorRect.new()
	root.color = Color(0.18, 0.14, 0.1)
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	var objective: Label = GameUI.objective_label.duplicate()
	objective.text = tr("CH01_GOAL_FIGHT")
	root.add_child(objective)
	var subtitle: Label = Dialogue.subtitle.duplicate()
	subtitle.text = "%s: %s" % [tr("SPEAKER_LAMPIAO"), tr("UI_DEATH_DEFAULT")]
	subtitle.add_theme_color_override("font_color", Dialogue.SPEAKER_COLORS.SPEAKER_LAMPIAO)
	root.add_child(subtitle)
	var card: Label = Dialogue.card.duplicate()
	card.text = tr("UI_TITLE")
	root.add_child(card)
	var choice := TextureRect.new()
	choice.texture = Dialogue.CHOICE_NORMAL
	choice.position = Vector2(300, 640)
	root.add_child(choice)
	var lit := TextureRect.new()
	lit.texture = Dialogue.CHOICE_PRESSED
	lit.position = Vector2(960, 640)
	root.add_child(lit)
	return root


func _seed_for(pick: int) -> int:
	for candidate in 200:
		seed(candidate)
		if randi() % 3 == pick:
			return candidate
	return 0


func _shot(node: Control, name: String, wait: float, free_after := true) -> void:
	view.add_child(node)
	await _snap(name, wait)
	if free_after:
		node.queue_free()


func _snap(name: String, wait: float) -> void:
	await get_tree().create_timer(wait).timeout
	await RenderingServer.frame_post_draw
	view.get_texture().get_image().save_png("%s/%s.png" % [OUT, name])
