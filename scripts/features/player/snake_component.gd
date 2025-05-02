class_name SnakeComponent
extends Node

var _segments: Array[SnakeSegmentComponent] = []
# using this insead of distance as we care about the total length
@export var snake_length: float = 20.0
@export var angle_constraint: float = 180.0

var distance_constraint: float = 0.0:
    get():
        return snake_length / _segments.size()

@export var snake_position: Vector2 = Vector2.ZERO

var segment_count: int = 0:
    get():
        return _segments.size()

func _ready() -> void:
    for child in get_children():
        if child is SnakeSegmentComponent:
            child._snake = self
            child._segment_index = _segments.size()
            _segments.append(child)

func _process(_delta: float) -> void:
    for segment in _segments:
        segment.queue_redraw()

func update(head_position: Vector2 = snake_position) -> void:
    snake_position = head_position
    _segments[0]._angle = (snake_position - _segments[0].global_position).angle()
    _segments[0]._position = snake_position
    
    for i in _segments.size()-1:
        var curr_angle := (_segments[i]._position - _segments[i+1]._position).angle()
        _segments[i+1]._angle = _constrain_angle(curr_angle, _segments[i]._angle, angle_constraint)
        _segments[i+1]._position = _segments[i]._position - (v2_from_angle(_segments[i+1]._angle) * distance_constraint)
        
func v2_from_angle(angle: float) -> Vector2:
    return Vector2(cos(angle), sin(angle))

func get_segment(index: int) -> SnakeSegmentComponent:
    if _segments.size() > 0 and index >= 0 and index < _segments.size():
        return _segments[index]
    return null

func _constrain_angle(angle: float, anchor: float, constraint: float) -> float:
    if absf(_rel_angle_diff(angle, anchor)) <= constraint:
        return _simple_angle(angle)
    if _rel_angle_diff(angle, anchor) > constraint:
        return _simple_angle(anchor - constraint)
    return _simple_angle(anchor + constraint)

func _rel_angle_diff(angle: float, anchor: float) -> float:
    return _simple_angle(angle + PI - anchor)

func _simple_angle(angle: float) -> float:
    while angle >= TAU:
        angle -= TAU
    while angle < 0.0:
        angle += TAU
    return angle