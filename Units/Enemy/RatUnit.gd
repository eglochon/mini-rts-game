extends EnemyUnit
class_name RatUnit

func _ready() -> void:
	var unit_sprs = UnitTextureManager.RAT_TEXTURES
	sprite.texture = unit_sprs[randi() % unit_sprs.size()]
