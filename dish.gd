class_name dish extends Node2D

# Holds a 2D array of simulated pixels
var simulated_pixels = {}

func _init():
	pass

func add_simulated_pixel(sp):
	if sp is SimulatedPixel:
		# Using insertion sort
		simulated_pixels.append("lol")
