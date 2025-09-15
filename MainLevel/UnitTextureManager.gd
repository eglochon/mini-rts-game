# UnitTextureManager.gd
extends Node
class_name UnitTextureManager

# PLAYER UNITS

const MAGE_TEXTURE = preload("res://Sprites/Players/tile_0084.png")

const VIKING_TEXTURE = preload("res://Sprites/Players/tile_0087.png")

const WARRIOR_TEXTURE = preload("res://Sprites/Players/tile_0088.png")

const RANGER_TEXTURE = preload("res://Sprites/Players/tile_0085.png")

const BLACKSMITH_TEXTURE = preload("res://Sprites/Players/tile_0086.png")

const KNIGHT_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Players/tile_0096.png"),
	preload("res://Sprites/Players/tile_0097.png"),
	preload("res://Sprites/Players/tile_0098.png")
]

# ENEMY UNITS

const SLIME_TEXTURE = preload("res://Sprites/Enemies/tile_0108.png")

const CYCLOPE_TEXTURE = preload("res://Sprites/Enemies/tile_0109.png")

const CRAB_TEXTURE = preload("res://Sprites/Enemies/tile_0110.png")

const DARK_MAGE_TEXTURE = preload("res://Sprites/Enemies/tile_0111.png")

const DARK_WARRIOR_TEXTURE = preload("res://Sprites/Enemies/tile_0112.png")

const BAT_TEXTURE = preload("res://Sprites/Enemies/tile_0120.png")

const GHOST_TEXTURE = preload("res://Sprites/Enemies/tile_0121.png")

const SPIDER_TEXTURE = preload("res://Sprites/Enemies/tile_0122.png")

const RAT_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Enemies/tile_0123.png"),
	preload("res://Sprites/Enemies/tile_0124.png")
]
