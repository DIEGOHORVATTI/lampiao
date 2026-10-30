extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 0
	d.start_cinematic()
	var view := d.marker("OpeningView")
	var manor := d.marker("RoomDoor")
	d.cut(view + Vector3(0, 0.6, 0), manor + Vector3.UP * 4.0)
	d.dolly(view + Vector3(0, 0.9, -6), manor + Vector3.UP * 3.0, 16.0)
	await Dialogue.fade(0.0, 2.5)
	for i in 6:
		Effects.gunshot(d, d.marker("Guard") + Vector3.UP * 2.0)
		await d.get_tree().create_timer(0.18).timeout
	await Dialogue.say([["", "CH01_OPENING_01"], ["", "CH01_OPENING_02"], ["", "CH01_OPENING_03"]])
	await Dialogue.fade(1.0, 1.2)
	await Dialogue.show_card("CH01_OPENING_CARD", 3.0)
