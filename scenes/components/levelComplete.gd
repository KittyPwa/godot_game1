extends Node

@export var nextLevelPath : String
@onready var next_level = %NextLevel
@onready var scoreLabel = %score
@onready var timerLabel = %timer



func updateScenePath(path):
	next_level.scenePath = path

func updateScoreAndTimer(score, time):
	scoreLabel.text = "Score : " + str(score)
	timerLabel.text = "Time : " + time
