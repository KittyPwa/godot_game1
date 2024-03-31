extends Node

signal hit_main_character
signal setLevel

var currentLevel = ''

func hitMainCharacter():
	hit_main_character.emit()

func set_level(level):
	setLevel.emit(level)
	updateLevel(level)
	
func updateLevel(level):
	currentLevel = level
	
func reset_level():
	setLevel.emit(currentLevel)
