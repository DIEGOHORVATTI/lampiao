extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 3
	await Dialogue.fade(1.0, 0.6)
	for key in d.cast:
		d.cast[key].queue_free()
	d.cast.clear()
	var mouth := d.marker("ColonelAtMouth")
	var arch := d.marker("Campfire")
	d.cut(mouth + Vector3(0, 1.8, -22), arch + Vector3.UP * 2.0)
	d.gallop_camera()
	d.dolly(mouth + Vector3(0, 1.8, -8), arch + Vector3.UP * 2.0, 14.0)
	await Dialogue.fade(0.0, 1.0)
	await Dialogue.say([
		["", "CH01_RIDE_01"],
		["", "CH01_RIDE_02"],
		["SPEAKER_LAMPIAO", "CH01_RIDE_03"],
		["", "CH01_RIDE_04"],
	])
	await Dialogue.fade(1.0, 0.8)
	d.galloping = false
	d.cut(mouth + Vector3(4, 1.2, -6), arch + Vector3.UP * 3.0)
	await Dialogue.fade(0.0, 1.5)
	await Dialogue.say([["", "CH01_RIDE_05"]])
	await d.dolly(mouth + Vector3(1, 1.6, 2), arch + Vector3.UP * 1.5, 4.0)
	await Dialogue.say([["", "CH01_RIDE_06"]])
	await Dialogue.fade(1.0, 1.0)
	d.end_cinematic()
