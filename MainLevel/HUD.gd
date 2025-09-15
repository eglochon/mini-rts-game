extends Control
class_name HUD

var main_scene: PackedScene = load("res://Main.tscn") as PackedScene

# Player Panel
@onready var player_unit_panel: PanelContainer = $PlayerUnitPanel
@onready var player_unit_sprite: TextureRect = $PlayerUnitPanel/VBox/HBox/SpritePanel/Sprite
@onready var player_health: ProgressBar = $PlayerUnitPanel/VBox/HBox/HealthPanel/Progress
@onready var selected_counter_label: Label = $PlayerUnitPanel/VBox/Label

# Target Panel
@onready var target_unit_panel: PanelContainer = $TargetUnitPanel
@onready var target_unit_sprite: TextureRect = $TargetUnitPanel/HBox/SpritePanel/Sprite
@onready var target_health: ProgressBar = $TargetUnitPanel/HBox/HealthPanel/Progress

# Player Counter Panel
@onready var player_unit_counter_label: Label = $PlayerCounterPanel/VBox/CounterLabel

# Enemy Counter Panel
@onready var enemy_unit_counter_label: Label = $EnemyCounterPanel/VBox/CounterLabel

# Result Panel
@onready var result_panel: PanelContainer = $ResultPanel
@onready var result_label: Label = $ResultPanel/VBox/LabelPanel/Label
@onready var restart_button: Button = $ResultPanel/VBox/RestartPanel/RestartButton
@onready var exit_button: Button = $ResultPanel/VBox/ExitPanel/ExitButton

func _ready() -> void:
	restart_button.pressed.connect(_on_restart)
	exit_button.pressed.connect(_on_exit)

func hide_player_unit() -> void:
	player_unit_panel.visible = false

func set_player_unit(unit: PlayerUnit) -> void:
	player_unit_sprite.texture = unit.sprite.texture
	player_health.max_value = unit.max_health
	player_health.value = unit.health
	player_unit_panel.visible = true

func hide_target_unit() -> void:
	target_unit_panel.visible = false

func set_target_unit(unit: EnemyUnit) -> void:
	target_unit_sprite.texture = unit.sprite.texture
	target_health.max_value = unit.max_health
	target_health.value = unit.health
	target_unit_panel.visible = true

func hide_result() -> void:
	result_panel.visible = false

func set_result(message: String) -> void:
	result_label.text = message
	result_panel.visible = true

func set_selected_counter(total: int) -> void:
	selected_counter_label.text = str(total)

func set_players_counter(total: int) -> void:
	player_unit_counter_label.text = str(total)

func set_enemies_counter(total: int) -> void:
	enemy_unit_counter_label.text = str(total)

func _on_restart() -> void:
	var tree = get_tree()
	tree.paused = false
	tree.reload_current_scene()

func _on_exit() -> void:
	get_tree().paused = false
	call_deferred("_go_to_main_menu")

func _go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(main_scene)
