extends PlayerUnit
class_name BlacksmithUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.BLACKSMITH_TEXTURE
	right_sprite.texture = ItemTextureManager.BATTLE_AXE_TEXTURE
	
