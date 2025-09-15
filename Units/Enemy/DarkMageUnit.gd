extends EnemyUnit
class_name DarkMageUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.DARK_MAGE_TEXTURE
	var staff = ItemTextureManager.STAFF_TEXTURES
	right_sprite.texture = staff[randi() % staff.size()]
