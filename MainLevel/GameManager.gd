extends Node2D
class_name GameManager

var selected_units: UnitsSelection
var selected_unit: PlayerUnit
var player_units: Array[Unit]
var enemy_units: Array[Unit]

var box_selection: BoxSelection

var game_started: bool = false
var game_finished: bool = false

const TARGET_RANGE = 300.0

@onready var hud: HUD = $CanvasLayer/HUD

@onready var map_selection_sprite: Sprite2D = $MapSelection
var pointer_tween: Tween

@onready var camera: Camera2D = $Camera
@export var edge_size: int = 95
@export var camera_speed: float = 300.0
@export var camera_acceleration: float = 2000.0
@export var camera_deceleration: float = 1500.0
@export var camera_min: Vector2 = Vector2(0, -300)
@export var camera_max: Vector2 = Vector2(300, 100)  # adjust to your map size
var camera_velocity: Vector2 = Vector2.ZERO

@export var player_units_path: String = "res://Units/Player"
@export var enemy_units_path: String = "res://Units/Enemy"

func _ready() -> void:
	# Selection Logic
	selected_units = UnitsSelection.new()
	
	# Box Selection
	box_selection = BoxSelection.new()
	add_child(box_selection)
	box_selection.select.connect(_on_select_area)
	
	# Restart Button
	hud.restart_button.pressed.connect(_on_restart)

	# Wait for navigation areas to load and the spawn units
	NavigationServer2D.map_changed.connect(_on_nav_ready)

func _on_select_area(rect: Rect2) -> void:
	var normalized_rect = Rect2(rect.position, rect.size)
	if rect.size.x < 0:
		normalized_rect.position.x += rect.size.x
		normalized_rect.size.x = -rect.size.x
	if rect.size.y < 0:
		normalized_rect.position.y += rect.size.y
		normalized_rect.size.y = -rect.size.y

	# Prevent deselecting a unit
	if normalized_rect.get_area() > 1.0:
		selected_units.remove_all()

	for unit in player_units:
		if normalized_rect.has_point(unit.global_position):
			selected_units.add(unit)

func _on_nav_ready(_map: RID) -> void:
	call_deferred("_spawn_units")

func _spawn_units() -> void:
	# Get regions
	var regions = get_tree().get_nodes_in_group("nav_regions")
	var player_regions = []
	var enemy_regions = []
	for region in regions:
		if region is NavigationRegion2D:
			if region.is_in_group("enemy_spawn"):
				enemy_regions.append(region)
			elif region.is_in_group("player_spawn"):
				player_regions.append(region)

	# Spawn a lot of units
	for region in player_regions:
		for i in range(10):
			_spawn_player(_get_random_point(region))
	for region in enemy_regions:
		for i in range(10):
			_spawn_enemy(_get_random_point(region))

	# Init their targets
	for enemy in enemy_units:
		var nearest_player := _find_nearest_unit(enemy.global_position, player_units, TARGET_RANGE)
		if nearest_player:
			enemy.set_target(nearest_player)
	for player in player_units:
		var nearest_enemy := _find_nearest_unit(player.global_position, enemy_units, TARGET_RANGE)
		if nearest_enemy:
			player.set_target(nearest_enemy)
	
	game_started = true

func _get_random_point(nav_region: NavigationRegion2D) -> Vector2:
	var map_rid = nav_region.get_navigation_map()
	var bounds = nav_region.get_bounds() # approximate rectangle of region
	var random_point: Vector2
	var tries := 10
	
	while tries > 0:
		tries -= 1
		random_point = Vector2(
			randf_range(bounds.position.x, bounds.position.x + bounds.size.x),
			randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
		)
		# Snap to navmesh
		var closest = NavigationServer2D.map_get_closest_point(map_rid, random_point)
		if closest != Vector2.INF:
			return closest
	return nav_region.global_position  # fallback

func _spawn_player(pos: Vector2) -> void:
	var scene: PackedScene = UnitManager.PLAYER_UNITS[randi() % UnitManager.PLAYER_UNITS.size()]
	var unit: PlayerUnit = scene.instantiate()
	unit.global_position = pos
	unit.death.connect(_on_player_death)
	unit.next_target.connect(_on_player_next_target)

	add_child(unit)
	player_units.append(unit)

func _spawn_enemy(pos: Vector2) -> void:
	var scene: PackedScene = UnitManager.ENEMY_UNITS[randi() % UnitManager.ENEMY_UNITS.size()]
	var unit: EnemyUnit = scene.instantiate()
	unit.global_position = pos
	unit.death.connect(_on_enemy_death)
	unit.next_target.connect(_on_enemy_next_target)

	add_child(unit)
	enemy_units.append(unit)

func _on_player_death(unit: Unit):
	if unit is PlayerUnit:
		selected_units.remove(unit)
		if unit == selected_unit:
			selected_unit = null
		player_units.erase(unit)
		remove_child(unit)
		unit.queue_free()

func _on_enemy_death(unit: Unit):
	if unit is EnemyUnit:
		enemy_units.erase(unit)
		remove_child(unit)
		unit.queue_free()

func _on_player_next_target(unit: Unit):
	var nearest_enemy := _find_nearest_unit(unit.global_position, enemy_units, TARGET_RANGE)
	if nearest_enemy:
		unit.set_target(nearest_enemy)

func _on_enemy_next_target(unit: Unit):
	var nearest_player := _find_nearest_unit(unit.global_position, player_units, TARGET_RANGE)
	if nearest_player:
		unit.set_target(nearest_player)

func _find_nearest_unit(pos: Vector2, units: Array[Unit], max_range: float) -> Unit:
	var nearest: Unit = null
	var min_dist := max_range
	for unit in units:
		var d = pos.distance_to(unit.global_position)
		if d <= min_dist:
			min_dist = d
			nearest = unit
	return nearest

func _process(delta: float) -> void:
	if not game_started:
		return
	_handle_camera_movement(delta)
	_handle_hud_sprites()
	_handle_hud_counters()

func _handle_camera_movement(delta: float) -> void:
	if game_finished:
		return

	var input_vector = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).normalized()

	var viewport = get_viewport()
	var viewport_size = viewport.get_visible_rect().size
	var mouse_pos = viewport.get_mouse_position()

	var edge_vector = Vector2.ZERO
	if not box_selection.is_dragging:
		if mouse_pos.x >= 0 and mouse_pos.x <= viewport_size.x and mouse_pos.y >= 0 and mouse_pos.y <= viewport_size.y:
			# Horizontal edges
			if mouse_pos.x <= edge_size:
				edge_vector.x = -1
			elif mouse_pos.x >= viewport_size.x - edge_size:
				edge_vector.x = 1

			# Vertical edges
			if mouse_pos.y <= edge_size:
				edge_vector.y = -1
			elif mouse_pos.y >= viewport_size.y - edge_size:
				edge_vector.y = 1

			# Normalize
			if edge_vector != Vector2.ZERO:
				edge_vector = edge_vector.normalized()

	var final_input = input_vector + edge_vector
	final_input = final_input.normalized() if final_input != Vector2.ZERO else Vector2.ZERO

	# Smooth
	if final_input != Vector2.ZERO:
		camera_velocity = camera_velocity.move_toward(final_input * camera_speed, camera_acceleration * delta)
	else:
		camera_velocity = camera_velocity.move_toward(Vector2.ZERO, camera_deceleration * delta)

	# Apply movement
	camera.position += camera_velocity * delta

	# Clamp camera
	camera.position.x = clamp(camera.position.x, camera_min.x, camera_max.x)
	camera.position.y = clamp(camera.position.y, camera_min.y, camera_max.y)

func _handle_hud_sprites() -> void:
	if selected_units.is_empty():
		hud.hide_player_unit()
		hud.hide_target_unit()
	else:
		# Player Unit
		if not selected_unit:
			selected_unit = selected_units.pick()
		hud.set_player_unit(selected_unit)

		# Target Unit
		if selected_unit.target and selected_unit.target is EnemyUnit:
			hud.set_target_unit(selected_unit.target)
		else:
			hud.hide_target_unit()

	# Selected units counter
	hud.set_selected_counter(selected_units.size())

func _handle_hud_counters() -> void:
	var total_players = len(player_units)
	var total_enemies = len(enemy_units)
	hud.set_players_counter(total_players)
	hud.set_enemies_counter(total_enemies)

	if not game_finished:
		if total_players == 0 and total_enemies == 0:
			return
		if total_players == 0:
			_end_game("Game Over!")
		elif total_enemies == 0:
			_end_game("You Win!")

func _end_game(message: String) -> void:
	get_tree().paused = true
	game_finished = true
	box_selection.disabled = true
	hud.set_result(message)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			_try_select_unit()
		elif event.button_index == MOUSE_BUTTON_RIGHT:
			_try_command_unit()

func _try_select_unit() -> void:
	var unit = _get_unit_under_mouse()
	if not unit:
		selected_units.remove_all()
		return

	if unit is PlayerUnit:
		if selected_units.has(unit):
			selected_units.remove(unit)
		else:
			selected_units.add(unit)
	elif unit is EnemyUnit:
		for selected in selected_units.get_all():
			selected.set_target(unit)

func _try_command_unit() -> void:
	if selected_units.is_empty():
		return

	var clicked_unit = _get_unit_under_mouse()
	if clicked_unit and clicked_unit is EnemyUnit:
		for unit in selected_units.get_all():
			unit.set_target(clicked_unit)
	else:
		# Move Units
		var mouse_pos = get_global_mouse_position()
		for unit in selected_units.get_all():
			unit.move_to_location(mouse_pos)
		# Show pointer on map
		if pointer_tween and pointer_tween.is_running():
			pointer_tween.kill()
		map_selection_sprite.position = mouse_pos
		map_selection_sprite.visible = true
		map_selection_sprite.modulate.a = 1.0
		pointer_tween = create_tween()
		(pointer_tween.tween_property(map_selection_sprite, "modulate:a", 0.0, 0.2)
			.set_trans(Tween.TRANS_LINEAR)
			.set_ease(Tween.EASE_IN_OUT))

func _get_unit_under_mouse() -> Unit:
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = get_global_mouse_position()
	var intersections = space.intersect_point(query, 1)
	if !intersections.is_empty():
		for intersection in intersections:
			var collider = intersection.get("collider")
			if collider is Unit:
				return collider
	return null

func _on_restart() -> void:
	var tree = get_tree()
	tree.paused = false
	tree.reload_current_scene()
