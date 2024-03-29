extends Node

@onready var game_manager = %GameManager


func _on_duck_2_main_character_is_dead():
	game_manager.game_over()


func _on_duck_main_character_is_dead():
	pass # Replace with function body.
