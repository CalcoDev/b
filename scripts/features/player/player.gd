class_name Player
extends Node2D

@export_group("References")
@export var _rb: CharacterBody2D

@export_group("Movement")
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0 * 2.0
@export var deceleration: float = 600.0 * 2.0
@export var turn_speed: float = 900.0 * 2.0

func _enter_tree() -> void:
    _rb.top_level = true

func _process(_delta: float) -> void:
    self.global_position = _rb.global_position.round()

func _physics_process(delta: float) -> void:
    var inp := InputManager.instance.data.move_vec

    if inp.length_squared() > 0.0:
        var curr_dir := _rb.velocity.normalized()
        var target_dir := inp.normalized()
        var dot := curr_dir.dot(target_dir)
        if abs(dot) < 0.0:
            _rb.velocity = _rb.velocity.move_toward(Vector2.ZERO, turn_speed * delta)
        else:
            _rb.velocity = _rb.velocity.move_toward(target_dir * max_speed, acceleration * delta)
    else:
        _rb.velocity = _rb.velocity.move_toward(Vector2.ZERO, deceleration * delta)
    _rb.move_and_slide()
        