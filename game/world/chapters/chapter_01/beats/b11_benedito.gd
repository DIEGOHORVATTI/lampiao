extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 11
	var prisoner := d.spawn_npc("BeneditoNiche", d.UNIFORM, "kepi", false)
	prisoner.pose("Sitting_Idle")
	await prisoner.look_at_point(Global.player.global_position, 0.1)
	var spared := Story.flag("farm_benedito") != "killed"
	var speaker := "BENEDITO" if spared else "SOLDADO"
	var lines := []
	if spared:
		lines.append(["SPEAKER_BENEDITO", "CH01_BENEDITO_01"])
	else:
		lines.append(["SPEAKER_SOLDADO", "CH01_BENEDITO_02"])
	lines.append_array([
		["SPEAKER_LAMPIAO", "CH01_BENEDITO_03"],
		[speaker, "CH01_BENEDITO_04"],
		["SPEAKER_ELA", "CH01_BENEDITO_05"],
		[speaker, "CH01_BENEDITO_06"],
	])
	await Dialogue.say(lines)
	var choice := await Dialogue.choose(["SPEAKER_GUARDAR_A_PEIXEIRA", "CH01_BENEDITO_07"], d.BENEDITO_TIMEOUT, func():
		Pact.hunger = minf(99.0, Pact.hunger + 10.0)
		Dialogue.say([["SPEAKER_ELA", "CH01_BENEDITO_08"]]))
	if choice == 0:
		Story.set_flag("benedito", "spared")
		prisoner.walk_to(d.marker("CreviceExitTrigger"), 2.0, true)
		await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_BENEDITO_09"], ["SPEAKER_ELA", "CH01_BENEDITO_10"]])
		prisoner.queue_free()
	else:
		Story.set_flag("benedito", "eaten")
		Story.add_mark()
		await Dialogue.fade(1.0, 0.25, Color(0.2, 0.0, 0.0))
		prisoner.queue_free()
		await Dialogue.say([["", "CH01_BENEDITO_11"]])
		Pact.feed(100.0)
		Pact.heal(100.0)
		await Dialogue.fade(0.0, 1.0)
		await Dialogue.say([["SPEAKER_ELA", "CH01_BENEDITO_12"]])
	await d.await_trigger("CreviceExitTrigger")
