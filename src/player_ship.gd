extends CharacterBody2D

@export var speed = 400

var target = position

var holdingDownLeftMouseButton: bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				holdingDownLeftMouseButton = false
			else:
				holdingDownLeftMouseButton = true

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	look_at(target)
	if position.distance_to(target) > 10:
		move_and_slide()
	
	if (holdingDownLeftMouseButton):
		target = get_global_mouse_position()
		
# get_global_mouse_position()
