extends Area2D

@onready var game_manager = %GameManager

func _on_body_entered(body):
	print("test")
	if(body.name == "CharacterBody2D"):
		#game_manager.add_points()
		queue_free()