class_name ProjectileWeapon
extends Weapon

class BulletParams:
    var position: Vector2
    var direction: Vector2
    var faction: FactionComponent
    var speed: float
    var collision_layers: int = 0
    
    @warning_ignore("shadowed_variable")
    func _init(p: Vector2, d: Vector2, f: FactionComponent, s: float, c: int) -> void:
        self.position = p
        self.direction = d
        self.faction = f
        self.speed = s
        self.collision_layers = c

@export_group("References")
@export var use_fire_point: bool = false
@export var fire_point_path: NodePath
var _fire_point: Node2D = null

@export var bullet_prefab: PackedScene

@export_group("Projectile Weapon Settings")
@export var bullet_count: int = 1
@export var bullet_spread: float = 0.0
@export var bullet_speed: float = 10.0

# Lifecycle
func _ready() -> void:
    super._ready()
    var fire_node = get_node(fire_point_path)
    assert(fire_node is Node2D)
    _fire_point = fire_node
    on_fired.connect(_handle_on_fired)

func _process(delta: float) -> void:
    super._process(delta)

# Event Handlers
func _handle_on_fired(fire_params: Weapon.FireParams) -> void:
    var container: Node = get_tree().get_first_node_in_group("bullet_container")
    assert(container != null)
    for i in bullet_count:
        var bullet = bullet_prefab.instantiate()
        assert("init_bullet" in bullet)
        var t = _fire_point.global_position if use_fire_point else fire_params.position
        var d = _apply_spread(fire_params.direction, bullet_spread)
        var bullet_params := BulletParams.new(t, d, faction, bullet_speed, fire_params.collision_layers)
        bullet.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
        container.add_child(bullet)
        bullet.init_bullet(bullet_params)

func _apply_spread(dir: Vector2, spread: float) -> Vector2:
    var spread_x := deg_to_rad(spread)
    var offset := randf_range(-spread_x / 2.0, spread_x / 2.0)
    return dir.normalized().rotated(offset)