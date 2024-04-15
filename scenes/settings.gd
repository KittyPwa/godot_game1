extends Control

func _ready():
	SignalBus.connect("toggleSettings", switchSettings)

func switchSettings():
	visible = !visible
	

func _on_back_to_menu_pressed():
	SignalBus.call_deferred("set_level","res://scenes/levels/main_menu.tscn")
	


func _on_settings_pressed():
	SignalBus.toggleSetting()
