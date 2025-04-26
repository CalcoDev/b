class_name InputManager
extends Node2D

static var instance: InputManager

class Key:
    # pressed this frame
    var pressed := false
    # released this frame
    var released := false
    var held := false

    var held_time := 0.0
    var released_time := 0.0

    func update_from_input(name: StringName, delta: float) -> void:
        if self.pressed:
            self.held_time += delta
        else:
            self.held_time = 0.0
        
        if self.released:
            self.released_time += delta
        else:
            self.released_time = 0.0
        
        self.pressed = Input.is_action_just_pressed(name)
        self.released = Input.is_action_just_released(name)
        self.held = Input.is_action_pressed(name)

class Data:
    var move_vec := Vector2.ZERO
    var dodge_key := Key.new()

    var mouse_pos := Vector2.ZERO

var data := Data.new()
var update_process := true:
    set(value):
        update_process = value
        update_self = update_self
var update_self := true:
    set(value):
        update_self = value
        if update_self:
            if update_process:
                set_process(true)
            else:
                set_physics_process(true)
        else:
            set_process(false)
            set_physics_process(false)

func _enter_tree() -> void:
    self.instance = self
    # trigger updates
    self.update_process = true
    self.update_self = true

# todo: do this by instantiating order instead
func _ready() -> void:
    self.process_priority = -999

func _process(delta: float) -> void:
    self._update(delta)

func _physics_process(delta: float) -> void:
    self._update(delta)

func _update(delta: float) -> void:
    self.data.move_vec = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    self.data.dodge_key.update_from_input("dodge", delta)

    self.data.mouse_pos = get_global_mouse_position()