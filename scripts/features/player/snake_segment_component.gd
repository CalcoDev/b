class_name SnakeSegmentComponent
extends Node2D

@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
var _snake: SnakeComponent

@export var radius: float = 2.5
@export var follow_speed: float = 100.0

@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
var _position := Vector2.ZERO
@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
var _angle: float = 0.0
@warning_ignore("UNUSED_PRIVATE_CLASS_VARIABLE")
var _segment_index: int = 0
var _sine_offset := Vector2.ZERO

func _process(delta: float) -> void:
    var t := clampf(follow_speed * delta, 0.0, 1.0)
    
    # Apply sine wave offset if available
    var target_pos = _position
    if _sine_offset != Vector2.ZERO:
        target_pos += _sine_offset
        
    global_position = global_position.lerp(target_pos, t)
    rotation = lerp_angle(rotation, _angle, t)

# func _draw() -> void:
#     draw_circle(Vector2.ZERO, radius, Color.hex(0xed5d5dff))