extends Control
class_name MainScene

@onready var start_btn: Button = $VBox/StartPanel/StartButton
@onready var exit_btn: Button = $VBox/ExitPanel/ExitButton

var stage_scene: PackedScene = preload("res://MainLevel/Stage.tscn")

func _ready() -> void:
	start_btn.pressed.connect(_on_start_button_pressed)
	if not OS.has_feature("web"):
		exit_btn.pressed.connect(_on_exit_button_pressed)
	else:
		exit_btn.visible = false

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(stage_scene)

func _on_exit_button_pressed() -> void:
	if OS.has_feature("web"):
		get_tree().paused = true
	else:
		get_tree().quit()
