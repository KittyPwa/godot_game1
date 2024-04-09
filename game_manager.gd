extends Node

var points = 0
var time = 0
var startTime = 0
var ongoing = true;

@onready var main_character = %mainCharacter
@onready var score_manager = %scoreManager


func _ready():
	SignalBus.connect("hit_main_character", hitMainCharacter)
	SignalBus.connect("setLevel", updateLevel)
	SignalBus.connect("hit_and_kill", hitAndKill)
	SignalBus.connect("completeLevel", completeLevel)
	if main_character:
		main_character.connect("dashed", update_dash)
	startTime = Time.get_ticks_msec()
	
func _process(_delta):
	if(ongoing):
		time = Time.get_ticks_msec() - startTime
		if score_manager != null:
			score_manager.update_time(str(snappedf(float(time)/ 1000,0.01)))		
		
	
func completeLevel():
	ongoing = false
	main_character.kill()
	score_manager.show_level_completed()
	score_manager.update_level_completed(points,str(snappedf(float(time)/ 1000,0.01)))
	

func hitAndKill(node):
	if(node.is_killable):
		node.kill()

func updateLevel(level):
	get_tree().change_scene_to_file(level)

func update_dash(dashAmount):
	score_manager.update_dashes(str(dashAmount))

func add_points():
	points += 100
	score_manager.update_score(str(points))

func hitMainCharacter():
	if(main_character.is_killable):
		main_character.kill()
		score_manager.show_game_over()
		score_manager.set_game_over_score(points)
		SignalBus.setMainCharacterDead()
		ongoing = false

