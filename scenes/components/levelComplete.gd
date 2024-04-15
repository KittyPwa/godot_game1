extends Node

@export var nextLevelPath : String
@onready var next_level = %NextLevel
@onready var scoreLabel = %score
@onready var timerLabel = %timer
@onready var deathsLabel = %deaths



func updateScenePath(path):
	next_level.scenePath = path

func updateData(score, time, deaths):
	scoreLabel.text = "Score : " + str(score)
	timerLabel.text = "Time : " + time
	deathsLabel.text = "Deaths : " + str(deaths)
