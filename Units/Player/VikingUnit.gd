extends PlayerUnit
class_name VikingUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.VIKING_TEXTURE
	var weapon_sprs = ItemTextureManager.VIKING_WEAPON_TEXTURES
	var weapon_sprite = weapon_sprs[randi() % weapon_sprs.size()]
	right_sprite.texture = weapon_sprite
	left_sprite.texture = weapon_sprite
