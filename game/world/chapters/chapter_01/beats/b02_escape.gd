extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 2
	d.lock_player(true)
	await Dialogue.fade(1.0, 0.6)
	for soldier in d.soldiers:
		if is_instance_valid(soldier):
			soldier.queue_free()
	d.soldiers.clear()
	for key in d.cast:
		d.cast[key].queue_free()
	d.cast.clear()
	d.teleport_player("ColonelAtMouth", 180.0)
	d.gallop_camera()
	await Dialogue.say([
		["", "CH01_ESCAPE_01"],
		["SPEAKER_VINI", "CH01_ESCAPE_02"],
		["SPEAKER_BARAUNA", "CH01_ESCAPE_03"],
		["SPEAKER_LAMPIAO", "CH01_ESCAPE_04"],
	])
	await Dialogue.fade(0.0, 1.5)
	await Dialogue.say([["", "CH01_ESCAPE_05"], ["SPEAKER_VINI", "CH01_ESCAPE_06"]])
