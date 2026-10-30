extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 4
	d.lock_player(true)
	await Dialogue.fade(1.0, 2.0)
	d.cast.vini.visible = false
	Scares.face_rect.texture = load("res://resources/ui/sustos/lua.jpg")
	Scares.face_rect.modulate.a = 0.0
	Scares.face_rect.scale = Vector2.ONE
	Scares.face_rect.visible = true
	await d.create_tween().tween_property(Scares.face_rect, "CH01_POISON_01", 1.0, 2.0).finished
	await d.create_tween().tween_property(Scares.face_rect, "scale", Vector2.ONE * 1.25, 4.0).finished
	Scares.face_rect.visible = false
	Scares.jumpscare("maria")
	await d.get_tree().create_timer(0.5).timeout
	for key in ["SPEAKER_MARIA", "barauna", "xexeu"]:
		d.cast[key].lie_down()
	Dialogue.fade(0.0, 0.8)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_POISON_02"], ["", "CH01_POISON_03"], ["SPEAKER_LAMPIAO", "CH01_POISON_04"]])
	d.lock_player(false)
	d.set_poisoned(true)
	await d.interactable("Maria", "CH01_POISON_05").used
	await Dialogue.say([["SPEAKER_MARIA", "CH01_POISON_06"], ["", "CH01_POISON_07"], ["SPEAKER_XEXEU", "CH01_POISON_08"]])
	var colonel := d.spawn_npc("ColonelAtMouth", d.SUIT, "kepi", false)
	await Dialogue.say([["SPEAKER_CORONEL", "CH01_POISON_09"], ["SPEAKER_LAMPIAO", "CH01_POISON_10"]])
	colonel.queue_free()
	var put_out := [false]
	var campfire_switch := d.interactable("Campfire", "CH01_POISON_11")
	campfire_switch.used.connect(func():
		put_out[0] = true
		Scares.blackout(4.0, 9999.0))
	for i in 2:
		d.spawn_soldier("MouthSoldier_%d" % (i + 1), 0.3, 1.6).alert(d.marker("Campfire"), 1.0)
	await d.get_tree().create_timer(6.0).timeout
	if not put_out[0]:
		Scares.blackout(4.0, 9999.0)
	await d.wait_until(func(): return d.alive_soldiers() == 0, 60.0)
	d.cast.vini.visible = true
	d.cast.vini.global_position = d.marker("Rockfall_1") + Vector3(-1, 0, -3)
	d.set_vini_torch(true)
	await Dialogue.say([["SPEAKER_VINI", "CH01_POISON_12"], ["SPEAKER_LAMPIAO", "CH01_POISON_13"]])
	await d.await_trigger("RockfallTrigger")
	d.rockfall("Rockfall_1", 5)
