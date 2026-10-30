extends SceneTree

const MeshKit := preload("res://resources/weapons/mesh_kit.gd")
const Rifle := preload("res://resources/weapons/bolt_rifle_model.gd")
const Revolver := preload("res://resources/weapons/revolver_model.gd")
const Peixeira := preload("res://resources/weapons/peixeira_model.gd")
const CoatArms := preload("res://resources/weapons/coat_arms_model.gd")

const DIR := "res://resources/weapons/"
const WOOD_TEXTURE := DIR + "textures/wood_grain.png"


func _init() -> void:
	if OS.get_cmdline_user_args().has("textures"):
		_save_wood_texture()
	else:
		_save_meshes()
	quit()


func _save_wood_texture() -> void:
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR + "textures"))
	var noise := FastNoiseLite.new()
	noise.seed = 1930
	noise.frequency = 0.012
	noise.fractal_octaves = 2
	var warp := noise.get_seamless_image(512, 256, false, false, 0.1, true)
	noise.frequency = 0.08
	var speckle := noise.get_seamless_image(64, 256, false, false, 0.1, true)
	speckle.resize(512, 256, Image.INTERPOLATE_CUBIC)
	var image := Image.create(512, 256, false, Image.FORMAT_RGB8)
	for y in 256:
		for x in 512:
			image.set_pixel(x, y, Color.WHITE * _grain(x, y, warp, speckle))
	image.save_png(WOOD_TEXTURE)


func _grain(x: int, y: int, warp: Image, speckle: Image) -> float:
	var rings := 0.5 + 0.5 * sin(TAU * (y / 256.0 * 14.0 + warp.get_pixel(x, y).r * 0.7))
	return 0.66 + 0.22 * pow(rings, 4.0) + 0.12 * speckle.get_pixel(x, y).r


func _save_meshes() -> void:
	var wood: Material = load(DIR + "materials/wood.tres")
	var steel: Material = load(DIR + "materials/steel.tres")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR + "meshes"))
	_save(Rifle.body(wood, steel), "bolt_rifle")
	_save(Rifle.bolt(steel), "bolt_rifle_bolt")
	_save(Revolver.body(wood, steel), "revolver")
	_save(Revolver.cylinder(steel), "revolver_cylinder")
	_save(Peixeira.body(wood, steel), "peixeira")
	var arms := CoatArms.build(load("res://resources/player/coat_arms.tres"))
	ResourceSaver.save(arms, "res://resources/player/coat_arms_mesh.res")


func _save(mesh: ArrayMesh, file: String) -> void:
	var tris := 0
	for s in mesh.get_surface_count():
		tris += mesh.surface_get_array_index_len(s) / 3
	print(file, ": ", tris, " tris")
	ResourceSaver.save(mesh, DIR + "meshes/" + file + ".res")
