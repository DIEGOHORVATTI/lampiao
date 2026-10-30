extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 9
	d.teleport_player("LampiaoDuel", 0.0)
	Pact.hunger = 50.0
	d.spawn_soldier_remains()
	await Dialogue.fade(0.0, 1.5, Color.WHITE)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_AWAKENING_01"],
		["", "CH01_AWAKENING_02"],
		["SPEAKER_ELA", "CH01_AWAKENING_03"],
		["SPEAKER_LAMPIAO", "CH01_AWAKENING_04"],
		["SPEAKER_ELA", "CH01_AWAKENING_05"],
		["SPEAKER_LAMPIAO", "CH01_AWAKENING_06"],
		["SPEAKER_ELA", "CH01_AWAKENING_07"],
		["SPEAKER_LAMPIAO", "CH01_AWAKENING_08"],
		["SPEAKER_ELA", "CH01_AWAKENING_09"],
	])
	d.lock_player(false)
	d.interactable("Revolver", "CH01_AWAKENING_10").used.connect(func(): Global.player.weapons_manager.switch_weapon(1))
	d.interactable("ViniRifle", "CH01_AWAKENING_11").used.connect(func(): Global.player.weapons_manager.switch_weapon(2))
	Story.set_flag("vini", "left")
	d.interactable("ViniBody", "CH01_AWAKENING_12").used.connect(func():
		Story.set_flag("vini", "forgiven")
		Dialogue.say([["", "CH01_AWAKENING_13"]]))
