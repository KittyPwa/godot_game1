extends Node

var points = 0
var time = 0
var startTime = 0
var ongoing = true;

@onready var game_over_node = %gameOver
@onready var main_character = %mainCharacter
@onready var level_completed = %levelCompleted

@onready var label = %Label
@onready var timeLabel = %Time

func _ready():
	SignalBus.connect("hit_main_character", hitMainCharacter)
	SignalBus.connect("setLevel", updateLevel)
	SignalBus.connect("hit_and_kill", hitAndKill)
	SignalBus.connect("completeLevel", completeLevel)
	startTime = Time.get_ticks_msec()
	
func _process(_delta):
	if(ongoing):
		time = Time.get_ticks_msec() - startTime
		if timeLabel != null:
			timeLabel.text = "Time : " + str(snappedf(float(time)/ 1000,0.01))
	
func completeLevel():
	ongoing = false
	main_character.kill()
	level_completed.visible = true
	level_completed.updateScoreAndTimer(points, str(snappedf(float(time)/ 1000,0.01)))
	

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
		ongoing = false

