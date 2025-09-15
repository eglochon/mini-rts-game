extends Unit
class_name PlayerUnit

@onready var selection_spite: Sprite2D = $SlectionSprite
var _is_selected: bool = false

func toggle_selection(value: bool) -> void:
	selection_spite.visible = value
	if value:
		selection_spite.self_modulate = Color(1, 1, 0.5)
		sprite.self_modulate = Color(1, 1, 0.2)
	else:
		selection_spite.self_modulate = Color(1, 1, 1)
		sprite.self_modulate = Color(1, 1, 1)
	_is_selected = value

func is_selected() -> bool:
	return _is_selected

func toggle_hover(value: bool) -> void:
	if not _is_selected:
		selection_spite.visible = value
		if value:
			selection_spite.self_modulate = Color(0.752, 0.392, 0.224)
		else:
			selection_spite.self_modulate = Color(1, 1, 1)

func _on_mouse_entered() -> void:
	toggle_hover(true)

func _on_mouse_exited() -> void:
	toggle_hover(false)
