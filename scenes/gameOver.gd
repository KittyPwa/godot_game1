extends Node
@onready var label = %Label

func set_score(value):
	label.text = "Points : " + str(value)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level1.tscn")
