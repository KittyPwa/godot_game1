extends Node
@onready var label = %Label
var tree = null

func _ready():
	tree = get_tree()

func set_score(value):
	label.text = "Points : " + str(value)

func _on_button_pressed():
	tree.change_scene_to_file("res://scenes/level1.tscn")


func _on_button_2_pressed():
	tree.change_scene_to_file("res://scenes/main_menu.tscn")
