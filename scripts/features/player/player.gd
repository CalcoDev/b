class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0 * 2.0
@export var deceleration: float = 600.0 * 2.0
@export var turn_speed: float = 900.0 * 2.0

@export_group("Procedural Animation")
@export var snake_component: SnakeComponent

func _ready() -> void:
    snake_component.update(global_position)

func _process(_delta: float) -> void:
    snake_component.update(global_position)

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

