extends RefCounted

const SOLDIERS := 4


func run(d: Chapter01Director) -> void:
	d.beat = 9
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
	for i in SOLDIERS:
		var soldier := d.spawn_soldier("HallSoldier_%d" % (i + 1), 0.6, 0.0)
		soldier.alert(soldier.global_position, 1.0)
		soldier.edible_seconds = 999.0
	d.colonel.global_position = d.marker("ColonelBehind") + Vector3(0, 0, -4)
	d.lock_player(false)
	await Dialogue.fade(0.0, 0.6)
	d.objective("CH01_GOAL_ENTITY")
	await Dialogue.say([["", "CH01_ENTITY_01"], ["SPEAKER_ELA", "CH01_ENTITY_02"], ["SPEAKER_ELA", "CH01_ENTITY_03"]])
	await d.wait_until(func(): return d.alive_soldiers() < SOLDIERS, 120.0)
	await Dialogue.say([["SPEAKER_ELA", "CH01_ENTITY_04"]])
	await _colonel_abandons(d)
	await d.wait_until(func(): return d.alive_soldiers() == 0, 240.0)
	d.objective("")
	await Dialogue.say([["SPEAKER_ELA", "CH01_ENTITY_13"]])
	d.lock_player(true)
	god.queue_free()


func _colonel_abandons(d: Chapter01Director) -> void:
	var alive := d.soldiers.filter(func(s): return is_instance_valid(s) and s.is_alive)
	if not alive.is_empty():
		var dragged: CharacterBody3D = alive.front()
		await Dialogue.say([["SPEAKER_SOLDADO", "CH01_ENTITY_05"], ["SPEAKER_SOLDADO", "CH01_ENTITY_06"]])
		d.colonel.look_at_point(dragged.global_position, 0.1)
		Effects.gunshot(d, d.colonel.global_position + Vector3.UP * 1.4)
		if is_instance_valid(dragged) and dragged.is_alive:
			dragged.die()
	await Dialogue.say([
		["SPEAKER_SOLDADO", "CH01_ENTITY_07"],
		["SPEAKER_SOLDADOS", "CH01_ENTITY_08"],
		["SPEAKER_SOLDADOS", "CH01_ENTITY_09"],
		["SPEAKER_CORONEL", "CH01_ENTITY_10"],
	])
	d.colonel.walk_to(d.marker("ColonelExit") + Vector3(0, 0, -8), 3.0, true)
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_ENTITY_11"], ["SPEAKER_CORONEL", "CH01_ENTITY_12"]])
	d.colonel.queue_free()
