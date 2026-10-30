extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 10
	d.trigger("ScareSlabBreathing").entered.connect(func():
		Scares.sound_behind("breathing", 2.5)
		await d.get_tree().create_timer(3.0).timeout
		await Dialogue.say([["SPEAKER_SOLDADO", "CH01_CREVICE_01"]])
		for i in 2:
			d.spawn_soldier("ReturnSoldier_%d" % (i + 1), 0.35, 1.8).alert(Global.player.global_position, 1.0))
	d.interactable("TorchPickup", "CH01_CREVICE_02").used.connect(d.pick_up_torch)
	d.trigger("ScareFootsteps").entered.connect(func():
		await d.get_tree().create_timer(8.0).timeout
		Scares.sound_behind("footsteps"))
	d.trigger("ScareEatenSoldier").entered.connect(func(): Scares.jumpscare("eaten_soldier"))
	d.trigger("ScareKnock").entered.connect(func():
		for i in 3:
			Scares.sound_behind("knock", 4.0)
			await d.get_tree().create_timer(1.1).timeout)
	d.trigger("RosaryTrigger").entered.connect(func():
		_teach_rosary(d)
		for i in 4:
			var soldier := d.spawn_soldier("CreviceSoldier_%d" % (i + 1), 0.4, 0.0)
			soldier.vision_range = 14.0)
	await d.await_trigger("BeneditoTrigger")


func _teach_rosary(d: Chapter01Director) -> void:
	Dialogue.show_prompt("CH01_CREVICE_01")
	await d.wait_until(func(): return Powers.rosary_active, 30.0)
	Dialogue.hide_prompt()
	Dialogue.say([["SPEAKER_ELA", "CH01_CREVICE_02"]])
