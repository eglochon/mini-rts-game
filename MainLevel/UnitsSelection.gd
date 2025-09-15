extends Node
class_name UnitsSelection

var _units: Array[PlayerUnit]

func size() -> int:
	return _units.size()

func is_empty() -> bool:
	return _units.size() == 0

func has(unit: PlayerUnit) -> bool:
	return _units.has(unit)

func add(unit: PlayerUnit) -> void:
	if not _units.has(unit):
		_units.append(unit)
		unit.toggle_selection(true)

func get_all() -> Array[PlayerUnit]:
	return _units

func remove(unit: PlayerUnit) -> void:
	if _units.has(unit):
		unit.toggle_selection(false)
		_units.erase(unit)

func remove_all() -> void:
	for unit in _units:
		unit.toggle_selection(false)
	_units.clear()

func pick() -> PlayerUnit:
	if not _units.is_empty():
		return _units[randi() % _units.size()]
	return null
