extends PanelContainer

var game_paused: bool = false

@onready var resume_btn: Button = $VBoxContainer/ResumeButton
@onready var exit_btn: Button = $VBoxContainer/ExitButton

# var main_scene: PackedScene = preload("res://Main.tscn")

func _ready() -> void:
	resume_btn.pressed.connect(_on_resume)
	exit_btn.pressed.connect(_on_exit)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if game_paused:
			game_paused = false
			get_tree().paused = false
			self.visible = false
		else:
			game_paused = true
			get_tree().paused = true
			self.visible = true

func _on_resume() -> void:
	game_paused = false
	get_tree().paused = false
	self.visible = false

func _on_exit() -> void:
	_on_resume()
	get_tree().change_scene_to_file("res://Main.tscn")
