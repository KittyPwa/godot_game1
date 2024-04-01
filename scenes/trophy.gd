extends Area2D

@export var targetLevelName : String

func _on_body_entered(body):
	if(body.name == "mainCharacter"):
		print(targetLevelName)
		SignalBus.call_deferred("set_level",targetLevelName)
