class_name PlayerShip extends CharacterBody2D

enum Weapon {
	ORB,
	MISSLE,
	# BULLET,
	# LASER # Not adding
}

const ACCELERATION: float = 50
const DECELERATION: float = 60
const SPEED: float = 500
const SHIP_ASSETS: Dictionary = {
	'full': preload('res://assets/void_assets/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Full health.png'),
	'slight': preload('res://assets/void_assets/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Slight damage.png'),
	'damaged': preload('res://assets/void_assets/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Damaged.png'),
	'very_damaged': preload('res://assets/void_assets/Main Ship/Main Ship - Bases/PNGs/Main Ship - Base - Very damaged.png')
}

var acceleration: Vector2 = Vector2.ZERO

var start: bool = false

var warp_amount: float = 0

var holding_mouse_button: bool = false

var direction: Vector2 = Vector2.ZERO

var hit_points: int = 16

var warping: bool = false

var weapon_active: bool = false
var current_weapon: Weapon = Weapon.ORB

const PROJECTILE_SCENES: Dictionary = {
	Weapon.ORB: preload('res://scenes/orb_projectile.tscn'),
	Weapon.MISSLE: preload('res://scenes/missle.tscn')
	# Weapon.BULLET: null
}

const COOLDOWNS: Dictionary = {
	Weapon.ORB: 0.6,
	Weapon.MISSLE: 2,
	# Weapon.BULLET: 0.2
}

var current_cooldowns: Dictionary = COOLDOWNS.duplicate()

@onready var particle_effect: CPUParticles2D = $CPUParticles2D

@onready var game_over_menu: RichTextLabel = get_parent().get_node('CanvasLayer/GameOver')
func game_over():
	game_over_menu.visible = true
	start = false
	get_tree().paused = true

func update_asset():
	if hit_points > 10:
		$Sprite2D.texture = SHIP_ASSETS.full
	elif hit_points > 7:
		$Sprite2D.texture = SHIP_ASSETS.slight
	elif hit_points > 3:
		$Sprite2D.texture = SHIP_ASSETS.damaged
	elif hit_points > 0:
		$Sprite2D.texture = SHIP_ASSETS.very_damaged
	elif hit_points < 0:
		game_over()

func apply_damage(amount: int):
	hit_points -= amount
	update_asset()

@onready var current_weapon_ui: RichTextLabel = get_parent().get_node('CanvasLayer/CurrentWeapon')

func change_weapon():
	if current_weapon == Weapon.ORB:
		current_weapon = Weapon.MISSLE
		current_weapon_ui.text = "[center][b]Missile[/b][/center]"
	else:
		current_weapon = Weapon.ORB
		current_weapon_ui.text = "[center][b]Orb Launcher[/b][/center]"

@onready var the_world: Timer = get_parent().get_node('WorldGenerator')
var debounce: float = 0

func _input(event):
	if !the_world.is_stopped() and start == true:
		if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.is_released():
					holding_mouse_button = false
				else:
					holding_mouse_button = true
			
			if event.button_index == MOUSE_BUTTON_RIGHT:
				if event.is_released():
					handle_warp()
			
			if debounce <= 0:
				debounce = 0.15
				if event.button_index == MOUSE_BUTTON_WHEEL_UP:
					change_weapon()
				elif  event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
					change_weapon()
		
		if event is InputEventKey:
			if event.pressed and event.keycode == KEY_SPACE:
				weapon_active = true
			elif !event.pressed and event.keycode == KEY_SPACE:
				weapon_active = false

func _ready() -> void:
	for key in current_cooldowns:
		current_cooldowns[key] = 0

func find_closest_asteroid() -> Asteroid:
	var children: Array[Node] = get_parent().get_children()
	var smallest_length: float = INF
	var closest_ast: Asteroid
	
	for node in children:
		if node is Asteroid:
			var dist: float = (node.position - position).length()
			if dist < smallest_length:
				smallest_length = dist
				closest_ast = node
				
	return closest_ast
				

func _process(delta: float) -> void:
	if start == true:
		debounce = max(debounce - delta, 0)
		
		for key in current_cooldowns.keys():
			if current_cooldowns[key] > 0:
				current_cooldowns[key] -= delta
		
		if weapon_active == true:
			var proj: SpaceProjectile = PROJECTILE_SCENES[current_weapon].instantiate()
			
			if current_weapon == Weapon.ORB:
				if current_cooldowns[Weapon.ORB] <= 0:
					current_cooldowns[Weapon.ORB] += COOLDOWNS[Weapon.ORB]
					
					proj.direction = direction
					proj.position = self.position
					proj.relative_unit = self
					get_parent().add_child(proj)
			elif current_weapon == Weapon.MISSLE:
				if current_cooldowns[Weapon.MISSLE] <= 0:
					current_cooldowns[Weapon.MISSLE] += COOLDOWNS[Weapon.MISSLE]
					proj = proj as MissleProjectile
					
					proj.position = self.position
					proj.target = find_closest_asteroid()
					get_parent().add_child(proj)

func _physics_process(delta):
	if start == true:
		# We only want the direction to the mouse
		var mouse_pos = get_global_mouse_position()
		var mouse_dir = (mouse_pos - position).normalized()
		var desired_velocity = (position - mouse_pos).normalized() * SPEED
		
		if warping != true:
			if holding_mouse_button:
				particle_effect.emitting = true
				velocity *= ACCELERATION * delta
				var steering_accel = (velocity - desired_velocity).normalized() * 50
				
				if velocity.length() < SPEED:
					velocity += steering_accel
				else:
					velocity = velocity.normalized() * SPEED
			else:
				particle_effect.emitting = false
				velocity = velocity - (velocity.normalized() * DECELERATION * delta)
		
		if velocity.length() > 1:
			direction = velocity.normalized()
			look_at(position + velocity)
			
			if warping != true:
				position += (velocity * delta)

# The warp mechanic
@onready var entered_galaxy_label: Label = get_parent().get_node('CanvasLayer/EnteredGalaxyLabel')
@onready var warp_bar: ProgressBar = get_parent().get_node("CanvasLayer/WarpPower")
@onready var warp_menu: Control = $WarpMenu
@onready var warp_rects: Array[ColorRect] = [
	warp_menu.get_node('Warp1'),
	warp_menu.get_node('Warp2'),
	warp_menu.get_node('Warp3'),
	warp_menu.get_node('Warp4'),
	warp_menu.get_node('Warp5')
]

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

func _on_warp_timer_timeout() -> void:
	if start == true and warping == false:
		if warp_amount <= 99:
			warp_amount += 1
		warp_bar.value = warp_amount

func handle_warp():
	if warp_menu.visible == false:
		if warp_amount > 40:
			warping = true
			warp_menu.visible = true
			get_tree().paused = true
			for rect in warp_rects:
				rect.color = Color.from_hsv(
					rng.randf(),
					rng.randf(),
					rng.randf()).lightened(0.25)
	else:
		warping = false
		warp_menu.visible = false
		get_tree().paused = false

func warp(col: Color):
	warping = false
	warp_menu.visible = false
	get_tree().paused = false
	warp_amount -= 40
	entered_galaxy_label.text = "Entered Galaxy: " + col.to_html(false)
	entered_galaxy_label.visible = true
	var children: Array[Node] = get_parent().get_children()
	handle_quest(col)
	
	for node in children:
		if node is Asteroid or node is SpaceProjectile or node is MissleProjectile:
			node.queue_free()
		
		the_world.random_handler = RandomNumberGenerator.new()

func _on_warp_1_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				warp(warp_rects[0].color)

func _on_warp_2_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				warp(warp_rects[1].color)

func _on_warp_3_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				warp(warp_rects[2].color)

func _on_warp_4_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				warp(warp_rects[3].color)

func _on_warp_5_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				warp(warp_rects[4].color)

# Simple quest handler
@onready var quest_label: Label = get_parent().get_node('CanvasLayer/QuestText')
@onready var quest_extra_info_label: Label = quest_label.get_node('ExtraInfo')
const COLOR_RANGE_THRESHOLD: float = 0.5
const QUEST_COLORS: Array[Color] = [Color("1a285a"), Color("3b5842"), Color("a99041")]
var current_quest: int = 0
var completed_quest: bool = false

func col_is_close(col: Color, to_col: Color) -> bool:
	var col_diff: Color = col - to_col
	if abs(col_diff.r) <= COLOR_RANGE_THRESHOLD and abs(col_diff.g) <= COLOR_RANGE_THRESHOLD and abs(col_diff.b) <= COLOR_RANGE_THRESHOLD:
		return true
	else:
		return false

func handle_quest(col: Color):
	if completed_quest == false:
		if col_is_close(col, QUEST_COLORS[current_quest]):
			current_quest += 1
			if current_quest != 3:
				quest_label.text = "Warp back to the Milky way!\nWarp to a galaxy close to:\n" + QUEST_COLORS[current_quest].to_html(false)
			elif current_quest == 3:
				quest_label.text = "Congrats!\nYou've made it to the Milky Way Galaxy!\nIt's going to take a while to get back to Earth so sit back and relax"
				quest_extra_info_label.visible = false
				game_over_menu.text = "[b] SUCCESS! [/b]"
				game_over_menu.visible = true
				completed_quest = true
				start = false
				get_tree().paused = true
