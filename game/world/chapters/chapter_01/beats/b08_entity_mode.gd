extends RefCounted


func run(d: Chapter01Director) -> void:
	var colonel := d.colonel
	d.beat = 8
	Global.player.visible = true
	Global.player.camera.make_current()
	Global.player.camera_pivot.position.y = 1.2
	d.environment.adjustment_enabled = true
	d.environment.adjustment_saturation = 0.08
	d.environment.adjustment_contrast = 1.25
	Powers.entity_mode = true
	Pact.meal_value = 12.0
	Pact.start_level(100.0)
	Pact.hunger_enabled = true
	d.set_hud_visible(true)
	var god := d.start_god_mode()
	for i in 4:
		var soldier := d.spawn_soldier("HallSoldier_%d" % (i + 1), 0.6, 0.0)
		soldier.alert(soldier.global_position, 1.0)
		soldier.edible_seconds = 999.0
	d.lock_player(false)
	await Dialogue.fade(0.0, 0.6)
	await Dialogue.say([["SPEAKER_SOLDADOS", "CH01_ENTITY_01"], ["SPEAKER_ELA", "CH01_ENTITY_02"], ["SPEAKER_ELA", "CH01_ENTITY_03"]])
	Dialogue.show_prompt("CH01_ENTITY_04")
	colonel.look_at_point(Global.player.global_position, 0.1)
	for i in 3:
		Effects.gunshot(d, colonel.global_position + Vector3.UP * 1.4)
		await d.get_tree().create_timer(0.35).timeout
	colonel.walk_to(d.marker("ViniHall") + Vector3(0, 0, -6), 3.0, true)
	d.get_tree().create_timer(3.0).timeout.connect(colonel.queue_free)
	var runaway := d.spawn_npc("HallSoldier_4", d.UNIFORM, "kepi", false)
	runaway.walk_to(d.marker("BeneditoEscape") + Vector3(4, 0, -4), 2.5, true)
	d.get_tree().create_timer(4.0).timeout.connect(runaway.queue_free)
	Dialogue.say([["SPEAKER_SOLDADO", "CH01_ENTITY_05"]])
	await d.wait_until(func(): return d.alive_soldiers() == 0, 240.0)
	Dialogue.hide_prompt()
	await d.wait_until(func(): return Pact.hunger <= 70.0, 60.0)
	await Dialogue.say([["SPEAKER_ELA", "CH01_ENTITY_06"], ["SPEAKER_ELA", "CH01_ENTITY_07"]])
	d.lock_player(true)
	Scares.shake(0.25, 1.6)
	Scares._play(Scares.sounds["stinger"], 6.0)
	for memory in ["CH01_ENTITY_MEMORY_01", "CH01_ENTITY_08", "CH01_ENTITY_09", "CH01_ENTITY_10"]:
		await Dialogue.fade(0.85, 0.08, Color.WHITE)
		Dialogue.subtitle.text = tr(memory)
		await d.get_tree().create_timer(0.6).timeout
		await Dialogue.fade(0.3, 0.08, Color.WHITE)
	Dialogue.subtitle.text = ""
	await Dialogue.fade(1.0, 0.4, Color.WHITE)
	god.queue_free()
	Powers.entity_mode = false
	Pact.meal_value = Pact.HUNGER_PER_MEAL
	d.environment.adjustment_enabled = false
	Global.player.camera_pivot.position.y = 1.7
