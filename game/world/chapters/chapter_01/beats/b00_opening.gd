extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 0
	d.set_hud_visible(false)
	d.teleport_player("OpeningView", 0.0)
	d.face_player_to("RoomDoor")
	var approach := d.create_tween()
	approach.tween_property(Global.player, "global_position", Global.player.global_position + Vector3(0, 0, -4), 14.0)
	await Dialogue.fade(0.0, 2.5)
	for i in 6:
		Effects.gunshot(d, d.marker("Guard") + Vector3.UP * 2.0)
		await d.get_tree().create_timer(0.18).timeout
	await Dialogue.say([["", "CH01_OPENING_01"], ["", "CH01_OPENING_02"], ["", "CH01_OPENING_03"]])
	await Dialogue.fade(1.0, 1.2)
	approach.kill()
	await Dialogue.show_card("CH01_OPENING_CARD", 3.0)
