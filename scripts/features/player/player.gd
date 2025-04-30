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

func _ready() -> void:
    for child in get_node(snake_segments_path).get_children():
        if child is SnakeSegmentComponent:
            _snake_segments.append(child)

func _process(delta: float) -> void:
    _snake_segments[0]._target_pos = self.global_position
    # for snake_segment in _snake_segments:
        # snake_segment.update(delta)
    
    # self.get_parent().get_node("KongleCamera").global_position = _rb.global_position

func _physics_process(delta: float) -> void:
    var inp := InputManager.instance.data.move_vec

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
        
