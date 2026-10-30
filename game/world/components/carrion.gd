extends Node3D

const PROP := preload("res://game/world/props/prop.gd")
const PROPS := preload("res://game/world/props/prop_library.gd")

@export_enum("horse_carcass", "goat_carcass", "dead_vulture") var animal := "goat_carcass"
@export var seed := 0

var eaten := false


func _ready() -> void:
	var body := Node3D.new()
	body.set_script(PROP)
	body.kind = animal
	body.seed = seed
	add_child(body)
	var area := Area3D.new()
	area.set_script(preload("res://game/world/components/interactable.gd"))
	area.label = "UI_EAT_CARRION"
	area.radius = 2.2
	area.used.connect(_eat)
	add_child(area)


func _eat() -> void:
	eaten = true
	Pact.eat()
	GameUI.hit_flash = 0.7
	Scares.shake(0.08, 0.6)
	var rot := PROPS.material("rot")
	for meat in find_children("*", "MeshInstance3D", true, false):
		if meat.material_override == rot:
			create_tween().tween_property(meat, "scale", meat.scale * Vector3(0.3, 0.2, 0.3), 0.8)
