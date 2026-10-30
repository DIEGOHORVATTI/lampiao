@tool
extends Node3D

@export_enum("terrain", "terrain_large", "cave_floor", "cave_ceiling", "cave_top", "farm_terrain", "xique_xique", "horse_carcass", "goat_carcass", "dead_vulture", "barbed_fence", "horse", "stone_arch", "idol_totem", "tomb_slab", "bone_niche", "cauldron", "coin_pile", "torch", "wall_lamp", "sleeping_mat", "chapel", "manor", "mandacaru", "mud_house", "stick_fence", "cross", "rock", "dead_tree", "well", "campfire", "campfire_out", "canvas_tent", "torn_tent", "overturned_cart", "crate", "stone_wall", "grave", "cliff", "corpse", "roadside_cross", "porch_house", "rail_fence", "great_dead_tree", "dry_stakes", "idol_column", "idol_column_tilted", "fallen_column", "drum_column", "broken_drum_column", "block_pillar", "arched_block_wall", "cave_mouth", "stone_stove", "rolled_blanket", "gourd_bowls", "hanging_bags", "moonbeam", "trail_pillar", "dry_bush", "forest_belt") var kind := "mandacaru":
	set(value):
		kind = value
		_rebuild()
@export var seed := 0:
	set(value):
		seed = value
		_rebuild()


func _ready() -> void:
	_rebuild()


func _rebuild() -> void:
	if not is_inside_tree():
		return
	for child in get_children():
		child.queue_free()
	var rng := RandomNumberGenerator.new()
	rng.seed = seed
	add_child(PropLibrary.build(kind, rng))
