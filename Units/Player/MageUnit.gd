extends PlayerUnit
class_name MageUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.MAGE_TEXTURE
	var staff = ItemTextureManager.STAFF_TEXTURES
	right_sprite.texture = staff[randi() % staff.size()]
