class_name Backlands
extends RefCounted

const THEME := preload("res://resources/ui/backlands_theme.tres")
const MEDALLION := preload("res://resources/ui/backlands/medallion.png")
const RULE_BONE := preload("res://resources/ui/backlands/rule_bone.png")
const RULE_OCHRE := preload("res://resources/ui/backlands/rule_ochre.png")
const BUTTON_HEIGHT := 100.0
const MEDALLION_SIZE := 60.0


static func button(label_key: String, action: Callable) -> Button:
	var button := Button.new()
	button.text = tr_key(label_key)
	button.custom_minimum_size = Vector2(0, BUTTON_HEIGHT)
	button.focus_mode = Control.FOCUS_ALL
	var medallions: Array[TextureRect] = []
	for side in [-1, 1]:
		var medallion := TextureRect.new()
		medallion.texture = MEDALLION
		medallion.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		medallion.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		medallion.mouse_filter = Control.MOUSE_FILTER_IGNORE
		medallion.size = Vector2.ONE * MEDALLION_SIZE
		medallion.pivot_offset = medallion.size / 2.0
		medallion.anchor_left = 0.0 if side < 0 else 1.0
		medallion.anchor_right = medallion.anchor_left
		medallion.anchor_top = 0.5
		medallion.anchor_bottom = 0.5
		medallion.offset_left = 26.0 if side < 0 else -26.0 - MEDALLION_SIZE
		medallion.offset_right = medallion.offset_left + MEDALLION_SIZE
		medallion.offset_top = -MEDALLION_SIZE / 2.0
		medallion.offset_bottom = MEDALLION_SIZE / 2.0
		button.add_child(medallion)
		medallions.append(medallion)
	var spin := func(turn: float):
		for medallion in medallions:
			medallion.create_tween().tween_property(medallion, "rotation", turn, 0.35).set_trans(Tween.TRANS_BACK)
	button.mouse_entered.connect(spin.bind(PI / 4.0))
	button.focus_entered.connect(spin.bind(PI / 4.0))
	button.mouse_exited.connect(spin.bind(0.0))
	button.focus_exited.connect(spin.bind(0.0))
	button.pressed.connect(action)
	return button


static func label(text: String, variation: StringName) -> Label:
	var label := Label.new()
	label.text = text
	label.theme_type_variation = variation
	return label


static func rule(ochre := false) -> TextureRect:
	var rule := TextureRect.new()
	rule.texture = RULE_OCHRE if ochre else RULE_BONE
	rule.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	rule.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	rule.custom_minimum_size = Vector2(0, 40)
	rule.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return rule


static func tr_key(key: String) -> String:
	return TranslationServer.translate(key)
