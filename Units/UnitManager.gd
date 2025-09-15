extends Node
class_name UnitManager

# Player Units

const BLACKSMITH: PackedScene = preload("res://Units/Player/BlacksmithUnit.tscn")
const KNIGHT: PackedScene = preload("res://Units/Player/KnightUnit.tscn")
const MAGE: PackedScene = preload("res://Units/Player/MageUnit.tscn")
const RANGER: PackedScene = preload("res://Units/Player/RangerUnit.tscn")
const VIKING: PackedScene = preload("res://Units/Player/VikingUnit.tscn")
const WARRIOR: PackedScene = preload("res://Units/Player/WarriorUnit.tscn")

const PLAYER_UNITS: Array[PackedScene] = [
	BLACKSMITH,
	KNIGHT,
	MAGE,
	RANGER,
	VIKING,
	WARRIOR
]

# Enemy Units

const BAT: PackedScene = preload("res://Units/Enemy/BatUnit.tscn")
const CRAB: PackedScene = preload("res://Units/Enemy/CrabUnit.tscn")
const CYCLOPE: PackedScene = preload("res://Units/Enemy/CyclopeUnit.tscn")
const DARK_MAGE: PackedScene = preload("res://Units/Enemy/DarkMageUnit.tscn")
const DARK_WARRIOR: PackedScene = preload("res://Units/Enemy/DarkWarriorUnit.tscn")
const GHOST: PackedScene = preload("res://Units/Enemy/GhostUnit.tscn")
const RAT: PackedScene = preload("res://Units/Enemy/RatUnit.tscn")
const SLIME: PackedScene = preload("res://Units/Enemy/SlimeUnit.tscn")
const SPIDER: PackedScene = preload("res://Units/Enemy/SpiderUnit.tscn")

const ENEMY_UNITS: Array[PackedScene] = [
	BAT,
	CRAB,
	CYCLOPE,
	DARK_MAGE,
	DARK_WARRIOR,
	GHOST,
	RAT,
	SLIME,
	SPIDER
]
