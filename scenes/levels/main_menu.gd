extends Node

@onready var background = %background

func _on_settings_pressed():
	SignalBus.toggleSetting()
