extends Button


@export var scenePath : String
@export var is_reset : bool
@export var is_setting : bool

func _on_pressed():
	if is_reset :
		reset()
	elif is_setting:
		SignalBus.toggleSetting()
	else :
		SignalBus.call_deferred("set_level",scenePath)
	
func reset():	
	SignalBus.call_deferred("reset_level")

func show_setting():
	SignalBus.call_deferred("show_setting")
