class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0 * 2.0
@export var deceleration: float = 600.0 * 2.0
@export var turn_speed: float = 900.0 * 2.0

@export_group("Procedural Animation")
@export_node_path("Node") var snake_segments_path := NodePath("")
var _snake_segments: Array[SnakeSegmentComponent] = []
@export var snake_segment_count: int = 20

func _ready() -> void:
    # Collect all snake segments
    var snake_segments_node := get_node(snake_segments_path)
    for child in snake_segments_node.get_children():
        if child is SnakeSegmentComponent:
            _snake_segments.append(child)
    
    # Spawn additional segments, by interpolating between existing segments
    # var segment_count := snake_segment_count - _snake_segments.size()
    # var segments_per_segment := floori(float(segment_count) / _snake_segments.size())
    # for i in _snake_segments.size()-1:
    #     var segment := _snake_segments[i]
    #     var next_segment := _snake_segments[i + 1]
    #     var conn_segment := segment
    #     for j in segments_per_segment:
    #         var fraction := float(j + 1) / (segments_per_segment + 1.0)
    #         var new_segment := SnakeSegmentComponent.create_from_interpolation(segment, next_segment, fraction)
    #         new_segment.modulate = Color(0, 1, 0, 1)
    #         new_segment.connecting_segment = conn_segment
    #         snake_segments_node.add_child(new_segment)
    #         new_segment.distance_constraint = 1.0
    #         new_segment.radius = 1.0
    #         new_segment.follow_speed *= 10.0
    #         new_segment.global_position = segment.global_position.lerp(next_segment.global_position, fraction)
    #         _snake_segments.append(new_segment)
    #         conn_segment = new_segment
    #         # connect_to_segment = new_segment
    #     next_segment.connecting_segment = conn_segment
        
    #     if next_segment != segment:
    #         next_segment.connecting_segment = connect_to_segment

    # # Set index and provide reference to all segments for each segment
    # for i in range(_snake_segments.size()):
    #     _snake_segments[i].segment_index = i
    #     _snake_segments[i].all_segments = _snake_segments
    #     _snake_segments[i].name = "SnakeSegment" + str(i)

func _process(delta: float) -> void:
    _snake_segments[0].global_position = self.global_position
    for snake_segment in _snake_segments:
        snake_segment.update(delta)
        snake_segment.queue_redraw()

func _physics_process(delta: float) -> void:
    var inp := InputManager.instance.data.move_vec
    # var inp := (get_global_mouse_position() - global_position).normalized()

    if inp.length_squared() > 0.0:
        var curr_dir := self.velocity.normalized()
        var target_dir := inp.normalized()
        var dot := curr_dir.dot(target_dir)
        if abs(dot) < 0.0:
            self.velocity = self.velocity.move_toward(Vector2.ZERO, turn_speed * delta)
        else:
            self.velocity = self.velocity.move_toward(target_dir * max_speed, acceleration * delta)
    else:
        self.velocity = self.velocity.move_toward(Vector2.ZERO, deceleration * delta)
    self.move_and_slide()

