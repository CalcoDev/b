extends Sprite2D

@export var radius: float = 2.5

func _process(_delta: float) -> void:
    # self.global_position = self.global_position.round()
    queue_redraw()

func _draw() -> void:
    var dir := (InputManager.instance.data.mouse_pos - global_position).normalized() * radius
    draw_circle(dir, 2, Color.hex(0xed5d5dff))