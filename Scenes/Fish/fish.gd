extends CharacterBody2D
class_name Fish

@export var max_speed: float = 60
@export var max_force: float = 8.0

var target_pos: Vector2

func _new_target() -> void:
	target_pos = Vector2(randf_range(-60, 60), randf_range(-40, -20))

func _ready() -> void:
	position = Vector2(randf_range(-10, 10), randf_range(-40, 0))
	_new_target()

func _physics_process(delta: float) -> void:
	if position.distance_to(target_pos) < 1:
		_new_target()

	velocity += _seek()

	move_and_slide()

func _seek() -> Vector2:
	var desired := (target_pos - global_position).normalized() * max_speed

	var steer := desired - velocity
	if steer.length() > max_force:
		steer = steer.normalized() * max_force
	return steer
