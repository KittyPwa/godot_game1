extends Node

var points = 0
var time = 0
var startTime = 0
var ongoing = true;
var pauseTime = 0
var lastPause = 0
var totalPauseTime = 0
var lastPauseStart = null
var deathCounter = 0

@export var levelPath: String

@onready var main_character = %mainCharacter
@onready var score_manager = %scoreManager


func _ready():
	SignalBus.connect("hit_main_character", hitMainCharacter)
	SignalBus.connect("setLevel", updateLevel)
	SignalBus.connect("hit_and_kill", hitAndKill)
	SignalBus.connect("completeLevel", completeLevel)
	startTime = Time.get_ticks_msec()
	
func _process(_delta):
	if(ongoing):
		if SignalBus.isGamePaused():
			pauseTime = totalPauseTime + Time.get_ticks_msec() - lastPauseStart
		time = Time.get_ticks_msec() - startTime - pauseTime
		if score_manager != null:
			score_manager.update_time(str(snappedf(float(time)/ 1000,0.01)))

func _unhandled_input(event):
		if event is InputEventKey:
			if !SignalBus.is_main_character_dead():
				if Input.is_action_just_pressed("reset"):
					SignalBus.call_deferred("reset_level")
				if Input.is_action_just_pressed("escape"):
					SignalBus.showPause()
					lastPauseStart = Time.get_ticks_msec()
					if !SignalBus.isGamePaused():
						totalPauseTime = pauseTime
					
func completeLevel():
	ongoing = false
	main_character.kill()
	score_manager.show_level_completed()
	score_manager.update_level_completed(points,str(snappedf(float(time)/ 1000,0.01)), SignalBus.getDeathCounter(levelPath))
	

func hitAndKill(node):
	if(node.is_killable):
		node.kill()

func updateLevel(level):
	get_tree().change_scene_to_file(level)

func add_points():
	points += 100
	score_manager.update_score(str(points))

func hitMainCharacter():
	if(main_character.is_killable && !SignalBus.is_main_character_dead()):
		SignalBus.addToDeathCounter(levelPath)
		main_character.kill()
		score_manager.show_game_over()
		score_manager.set_game_over_data(points,SignalBus.getDeathCounter(levelPath))
		SignalBus.setMainCharacterDead()
		ongoing = false

