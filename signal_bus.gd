extends Node

signal hit_main_character
signal setLevel
signal resetMusic
signal hit_and_kill
signal completeLevel
signal togglePause
signal toggleSettings

var deathCounter = {}

var is_paused = false

var currentLevel = ''
var main_character_is_dead = true

func addToDeathCounter(levelPath):
	if !deathCounter.has(levelPath):
		deathCounter[levelPath] = 1
	else:
		deathCounter[levelPath] += 1

func getDeathCounter(levelPath):
	return deathCounter[levelPath] if deathCounter.has(levelPath) else 0


func complete_level():
	completeLevel.emit()

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

func toggleSetting():
	toggleSettings.emit()

func isGamePaused():
	return is_paused

func emitPause():
	togglePause.emit(is_paused)

func showPause():
	is_paused = !is_paused
	emitPause()
	

func set_level(level):
	var splitLevel = level.split("/")
	main_character_is_dead = true
	if ("level" in splitLevel[splitLevel.size() - 1]):
		main_character_is_dead = false
	setLevel.emit(level)
	updateLevel(level)
	is_paused = false
	emitPause()
	
func updateLevel(level):
	currentLevel = level
	
func reset_level():
	resetMusic.emit()
	main_character_is_dead = false
	setLevel.emit(currentLevel)
	is_paused = false
	emitPause()
