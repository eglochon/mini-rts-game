extends CharacterBody2D
class_name Unit

@export var health: int = 100
@export var max_health: int = 100
@export var mana: int = 0
@export var max_mana: int = 0
@export var damage: int = 20

@export var move_speed: float = 30.0
@export var attack_range: float = 20.0
@export var attack_rate: float = 0.5

@export var target_check_rate: float = 3.0

@export var sprite_texture: Texture2D = preload("res://Sprites/Players/tile_0085.png")
@onready var sprite: Sprite2D = $Sprite
@onready var left_sprite: Sprite2D = $Sprite/LeftHandSprite
@onready var right_sprite: Sprite2D = $Sprite/RightHandSprite

@onready var agent: NavigationAgent2D = $NavigationAgent

signal death(unit: Unit)
signal next_target(unit: Unit)

var hitflash_tween: Tween
var last_target_check: float = 0.0
var last_attack_time: float = 0.0
var target: Unit

func is_alive() -> bool:
	return health > 0

func _ready() -> void:
	if sprite_texture:
		sprite.texture = sprite_texture

func _process(delta: float) -> void:
	if not is_alive():
		self.visible = false
		return

	if target != null:
		_target_check(target)
	else:
		last_target_check += delta
		if last_target_check >= target_check_rate:
			last_target_check = 0.0
			emit_signal("next_target", self)

func _physics_process(_delta: float) -> void:
	if not is_alive():
		self.visible = false
		return

	if agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	var target_pos = agent.get_next_path_position()
	var direction = (target_pos - global_position).normalized()
	var desired_velocity = direction * move_speed

	if direction.x < 0:
		sprite.flip_h = true
	elif direction.x > 0:
		sprite.flip_h = false

	velocity = velocity.lerp(desired_velocity, 0.2)
	move_and_slide()

func _target_check(target_unit: Unit):
	var dist = global_position.distance_to(target_unit.global_position)
	if dist <= attack_range:
		agent.target_position = global_position
		_attack_target(target_unit)
	else:
		agent.target_position = target_unit.global_position

func _attack_target(target_unit: Unit) -> void:
	var curr_time: float = Time.get_unix_time_from_system()
	var can_attack_rate: bool = (curr_time - last_attack_time) > attack_rate
	if can_attack_rate:
		target_unit.take_damage(damage)
		last_attack_time = curr_time

func move_to_location(location: Vector2) -> void:
	target = null
	agent.target_position = location

func set_target(new_target: Unit) -> void:
	if target and new_target != target:
		target.death.disconnect(_on_target_death)
	target = new_target
	if not target.death.is_connected(_on_target_death):
		target.death.connect(_on_target_death)

func _on_target_death(unit: Unit) -> void:
	if unit == target:
		agent.target_position = global_position
		last_target_check = 0.0
		target.death.disconnect(_on_target_death)
		target = null
		emit_signal("next_target", self)

func take_damage(amount: int) -> void:
	health -= amount

	# Flash red when hit
	sprite.modulate = Color.RED
	if hitflash_tween and hitflash_tween.is_running():
		hitflash_tween.kill()
	hitflash_tween = create_tween()
	(hitflash_tween.tween_property(sprite, "modulate", Color(1, 1, 1), 0.3)
		.set_trans(Tween.TRANS_LINEAR)
		.set_ease(Tween.EASE_IN_OUT))

	if health <= 0:
		emit_signal("death", self)
