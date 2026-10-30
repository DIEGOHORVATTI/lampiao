extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 11
	_halo(d)
	d.lock_player(false)
	d.objective("CH01_GOAL_RETURN", ["ViniHall", "Tunnel_5", "Tunnel_4", "Tunnel_3", "Tunnel_2", "Tunnel_1", "Campfire"])
	d.interactable("LampiaoRifle", "CH01_RETURN_RIFLE").used.connect(func(): Global.player.weapons_manager.switch_weapon(2))
	await d.wait_until(func(): return Global.player.global_position.z < d.marker("Tunnel_5").z, 180.0)
	await Dialogue.say([["SPEAKER_LAMPIAO", "CH01_RETURN_01"]])
	await d.await_trigger("CampReturnTrigger")
	d.objective("")
	d.lock_player(true)
	d.face_player_to("Maria")
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_MARIA_01"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_02"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_03"],
		["SPEAKER_LAMPIAO", "CH01_MARIA_04"],
	])
	await Dialogue.fade(1.0, 2.5)


func _halo(d: Chapter01Director) -> void:
	var halo := OmniLight3D.new()
	halo.light_color = Color(0.75, 0.78, 0.9)
	halo.light_energy = 0.35
	halo.omni_range = 4.0
	Global.player.camera.add_child(halo)
