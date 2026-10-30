extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 3
	d.lock_player(true)
	await Dialogue.fade(1.0, 0.6)
	d.clear_soldiers()
	for key in d.cast:
		d.cast[key].queue_free()
	d.cast.clear()
	d.set_hud_visible(false)
	d.teleport_player("ColonelAtMouth", 180.0)
	d.gallop_camera()
	await Dialogue.say([
		["", "CH01_RIDE_01"],
		["", "CH01_RIDE_02"],
		["SPEAKER_LAMPIAO", "CH01_RIDE_03"],
		["", "CH01_RIDE_04"],
	])
	d.galloping = false
	await Dialogue.fade(0.0, 1.5)
	await Dialogue.say([["", "CH01_RIDE_05"], ["", "CH01_RIDE_06"]])
