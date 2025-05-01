class_name SnakeSegmentComponent
extends Node2D

@export var radius: float = 10.0
@export var distance_constraint: float = 0.0
@export var connecting_segment: SnakeSegmentComponent = null
@export var follow_speed: float = 1.0
@export_range(0, PI) var max_angle_constraint: float = PI/2
@export var repulsion_strength: float = 0.5  # How strongly segments push each other

var segment_index: int = 0  # Will be set by the Player
var all_segments: Array[SnakeSegmentComponent] = []  # Will be populated by the Player

static func create_from_interpolation(start: SnakeSegmentComponent, end: SnakeSegmentComponent, fraction: float) -> SnakeSegmentComponent:
    var new_segment := SnakeSegmentComponent.new()
    new_segment.radius = lerpf(start.radius, end.radius, fraction)
    new_segment.distance_constraint = lerpf(start.distance_constraint, end.distance_constraint, fraction)
    new_segment.follow_speed = lerpf(start.follow_speed, end.follow_speed, fraction)
    new_segment.max_angle_constraint = lerpf(start.max_angle_constraint, end.max_angle_constraint, fraction)
    return new_segment

func update(_delta: float) -> void:
    if connecting_segment == null:
        return

    var actual_dist_constraint := radius + connecting_segment.radius + distance_constraint
    var dir_to_connecting := (connecting_segment.global_position - global_position).normalized()
    
    if connecting_segment.connecting_segment != null:
        var connecting_to_grandparent := (connecting_segment.connecting_segment.global_position - connecting_segment.global_position).normalized()
        var cur_angle := dir_to_connecting.angle()
        var parent_angle := connecting_to_grandparent.angle()
        var constrained_angle := constrain_angle(cur_angle, parent_angle, max_angle_constraint)
        dir_to_connecting = Vector2.from_angle(constrained_angle)
    
    var target_pos := connecting_segment.global_position - dir_to_connecting * actual_dist_constraint
    
    # Apply segment collision avoidance
    var repulsion := Vector2.ZERO
    for other in all_segments:
        # Skip self and segments we're directly connected to
        if other == self or other == connecting_segment:
            continue
            
        # Skip segments closer to the head (they will push us, not the other way around)
        if other.segment_index < segment_index:
            continue
            
        var dist_vec := global_position - other.global_position
        var distance := dist_vec.length()
        var min_distance := radius + other.radius
        
        # If overlapping, calculate repulsion
        if distance < min_distance:
            var overlap := min_distance - distance
            var repulsion_dir := dist_vec.normalized() if distance > 0 else Vector2.RIGHT
            var repulsion_force := repulsion_dir * overlap * repulsion_strength
            
            # Apply repulsion (we push the other segment)
            other.global_position -= repulsion_force
    
    global_position = global_position.lerp(target_pos, _delta * 10.0 * follow_speed)

func constrain_angle(angle: float, parent_angle: float, max_diff: float) -> float:
    var diff := wrapf(angle - parent_angle, -PI, PI)
    
    if abs(diff) > max_diff:
        return parent_angle + sign(diff) * max_diff
    
    return angle

func _draw() -> void:
    draw_circle(Vector2.ZERO, radius, Color.WHITE)
    if connecting_segment != null:
        draw_line(Vector2.ZERO, connecting_segment.global_position - global_position, Color.RED, radius)