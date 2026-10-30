extends "res://world/gatilho.gd"

@export_enum("jumpscare", "vulto", "passos", "batida", "sussurro", "respiracao", "apagao") var tipo := "vulto"
@export var rosto := "corpo_seco"


func _ready() -> void:
	super._ready()
	entrou.connect(_assustar)


func _assustar() -> void:
	match tipo:
		"jumpscare": Sustos.jumpscare(rosto)
		"vulto": Sustos.vulto()
		"apagao": Sustos.apagar_luzes()
		"passos", "batida", "sussurro", "respiracao": Sustos.som_atras(tipo)
