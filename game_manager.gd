extends Node

var points = 0

@onready var game_over_node = %gameOver
@onready var main_character = %mainCharacter
@export var selfName : String

@onready var label = %Label

func _ready():
	SignalBus.connect("hit_main_character", game_over)
	SignalBus.connect("setLevel", updateLevel)

func updateLevel(level):
	
	get_tree().change_scene_to_file(level)

func add_points():
	points += 100
	label.text = "Points : " + str(points)	

func game_over():
	main_character.kill()
	game_over_node.set_score(points)
	game_over_node.visible = true
	

func _on_trophy_area_entered(area):
	SignalBus.set_level("res://scenes/level2.tscn")
