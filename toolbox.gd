class_name Toolbox extends Control

func create_toolbox_item(on_click_callable, sp_name, sp_color):
	assert(on_click_callable is Callable, "on_click_callable must be of type Callable (function)")
	assert(sp_name is String, "sp_name must be of type String")
	assert(sp_color is Color, "sp_color must be of type Color")
	
	var toolbox_item = ToolboxItem.new(on_click_callable, sp_name, sp_color)
	$HorizontalContainer.add_child(toolbox_item)
