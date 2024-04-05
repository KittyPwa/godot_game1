extends Node

var points = 0

@onready var game_over_node = %gameOver
@onready var main_character = %mainCharacter

@onready var label = %Label

func _ready():
	SignalBus.connect("hit_main_character", hitMainCharacter)
	SignalBus.connect("setLevel", updateLevel)
	SignalBus.connect("hit_and_kill", hitAndKill)
	

func hitAndKill(node):
	if(node.is_killable):
		node.kill()

func updateLevel(level):
	get_tree().change_scene_to_file(level)

func add_points():
	points += 100
	label.text = "Points : " + str(points)	

func hitMainCharacter():
	if(main_character.is_killable):
		main_character.kill()
		game_over_node.set_score(points)
		game_over_node.visible = true
		SignalBus.setMainCharacterDead()

