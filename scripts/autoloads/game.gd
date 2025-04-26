class_name Game
extends Node

static var instance: Game

var _fulscr := false

#region Lifecycle
func _enter_tree() -> void:
    instance = self
    ProjectSettings.set_setting("rendering/2d/snap/snap_2d_vertices_to_pixel", true)

func _process(_delta: float) -> void:
    if Input.is_action_just_pressed("fullscreen"):
        _fulscr = !_fulscr
        if _fulscr:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        else:
            DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
#endregion

#region Api
func hitstop(duration: float, time_scale: float = 0.001) -> void:
    var t := Engine.time_scale
    Engine.time_scale = time_scale
    await get_tree().create_timer(duration, true, false, true).timeout
    Engine.time_scale = t

func pause() -> void:
    get_tree().paused = true

func unpause() -> void:
    get_tree().paused = false
#endregion