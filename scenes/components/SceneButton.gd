extends Button


@export var scenePath : String
@export var is_reset : bool

func _on_pressed():
	if is_reset :
		reset()
	else :
		print(scenePath)
		SignalBus.call_deferred("set_level",scenePath)
	
func reset():	
	SignalBus.call_deferred("reset_level")
