extends Node2D
class_name BoxSelection

var _drag_start: Vector2
var _drag_end: Vector2
var is_dragging: bool = false
var disabled: bool = false

signal select(rect: Rect2)

func get_rect() -> Rect2:
	return Rect2(_drag_start, _drag_end - _drag_start)

func _draw() -> void:
	if disabled:
		return

	if is_dragging:
		var rect = get_rect()
		draw_rect(rect, Color(0, 0.7, 1, 0.5), true)
		draw_rect(rect, Color(0, 0.7, 1, 1), false, 2)

func _input(event: InputEvent) -> void:
	if disabled:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# Start drag
				is_dragging = true
				_drag_start = get_global_mouse_position()
				_drag_end = _drag_start
			else:
				# End drag
				var rect = get_rect()
				is_dragging = false
				queue_redraw()
				emit_signal("select", rect)
	elif event is InputEventMouseMotion and is_dragging:
		_drag_end = get_global_mouse_position()
		queue_redraw()
