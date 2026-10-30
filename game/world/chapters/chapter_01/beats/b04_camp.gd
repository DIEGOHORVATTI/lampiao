extends RefCounted

const NEAR := 3.0


func run(d: Chapter01Director) -> void:
	d.beat = 4
	d.teleport_player("LampiaoMat", 180.0)
	d.cast.maria = d.spawn_maria("Maria")
	d.cast.maria.pose("Sitting_Idle")
	d.cast.triangles = d.spawn_npc("Triangles", d.LEATHER, "half_moon")
	d.cast.triangles.pose("Sitting_Idle")
	d.cast.stars = d.spawn_npc("Stars", d.LEATHER.darkened(0.2), "half_moon")
	d.cast.stars.pose("Crouch_Idle")
	d.cast.vini = d.spawn_npc("Vini", d.VINI_SHIRT, "beret")
	d.cast.vini.global_position = d.marker("Campfire") + Vector3(0.9, 0, 0.9)
	for key in ["maria", "triangles", "stars", "vini"]:
		d.cast[key].look_at_point(d.marker("Campfire"), 0.01)
	d.face_player_to("Maria")
	Global.player.weapons_manager.switch_weapon(2)
	await Dialogue.fade(0.0, 1.5)
	d.lock_player(false)
	d.objective("CH01_GOAL_MARIA")
	await d.interactable("Maria", "CH01_CAMP_BANDAGE").used
	d.lock_player(true)
	await Dialogue.say([
		["SPEAKER_LAMPIAO", "CH01_CAMP_01"],
		["SPEAKER_LAMPIAO", "CH01_CAMP_02"],
		["SPEAKER_MARIA", "CH01_CAMP_03"],
	])
	d.lock_player(false)
	d.objective("CH01_GOAL_MONEY", ["Maria", "Campfire", "CoinPile"])
	await d.cast.vini.walk_to(d.marker("CoinPile") + Vector3(-1.2, 0, 0), 1.4)
	await d.wait_until(func(): return Global.player.global_position.distance_to(d.marker("CoinPile")) < NEAR, 120.0)
	await Dialogue.say([
		["SPEAKER_VINI", "CH01_CAMP_04"],
		["SPEAKER_VINI", "CH01_CAMP_05"],
		["SPEAKER_LAMPIAO", "CH01_CAMP_06"],
	])
	await d.cast.vini.walk_to(d.marker("Campfire") + Vector3(0.9, 0, 0.9), 1.4)
	await Dialogue.say([["SPEAKER_VINI", "CH01_CAMP_07"]])
	d.objective("CH01_GOAL_SOUP", ["CoinPile", "Campfire", "SoupBowl"])
	await d.interactable("SoupBowl", "CH01_CAMP_SOUP").used
	d.objective("")
	d.lock_player(true)
	await Dialogue.say([
		["SPEAKER_CANGACEIRO", "CH01_CAMP_08"],
		["SPEAKER_VINI", "CH01_CAMP_09"],
	])
	d.cast.vini.walk_to(d.marker("Vini"), 1.4)
	await Dialogue.say([["SPEAKER_VINI", "CH01_CAMP_10"]])
