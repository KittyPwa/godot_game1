extends Node


func _on_level_1_pressed():
	SignalBus.set_level("res://scenes/level1.tscn")

func _on_level_2_pressed():
	SignalBus.set_level("res://scenes/level2.tscn")
	
func _on_level_3_pressed():
	SignalBus.set_level("res://scenes/level3.tscn")

func _on_level_4_pressed():
	SignalBus.set_level("res://scenes/level4.tscn")
