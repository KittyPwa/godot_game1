extends CharacterBody2D


const SPEED_X = 400.0
const SLOW_DOWN = 30.0
const JUMP_VELOCITY = -730.0
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if(velocity.x != 0):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "idle"
	# Add the gravity.
	if(velocity.y != 0):
		if(velocity.y < 0):
			sprite_2d.animation = "jumping"
		else:
			sprite_2d.animation = "falling"
	if not is_on_floor():
		velocity.y += gravity * delta		

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = Input.get_axis("left", "right")
	if direction_x:
		velocity.x = direction_x * SPEED_X
	else:
		velocity.x = move_toward(velocity.x, 0, SLOW_DOWN)

	move_and_slide()
	
	var is_left = velocity.x < 0
	sprite_2d.flip_h = is_left
