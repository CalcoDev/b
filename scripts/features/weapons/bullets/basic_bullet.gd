extends CharacterBody2D

@export var hitbox_component: HitboxComponent

var vel := Vector2.ZERO
func init_bullet(params: ProjectileWeapon.BulletParams) -> void:
    global_position = params.position
    vel = params.direction * params.speed
    rotation = params.direction.angle()
    hitbox_component.collision_mask = params.collision_layers

func _ready() -> void:
    hitbox_component.on_hit.connect(_handle_on_hit)
    # await get_tree().create_timer(0.1).timeout
    await get_tree().process_frame
    physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_INHERIT

func _handle_on_hit(_obj: HurtboxComponent) -> void:
    destroy_bullet()

func destroy_bullet() -> void:
    queue_free()

func _physics_process(_delta: float) -> void:
    velocity = vel
    move_and_slide()
    if get_slide_collision_count() != 0:
        destroy_bullet()