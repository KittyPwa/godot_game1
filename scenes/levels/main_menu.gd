extends Node

@onready var background = %background


func _on_level_1_pressed():
	SignalBus.set_level("res://scenes/levels/level1.tscn")

func _on_level_2_pressed():
	SignalBus.set_level("res://scenes/levels/level2.tscn")
	
func _on_level_3_pressed():
	SignalBus.set_level("res://scenes/levels/level3.tscn")

func _on_level_4_pressed():
	SignalBus.set_level("res://scenes/levels/level4.tscn")

func _on_level_5_pressed():
	SignalBus.set_level("res://scenes/levels/level5.tscn")
	
func _on_level_6_pressed():
	SignalBus.set_level("res://scenes/levels/level6.tscn")

func _on_level_7_pressed():
	SignalBus.set_level("res://scenes/levels/level7.tscn")

func _on_settings_pressed():
	background.reset()
	SignalBus.set_level("res://scenes/settings.tscn")
