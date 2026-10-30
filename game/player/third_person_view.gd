class_name ThirdPersonView
extends Node

const BODY := preload("res://resources/characters/lampiao/lampiao.tscn")
const HELD_MESHES := [
	preload("res://resources/weapons/meshes/peixeira.res"),
	preload("res://resources/weapons/meshes/revolver.res"),
	preload("res://resources/weapons/meshes/bolt_rifle.res"),
]
const AIMED_WEAPONS := [1, 2]
const OFFSET := Vector3(0.45, 0.25, 2.6)
const WALL_MARGIN := 0.25
const SKELETON := "Armature/Skeleton3D"
const LOWER_BODY := ["root", "pelvis", "thigh_l", "calf_l", "foot_l", "ball_l", "ball_leaf_l", "thigh_r", "calf_r", "foot_r", "ball_r", "ball_leaf_r"]
const LOCOMOTION := [["Idle", 0.0], ["Walk", 2.0], ["Jog_Fwd", 6.0]]

var player: CharacterBody3D
var body: Node3D
var skeleton: Skeleton3D
var tree: AnimationTree
var held: MeshInstance3D
var active := false


func _ready() -> void:
	player = get_parent()
	body = BODY.instantiate()
	player.add_child.call_deferred(body)
	skeleton = body.get_node(SKELETON)
	_build_tree()
	held = MeshInstance3D.new()
	body.add_child(held)
	if not InputMap.has_action("toggle_view"):
		InputMap.add_action("toggle_view")
		var key := InputEventKey.new()
		key.physical_keycode = KEY_V
		InputMap.action_add_event("toggle_view", key)
	Settings.changed.connect(func(): _set_active(Settings.get_value("third_person")))
	_set_active.call_deferred(Settings.get_value("third_person"))


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_view"):
		Settings.set_value("third_person", not active)


func _set_active(on: bool) -> void:
	active = on
	body.visible = on
	player.get_node("WeaponSubViewport").visible = not on
	if not on:
		player.camera.position = Vector3.ZERO


func _physics_process(_delta: float) -> void:
	if not active:
		return
	player.get_node("WeaponSubViewport").visible = false
	body.rotation.y = player.camera_pivot.rotation.y + PI
	_place_camera()
	_animate()
	_hold_weapon()


func _place_camera() -> void:
	var holder: Node3D = player.camera_holder
	var desired: Vector3 = holder.global_transform * OFFSET
	var query := PhysicsRayQueryParameters3D.create(holder.global_position, desired, 1, [player.get_rid()])
	var hit := player.get_world_3d().direct_space_state.intersect_ray(query)
	player.camera.global_position = desired if hit.is_empty() else hit.position + hit.normal * WALL_MARGIN


func _animate() -> void:
	tree.set("parameters/locomotion/blend_position", Vector2(player.velocity.x, player.velocity.z).length())
	tree.set("parameters/aim/blend_amount", 1.0 if _weapon_index() in AIMED_WEAPONS else 0.0)


func _hold_weapon() -> void:
	var index := _weapon_index()
	held.mesh = HELD_MESHES[index]
	var back_rifle := skeleton.get_node_or_null("Rifle")
	if back_rifle:
		back_rifle.visible = index != 2
	var hand := skeleton.global_transform * skeleton.get_bone_global_pose(skeleton.find_bone("hand_r"))
	var aim: Vector3 = -player.camera.global_basis.z
	held.global_transform = Transform3D(Basis.looking_at(aim), hand.origin)


func _weapon_index() -> int:
	return player.weapons_manager.current_weapon_index


func _build_tree() -> void:
	var locomotion := AnimationNodeBlendSpace1D.new()
	for clip in LOCOMOTION:
		var node := AnimationNodeAnimation.new()
		node.animation = clip[0]
		locomotion.add_blend_point(node, clip[1])
	locomotion.max_space = 6.0
	var aim_clip := AnimationNodeAnimation.new()
	aim_clip.animation = "Pistol_Aim_Neutral"
	var aim := AnimationNodeBlend2.new()
	aim.filter_enabled = true
	for i in skeleton.get_bone_count():
		var bone := skeleton.get_bone_name(i)
		if bone not in LOWER_BODY:
			aim.set_filter_path(NodePath("%s:%s" % [SKELETON, bone]), true)
	var graph := AnimationNodeBlendTree.new()
	graph.add_node("locomotion", locomotion)
	graph.add_node("aim_clip", aim_clip)
	graph.add_node("aim", aim)
	graph.connect_node("aim", 0, "locomotion")
	graph.connect_node("aim", 1, "aim_clip")
	graph.connect_node("output", 0, "aim")
	var clips: AnimationPlayer = body.get_node("AnimationPlayer")
	for clip in ["Idle", "Walk", "Jog_Fwd", "Pistol_Aim_Neutral"]:
		clips.get_animation(clip).loop_mode = Animation.LOOP_LINEAR
	tree = AnimationTree.new()
	tree.tree_root = graph
	tree.anim_player = NodePath("../AnimationPlayer")
	body.add_child(tree)
	tree.active = true
