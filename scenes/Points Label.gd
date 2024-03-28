extends Label

@onready var points_label = %"Points Label"

func _on_update_point_ui(points):
	print("connected")
	points_label.text = "Points : " + str(points * 100)
