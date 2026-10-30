extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 5
	d.trigger("ScareGalleryApparition").entered.connect(func(): Scares.apparition(7.0, 1.0))
	d.trigger("ScareWhisper").entered.connect(func():
		Scares.sound_behind("whisper", 1.0)
		Dialogue.say([["", "CH01_GALLERY_01"]]))
	var spawned := false
	for point in ["ViniPath_1", "ViniPath_2", "ViniPath_3", "ViniPath_4", "ViniHall"]:
		await d.wait_until(func(): return Global.player.global_position.distance_to(d.cast.vini.global_position) < 7.0, 120.0)
		await d.cast.vini.walk_to(d.marker(point), 1.8)
		if point == "ViniPath_2" and not spawned:
			spawned = true
			for i in 2:
				d.spawn_soldier("GallerySoldier_%d" % (i + 1), 0.3, 1.8).alert(Global.player.global_position, 1.0)
	await d.wait_until(func(): return d.alive_soldiers() == 0, 90.0)
	d.rockfall("Rockfall_2", 6)
	await d.await_trigger("HallTrigger")
	d.set_poisoned(false)
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_GALLERY_02"],
		["SPEAKER_VINI", "CH01_GALLERY_03"],
		["SPEAKER_LAMPIAO", "CH01_GALLERY_04"],
		["SPEAKER_VINI", "CH01_GALLERY_05"],
	])
