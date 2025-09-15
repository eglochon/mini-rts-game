extends PlayerUnit
class_name KnightUnit

func _ready() -> void:
	var unit_sprs = UnitTextureManager.KNIGHT_TEXTURES
	sprite.texture = unit_sprs[randi() % unit_sprs.size()]
	var shield_sprs = ItemTextureManager.SHIELD_TEXTURES
	left_sprite.texture = shield_sprs[randi() % shield_sprs.size()]
	var weapon_sprs = ItemTextureManager.KNIGHT_WEAPON_TEXTURES
	right_sprite.texture = weapon_sprs[randi() % weapon_sprs.size()]
