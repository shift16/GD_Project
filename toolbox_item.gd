class_name ToolboxItem extends Control

var func_to_call

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			func_to_call.call()

func _process(delta):
	var SP_Color = $Background/SP_Color
	SP_Color.rotation = SP_Color.rotation + (delta)

func _init(on_click_callable, sp_name, sp_color):
	assert(on_click_callable is Callable, "on_click_callable must be of type Callable (function)")
	assert(sp_name is String, "sp_name must be of type String")
	assert(sp_color is Color, "sp_color must be of type Color")
	
	func_to_call = on_click_callable
	
	$Background/SP_Color.color = sp_color
	$Background/SP_Name.text = sp_name
