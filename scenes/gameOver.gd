extends Node
@onready var label = %Label
var tree = null


func _ready():
	tree = get_tree()

func _unhandled_input(event):
	if SignalBus.is_main_character_dead():
		if event is InputEventKey:
			if Input.is_action_just_pressed("jump"):
				reset()

func set_score(value):
	label.text = "Points : " + str(value)

func reset():
	SignalBus.reset_level()

func _on_button_1_pressed():
	reset()


func _on_button_2_pressed():
	SignalBus.set_level("res://scenes/main_menu.tscn")

