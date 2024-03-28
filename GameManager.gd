extends Node

var points = 0

@onready var label = %Label

func add_points():
	points += 1
	print(points)
	print(label)
	label.text = "Points : " + str(points * 100)	


func _on_trophy_area_entered(area):
		get_tree().change_scene_to_file("res://scenes/level2.tscn")
