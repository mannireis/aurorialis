extends SubViewport

var screen_size : Vector2

func _process(delta: float) -> void:
	screen_size = get_window().size
	size = screen_size
