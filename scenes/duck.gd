extends Area2D
@onready var game_manager = %GameManager

func _on_body_entered(body):
	if(body.name == "mainCharacter"):
		game_manager.game_over()
