extends Node3D

const PROP := preload("res://world/sertao/prop.gd")
const PROPS := preload("res://world/sertao/props.gd")

@export_enum("carcaca_cavalo", "carcaca_bode", "urubu_morto") var bicho := "carcaca_bode"
@export var seed := 0

var eaten := false


func _ready() -> void:
	var body := Node3D.new()
	body.set_script(PROP)
	body.kind = bicho
	body.seed = seed
	add_child(body)
	var area := Area3D.new()
	area.set_script(preload("res://world/interagivel.gd"))
	area.texto = "Comer a carniça"
	area.raio = 2.2
	area.usado.connect(_comer)
	add_child(area)


func _comer() -> void:
	eaten = true
	Pacto.comer()
	Pacto.hit_flash = 0.7
	Sustos.shake(0.08, 0.6)
	var rot := PROPS.material("rot")
	for meat in find_children("*", "MeshInstance3D", true, false):
		if meat.material_override == rot:
			create_tween().tween_property(meat, "scale", meat.scale * Vector3(0.3, 0.2, 0.3), 0.8)
