extends Area2D

func _on_area_entered(area):
	if area.get_parent().name == "mainCharacter":
		SignalBus.hitMainCharacter()
