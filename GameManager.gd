extends Node

var points = 0

@onready var game_over_node = %gameOver
@onready var main_character = %mainCharacter

@onready var label = %Label


func add_points():
	points += 100
	label.text = "Points : " + str(points)	

func game_over():
	main_character.kill()
	game_over_node.set_score(points)
	game_over_node.visible = true
	

func _on_trophy_area_entered(area):
	get_tree().change_scene_to_file("res://scenes/level2.tscn")



