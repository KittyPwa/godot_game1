extends Area2D

func _on_area_entered(area):
	print(area.name)
	if area.name == "hitBox" && area.get_parent().name == "mainCharacter":
		SignalBus.hitMainCharacter()
