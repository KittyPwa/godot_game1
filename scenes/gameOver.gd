extends Node
@onready var label = %Label
var tree = null

func _ready():
	tree = get_tree()

func set_score(value):
	label.text = "Points : " + str(value)

func _on_button_1_pressed():
	SignalBus.reset_level()


func _on_button_2_pressed():
	SignalBus.set_level("res://scenes/main_menu.tscn")

