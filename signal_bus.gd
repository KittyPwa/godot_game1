extends Node

signal hit_main_character
signal setLevel
signal resetMusic
signal hit_and_kill

var currentLevel = ''
var main_character_is_dead = false

func hit(node):
	if node.name == "mainCharacter":
		hitMainCharacter()
	else:
		hit_and_kill.emit(node)

func hitMainCharacter():
	hit_main_character.emit()

func setMainCharacterDead():
	main_character_is_dead = true;

func is_main_character_dead():
	return main_character_is_dead;

func set_level(level):
	main_character_is_dead = false
	setLevel.emit(level)
	updateLevel(level)
	
func updateLevel(level):
	currentLevel = level
	
func reset_level():
	resetMusic.emit()
	main_character_is_dead = false
	setLevel.emit(currentLevel)
