extends Timer

@onready var parent: Label = get_parent()

func _process(delta: float) -> void:
	if parent.visible == true and is_stopped():
		start()

func _on_timeout() -> void:
	stop()
	parent.visible = false
