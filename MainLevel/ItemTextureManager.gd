# UnitTextureManager.gd
extends Node
class_name ItemTextureManager

# WEAPONS

const WOODEN_SWORD_TEXTURE = preload("res://Sprites/Weapons/tile_0107.png")

const BATTLE_AXE_TEXTURE = preload("res://Sprites/Weapons/tile_0118.png")

const SHIELD_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Weapons/tile_0101.png"),
	preload("res://Sprites/Weapons/tile_0102.png")
]

const KNIGHT_WEAPON_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Weapons/tile_0104.png"),
	preload("res://Sprites/Weapons/tile_0106.png"),
	preload("res://Sprites/Weapons/tile_0131.png")
]

const WARRIOR_WEAPON_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Weapons/tile_0103.png"),
	preload("res://Sprites/Weapons/tile_0105.png")
]

const VIKING_WEAPON_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Weapons/tile_0117.png"),
	preload("res://Sprites/Weapons/tile_0119.png")
]

const STAFF_TEXTURES: Array[Texture2D] = [
	preload("res://Sprites/Weapons/tile_0129.png"),
	preload("res://Sprites/Weapons/tile_0130.png")
]
