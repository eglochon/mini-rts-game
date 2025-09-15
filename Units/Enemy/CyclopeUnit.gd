extends EnemyUnit
class_name CyclopeUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.CYCLOPE_TEXTURE
	right_sprite.texture = ItemTextureManager.BATTLE_AXE_TEXTURE
