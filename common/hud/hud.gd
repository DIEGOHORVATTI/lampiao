extends Control

@onready var enemies_label: Label = $EnemiesLabel
@onready var bullets_label: Label = $BulletsLabel
@onready var health_bar: ProgressBar = $HealthBar

var weapons_manager = null


# Called when the node enters the scene tree for the first time.
var ammo_timer: SceneTreeTimer


func _ready() -> void:
	health_bar.visible = false
	enemies_label.visible = false
	bullets_label.visible = false
	bullets_label.add_theme_color_override("font_color", Color(0.91, 0.86, 0.75))
	bullets_label.add_theme_font_size_override("font_size", 30)
	bullets_label.add_theme_color_override("font_outline_color", Color.BLACK)
	bullets_label.add_theme_constant_override("outline_size", 8)
	bullets_label.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_RIGHT)
	bullets_label.offset_left = -420
	bullets_label.offset_right = -180
	bullets_label.offset_top = -470
	bullets_label.offset_bottom = -420
	bullets_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	Global.reload_input.connect(_flash_ammo)
	Global.weapon_switch_next.connect(_flash_ammo)
	Global.weapon_switch_prev.connect(_flash_ammo)
	Global.bullets_changed.connect(_on_bullets_changed)
	Global.player_health_changed.connect(_on_player_health_changed)
	Global.enemy_count_changed.connect(_on_enemy_count_changed)
	
	# Get weapons manager from player
	if Global.player:
		weapons_manager = Global.player.get_node_or_null("WeaponsManager")
	
	# Initial display updates
	_on_bullets_changed()
	_on_enemy_count_changed(Global.enemies_killed)


func _flash_ammo() -> void:
	bullets_label.visible = true
	ammo_timer = get_tree().create_timer(2.5)
	ammo_timer.timeout.connect(func(): bullets_label.visible = _ammo_low())


func _ammo_low() -> bool:
	if not weapons_manager or not weapons_manager.current_weapon:
		return false
	var mag = weapons_manager.get_current_mag()
	return mag >= 0 and mag <= 1 and weapons_manager.current_weapon.reload_required


func _on_bullets_changed() -> void:
	if not weapons_manager or not weapons_manager.current_weapon or weapons_manager.get_current_mag() < 0:
		bullets_label.text = ""
		bullets_label.visible = false
		return
	if _ammo_low():
		bullets_label.visible = true
	
	var current_mag = weapons_manager.get_current_mag()
	var current_ammo = weapons_manager.get_current_ammo()
	
	# Handle infinite ammo display (-1)
	if current_ammo == -1:
		if weapons_manager.current_weapon.reload_required:
			bullets_label.text = str(current_mag, "  ·  ∞")
		else:
			bullets_label.text = "∞"
	else:
		if weapons_manager.current_weapon.reload_required:
			bullets_label.text = str(current_mag, "  ·  ", current_ammo)
		else:
			bullets_label.text = str(current_ammo)


func _on_enemy_count_changed(count: int) -> void:
	enemies_label.text = str("CARNIÇAS: ", count)


func _on_player_health_changed(_health_change:float,current_health:float,max_health:float, _is_enemy_damage:bool) -> void:
	update_health_bar(current_health,max_health)
		

func update_health_bar(current_health,max_health) -> void:
	health_bar.value = current_health
	health_bar.max_value = max_health
