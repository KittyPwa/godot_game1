extends Node

signal hit_main_character
signal setLevel
signal resetMusic

var currentLevel = ''
var main_character_is_dead = false

func hitMainCharacter():
	hit_main_character.emit()
	main_character_is_dead = true

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
