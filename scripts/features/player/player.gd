class_name Player
extends CharacterBody2D

@export_group("Movement")
@export var max_speed: float = 200.0
@export var acceleration: float = 800.0 * 2.0
@export var deceleration: float = 600.0 * 2.0
@export var turn_speed: float = 900.0 * 2.0

@export_group("Shootings")
@export var gun_pivot: Node2D
@export var gun: Weapon

@export_group("Procedural Animation")
@export var snake_component: SnakeComponent
@export var snake_component_shadow: SnakeComponent
@export var shadow_offset: Vector2 = Vector2(0.0, 5.0)

@export var dodge_jump_force: float = 100.0
@export var dodge_jump_force_random: float = 0.2

@export var eyes: Node2D

var _dodge_offset := Vector2.ZERO

func _ready() -> void:
    snake_component.update(global_position)
    snake_component_shadow.update(global_position + shadow_offset)

func _process(_delta: float) -> void:
    snake_component.update(global_position + _dodge_offset)
    snake_component_shadow.update(global_position + shadow_offset)
    _dodge_offset = _dodge_offset.lerp(Vector2.ZERO, _delta * 5.0)
    eyes.position = Vector2.UP * -_dodge_offset.y

    if InputManager.instance.data.dodge_key.pressed:
        _dodge()
    
    var mouse_rot := (InputManager.instance.data.mouse_pos - global_position).angle()
    gun_pivot.global_rotation = mouse_rot
    gun.set("global_rotation", mouse_rot)
    if mouse_rot > PI / 2 or mouse_rot < -PI / 2:
        gun.set("scale", Vector2(1.0, -1.0))
    else:
        gun.set("scale", Vector2(1.0, 1.0))
    # v2.zero cuz we use fire point
    if InputManager.instance.data.shoot_primary_key.held:
        gun.fire(Vector2.ZERO, (InputManager.instance.data.mouse_pos - global_position).normalized())
    
    # for i in range(snake_component.segment_count):
    #     var segment := snake_component.get_segment(i)
    #     segment.non_calc_offset = segment.non_calc_offset.lerp(Vector2.ZERO, _delta * 5.0)

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

func _dodge() -> void:
    # apply a random amount of force to each snake segment
    # for i in range(snake_component.segment_count):
    #     var segment := snake_component.get_segment(i)
    #     var force := dodge_jump_force * randf_range(1.0 - dodge_jump_force_random, 1.0 + dodge_jump_force_random)
    #     segment.non_calc_offset = Vector2.UP * force
    var force := dodge_jump_force * randf_range(1.0 - dodge_jump_force_random, 1.0 + dodge_jump_force_random)
    _dodge_offset = Vector2.UP * force