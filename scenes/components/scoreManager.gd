extends CanvasLayer

@onready var game_over = %gameOver
@onready var level_completed = %levelCompleted
@onready var time = %Time
@onready var score = %score
@export var next_level_path : String

func _ready():
	level_completed.updateScenePath(next_level_path)

func show_game_over():
	game_over.visible = true

func set_game_over_score(points):
	game_over.set_score(points)

func show_level_completed():
	level_completed.visible = true

func update_level_completed(points, timeEllapsed):	
	level_completed.updateScoreAndTimer(points, timeEllapsed)

func update_score(points):
	score.text = "Points : " + points

func update_time(timeElapsed):
	time.text = "Time : " + timeElapsed
		
