extends CharacterBody2D

var can_move = true
const SPEED_X = 400.0
const SLOW_DOWN = 40.0
const JUMP_VELOCITY = -730.0
var jump_amount = 0
var animation_name = ""
@onready var sprite_2d = $Sprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func kill():
	can_move = false

func _physics_process(delta):
	if(can_move):	
		if(velocity.x != 0):
			animation_name = "running"
		else:
			if(velocity.y == 0):
				animation_name = "idle"
		# Add the gravity.
		if(velocity.y != 0):
			if(velocity.y < 0):
				animation_name = "jumping"
			else:
				if(jump_amount != 2):
					animation_name = "falling"
		if(jump_amount == 2):
			animation_name = "double_jump"
		sprite_2d.animation = animation_name
		if not is_on_floor():
			velocity.y += gravity * delta	
		else:
			jump_amount = 0
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			if is_on_floor():
				velocity.y = JUMP_VELOCITY
				jump_amount = 1
			else:
				if jump_amount == 1:
					velocity.y = JUMP_VELOCITY
					jump_amount = 2

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
