extends EnemyUnit
class_name GhostUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.GHOST_TEXTURE
