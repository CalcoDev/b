class_name SnakeSegmentComponent
extends Node2D

@export var radius: float = 10.0
@export var distance_constraint: float = 0.0
@export var connecting_segment: SnakeSegmentComponent = null
@export var follow_speed: float = 1.0

var _target_pos := Vector2.ZERO

func update(_delta: float) -> void:
    if connecting_segment == null:
        return

    var actual_dist_constraint := radius + connecting_segment.radius + distance_constraint

    var dir := (connecting_segment.global_position - _target_pos).normalized()
    var target_pos := connecting_segment.global_position - dir * actual_dist_constraint
    # global_position = global_position.move_toward(target_pos, 0.1)
    # global_position = global_position.lerp(target_pos, _delta * 10.0 * follow_speed)
    _target_pos = _target_pos.lerp(target_pos, _delta * 10.0 * follow_speed)

func _ready() -> void:
    _target_pos = global_position

func _process(_delta: float) -> void:
    update(_delta)
    # global_position = _target_pos.round()
    global_position = _target_pos