extends RigidBody2D

func _on_rigid_body_2d_body_entered(body):
	if(body.name == "CharacterBody2D"):
		print("entered")
