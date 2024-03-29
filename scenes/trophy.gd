extends Area2D

@export var targetLevel : PackedScene

func _on_body_entered(body):
	if(body.name == "mainCharacter"):
		get_tree().change_scene_to_packed(targetLevel)
