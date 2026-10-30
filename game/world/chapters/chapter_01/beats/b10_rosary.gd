extends RefCounted

const MEMORY_FLASHES := 5


func run(d: Chapter01Director) -> void:
	d.beat = 10
	d.face_player_to("ViniDuel")
	await Dialogue.say([["SPEAKER_ELA", "CH01_ROSARY_01"]])
	await Dialogue.fade(0.85, 0.15, Color.WHITE)
	await Dialogue.say([["SPEAKER_ELA", "CH01_ROSARY_02"]])
	Scares.shake(0.25, 1.6)
	Scares._play(Scares.sounds["stinger"], 6.0)
	for i in MEMORY_FLASHES:
		await Dialogue.fade(0.95, 0.08, Color.WHITE)
		await d.get_tree().create_timer(0.35).timeout
		await Dialogue.fade(0.4, 0.12, Color.WHITE)
	await Dialogue.fade(1.0, 0.4, Color.WHITE)
	Powers.entity_mode = false
	Pact.meal_value = Pact.HUNGER_PER_MEAL
	Pact.hunger_enabled = false
	Pact.hunger = 0.0
	d.restore_night()
	Global.player.camera_pivot.position.y = 1.7
	d.set_glasses(true)
	GameUI.crack_lens()
	Story.set_flag("rosary", "hand")
	d.teleport_player("LampiaoDuel", 0.0)
	d.face_player_to("ViniDuel")
	await Dialogue.fade(0.0, 1.5, Color.WHITE)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_ROSARY_03"],
		["SPEAKER_ELA", "CH01_ROSARY_04"],
		["SPEAKER_LAMPIAO", "CH01_ROSARY_05"],
		["SPEAKER_ELA", "CH01_ROSARY_06"],
	])
