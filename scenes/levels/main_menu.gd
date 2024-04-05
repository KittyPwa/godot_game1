extends Node

@onready var background = %background

func _on_settings_pressed():
	background.reset()
	SignalBus.set_level("res://scenes/settings.tscn")
