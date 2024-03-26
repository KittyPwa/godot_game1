extends Area2D
@onready var timer = %Timer

func _on_body_entered(body):
	print("touch")
	if(body.name == "CharacterBody2D"):
		timer.start()


func _on_timer_timeout():
	queue_free()
