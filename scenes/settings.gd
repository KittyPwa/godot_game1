extends Node2D

@onready var background = %background


func _on_back_to_menu_pressed():
	background.reset()
	SignalBus.call_deferred("set_level","res://scenes/levels/main_menu.tscn")
	
