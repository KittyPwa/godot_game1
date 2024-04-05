extends Node

var time = 0

@export var nextLevelPath : String
@onready var next_level = %NextLevel
@onready var scoreLabel = %score
@onready var timerLabel = %timer


func _ready():
	next_level.scenePath = nextLevelPath

func updateScoreAndTimer(score, time):
	scoreLabel.text = "Score : " + str(score)
	timerLabel.text = "Time : " + time
