extends RefCounted


func run(d: Chapter01Director) -> void:
	d.beat = 1
	d.cast.barauna = d.spawn_npc("BaraunaFarm", d.LEATHER, "half_moon")
	d.cast.xexeu = d.spawn_npc("XexeuFarm", d.LEATHER.darkened(0.2), "half_moon")
	d.cast.maria = d.spawn_npc("MariaFarm", Color(0.35, 0.27, 0.2), "beret")
	d.cast.barauna.pose("Crouch_Idle")
	d.face_player_to("CoinBag")
	Global.player.weapons_manager.switch_weapon(2)
	await Dialogue.fade(0.0, 1.5)
	d.lock_player(false)
	Dialogue.show_prompt("CH01_RAID_01")
	await d.get_tree().create_timer(4.0).timeout
	Dialogue.hide_prompt()
	await d.interactable("CoinBag", "CH01_RAID_02").used
	Story.set_flag("coin_bag", "taken")
	var benedito := d.spawn_npc("BeneditoDoor", d.UNIFORM, "kepi", false)
	var target := d.attach_hit_target(benedito)
	target.hit.connect(func():
		if Story.flag("farm_benedito") == "":
			Story.set_flag("farm_benedito", "killed")
			benedito.die()
			Dialogue.say([["SPEAKER_MARIA", "CH01_RAID_03"]]))
	await benedito.walk_to(d.marker("BeneditoFloor"), 1.6, true)
	benedito.pose("Crouch_Idle")
	await Dialogue.say([
		["SPEAKER_BARAUNA", "CH01_RAID_04"],
		["SPEAKER_LAMPIAO", "CH01_RAID_05"],
	])
	await d.get_tree().create_timer(2.5).timeout
	if Story.flag("farm_benedito") == "":
		Story.set_flag("farm_benedito", "spared")
		benedito.queue_free()
	await Dialogue.say([["SPEAKER_SOLDADO", "CH01_RAID_06"], ["SPEAKER_CAPITAO_DA_VOLANTE", "CH01_RAID_07"]])
	for i in 7:
		var soldier := d.spawn_soldier("FarmSoldier_%d" % (i + 1), 0.22, 0.4)
		soldier.vision_range = 45.0
		soldier.shoot_range = 40.0
		soldier.alert(soldier.global_position, 1.0)
	Dialogue.show_prompt("CH01_RAID_08")
	Global.muzzle_flash.connect(d.on_player_shot)
	d.trigger("BackDoorTrigger").entered.connect(func():
		for key in ["SPEAKER_BARAUNA", "xexeu", "maria"]:
			d.cast[key].walk_to(d.marker("MariaShotTrigger") + Vector3(randf_range(-2, 2), 0, randf_range(-1, 1)), 1.8, true))
	await d.await_trigger("MariaShotTrigger")
	Dialogue.hide_prompt()
	var shooter := d.spawn_npc("ChapelSoldier", d.UNIFORM, "kepi")
	await shooter.look_at_point(Global.player.global_position, 0.2)
	shooter.pose("Pistol_Shoot")
	Effects.gunshot(d, shooter.global_position + Vector3.UP * 1.4)
	d.cast.maria.global_position = Global.player.global_position + Vector3(1.2, 0, -0.6)
	d.cast.maria.pose("Crouch_Idle")
	Pact.hit_flash = 0.8
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_RAID_09"],
		["SPEAKER_LAMPIAO", "CH01_RAID_10"],
		["SPEAKER_MARIA", "CH01_RAID_11"],
		["SPEAKER_XEXEU", "CH01_RAID_12"],
		["SPEAKER_LAMPIAO", "CH01_RAID_13"],
		["", "CH01_RAID_14"],
		["SPEAKER_MARIA", "CH01_RAID_15"],
	])
	shooter.queue_free()
	d.cast.vini = d.spawn_npc("ViniFarm", Color(0.5, 0.48, 0.4), "beret", false)
	for key in ["SPEAKER_BARAUNA", "xexeu", "maria"]:
		d.cast[key].walk_to(d.marker("ViniFarm") + Vector3(randf_range(-2, 2), 0, -1.5), 1.6, true)
	await d.await_trigger("HorsesTrigger")
