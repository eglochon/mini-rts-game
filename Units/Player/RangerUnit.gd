extends PlayerUnit
class_name RangerUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.RANGER_TEXTURE
	left_sprite.texture = ItemTextureManager.WOODEN_SWORD_TEXTURE
