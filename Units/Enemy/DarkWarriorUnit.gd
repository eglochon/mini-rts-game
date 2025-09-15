extends EnemyUnit
class_name DarkWarriorUnit

func _ready() -> void:
	sprite.texture = UnitTextureManager.DARK_WARRIOR_TEXTURE
	var weapon_sprs = ItemTextureManager.WARRIOR_WEAPON_TEXTURES
	var weapon_sprite = weapon_sprs[randi() % weapon_sprs.size()]
	right_sprite.texture = weapon_sprite
	left_sprite.texture = weapon_sprite
