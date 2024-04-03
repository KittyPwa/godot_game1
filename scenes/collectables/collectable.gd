extends Area2D
@onready var pickup_cherry = %pickupCherry

@onready var game_manager = $"../../../GameManager"


func _on_body_entered(body):	
	if(body.name == "mainCharacter"):
		pickup_cherry.play()
		await pickup_cherry.finished
		game_manager.add_points()
		queue_free()
