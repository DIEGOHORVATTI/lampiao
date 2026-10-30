extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 3
	await Dialogue.fade(1.0, 0.4)
	d.teleport_player("LampiaoMat", 180.0)
	d.cast.maria = d.spawn_npc("Maria", Color(0.35, 0.27, 0.2), "beret", false)
	d.cast.maria.lie_down()
	d.cast.barauna = d.spawn_npc("Barauna", d.LEATHER, "half_moon")
	d.cast.barauna.pose("Sitting_Idle")
	d.cast.xexeu = d.spawn_npc("Xexeu", d.LEATHER.darkened(0.2), "half_moon")
	d.cast.xexeu.pose("Crouch_Idle")
	d.cast.vini = d.spawn_npc("Vini", Color(0.5, 0.48, 0.4), "beret", false)
	d.cast.vini.global_position = d.marker("Campfire") + Vector3(0.9, 0, 0.9)
	for key in ["SPEAKER_BARAUNA", "xexeu", "vini"]:
		d.cast[key].look_at_point(d.marker("Campfire"), 0.01)
	await Dialogue.fade(0.0, 1.5)
	d.lock_player(false)
	d.add_talk(d.cast.xexeu, [["SPEAKER_XEXEU", "CH01_CAMP_01"], ["SPEAKER_LAMPIAO", "CH01_CAMP_02"]])
	d.add_talk(d.cast.barauna, [["SPEAKER_BARAUNA", "CH01_CAMP_03"], ["SPEAKER_BARAUNA", "CH01_CAMP_04"]])
	d.add_talk(d.cast.vini, [["SPEAKER_VINI", "CH01_CAMP_05"], ["", "CH01_CAMP_06"]])
	d.interactable("Idol", "CH01_CAMP_07").used.connect(func():
		Scares.sound_behind("breathing", 2.0)
		await d.get_tree().create_timer(2.5).timeout
		Scares.apparition(6.0, 1.2))
	await d.interactable("Maria", "CH01_CAMP_08").used
	await Dialogue.say([
		["SPEAKER_MARIA", "CH01_CAMP_09"],
		["SPEAKER_LAMPIAO", "CH01_CAMP_10"],
		["SPEAKER_MARIA", "CH01_CAMP_11"],
		["SPEAKER_LAMPIAO", "CH01_CAMP_12"],
		["SPEAKER_MARIA", "CH01_CAMP_13"],
	])
	Story.set_flag("rosary", "wrist")
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_CAMP_14"],
		["SPEAKER_BARAUNA", "CH01_CAMP_15"],
		["SPEAKER_VINI", "CH01_CAMP_16"],
	])
	d.cast.vini.walk_to(d.marker("Vini"), 1.4)
	await Dialogue.say([["SPEAKER_VINI", "CH01_CAMP_17"]])
	await d.interactable("SoupBowl", "CH01_CAMP_18").used
