@tool
extends Node3D

@export_enum("terreno", "mandacaru", "casa_taipa", "cerca_varas", "cruz", "pedra", "arvore_seca", "poco", "lampiao", "fogueira", "fogueira_apagada", "barraca_lona", "barraca_rasgada", "carroca_tombada", "caixote", "muro_pedra", "cova", "paredao", "corpo", "cruz_exvoto") var kind := "mandacaru":
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
	add_child(SertaoProps.build(kind, rng))
