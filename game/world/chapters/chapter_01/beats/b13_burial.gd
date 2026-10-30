extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 13
	var sunrise := d.create_tween().set_parallel()
	sunrise.tween_property(d.environment, "background_color", Color(0.55, 0.42, 0.32), 12.0)
	sunrise.tween_property(d.environment, "ambient_light_energy", 1.1, 12.0)
	sunrise.tween_property(d.environment, "fog_light_color", Color(0.6, 0.45, 0.35), 12.0)
	d.trigger("ScareMariaApparition").entered.connect(func():
		var vision := d.spawn_npc("DeadTree", Color(0.35, 0.27, 0.2), "beret", false)
		d.get_tree().create_timer(0.7).timeout.connect(vision.queue_free))
	var graves := [0]
	for i in 3:
		var marker := "Grave_%d" % (i + 1)
		var area := d.interactable(marker, "UI_DIG")
		area.used.connect(func():
			await Dialogue.hold("CH01_BURIAL_01", 3.0)
			_dig_grave(d, marker)
			graves[0] += 1)
	d.interactable("GraveVini", "CH01_BURIAL_02").used.connect(func():
		await Dialogue.hold("CH01_BURIAL_03", 3.0)
		_dig_grave(d, "GraveVini")
		Story.set_flag("vini", "buried"))
	await d.wait_until(func(): return graves[0] >= 3, 600.0)
	d.lock_player(true)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_BURIAL_04"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_05"],
		["", "CH01_BURIAL_06"],
		["SPEAKER_ELA", "CH01_BURIAL_07"],
		["SPEAKER_ELA", "CH01_BURIAL_08"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_09"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_10"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_11"],
		["SPEAKER_ELA", "CH01_BURIAL_BLEH"],
		["SPEAKER_LAMPIAO", "CH01_BURIAL_12"],
	])
	Story.set_flag("rosary", "neck")
	await Dialogue.fade(1.0, 2.0)
	await Dialogue.show_card("CH01_BURIAL_13", 3.0)
	Story.chapter = 2
	Story.save_game()
	Dialogue.clear()
	Pact.hunger_enabled = true
	Pact.stop()
	d.get_tree().change_scene_to_file("res://game/ui/menu.tscn")


func _dig_grave(d: Chapter01Director, marker: String) -> void:
	var grave: Node3D = PropLibrary.build("grave", RandomNumberGenerator.new())
	d.add_child(grave)
	grave.global_position = d.marker(marker)
