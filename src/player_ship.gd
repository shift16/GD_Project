class_name PlayerShip extends CharacterBody2D

const acceleration: float = 50
const deceleration: float = 60

var holding_mouse_button: bool = false

var ProjectileScene: Resource = preload("res://scenes/projectile.tscn")

var direction: Vector2 = Vector2.ZERO

var hit_points: int = 10

@onready var particle_effect: CPUParticles2D = $CPUParticles2D

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				holding_mouse_button = false
			else:
				holding_mouse_button = true
	
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_SPACE:
			var proj: Area2D = ProjectileScene.instantiate()
			proj.direction = direction
			proj.position = self.position
			proj.relative_unit = self
			get_parent().add_child(proj)

func _physics_process(delta):
	# We only want the direction to the mousev                               
	var mouse_dir = (get_global_mouse_position() - position).normalized()
	
	if holding_mouse_button:
		particle_effect.emitting = true
		velocity += mouse_dir * acceleration * delta
	else:
		particle_effect.emitting = false
		velocity -= velocity.normalized() * deceleration * delta
	
	if velocity.length() > 1:
		direction = velocity.normalized()
		look_at(position + velocity)
	
		position += velocity * delta
