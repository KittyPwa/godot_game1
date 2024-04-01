extends CharacterBody2D

var can_move = true
const SPEED_X = 400.0
const SLOW_DOWN = 40.0
const JUMP_VELOCITY = -730.0
const WALL_JUMP_EXTRA_VELOCITY = -365.0
var jump_amount = 0
var animation_name = ""
var was_on_floor = false
var wall_jumped = false
@onready var coyote_timer = %coyoteTimer

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
		
		var direction_x = Input.get_axis("left", "right")
		
		if not is_on_floor():
			velocity.y += gravity * delta	
		else:
			jump_amount = 1
			wall_jumped = false
		
		if direction_x:
			velocity.x = direction_x * SPEED_X
		else:
			velocity.x = move_toward(velocity.x, 0, SLOW_DOWN)
			
		if was_on_floor and !is_on_floor():
			coyote_timer.start()
		if is_on_ceiling():
			wall_jumped = false
			jump_amount = 1
		# Handle jump.
		if Input.is_action_just_pressed("jump"):
			var do_jump = false
			var extra_jump_power = 0
			if is_on_floor() or !coyote_timer.is_stopped():
				do_jump = true
				jump_amount = 1
			elif is_on_wall_only() && !wall_jumped:
				extra_jump_power = WALL_JUMP_EXTRA_VELOCITY
				do_jump = true				
				wall_jumped = true
				jump_amount = 1
			elif jump_amount == 1:
				do_jump = true				
				jump_amount = 2
			if do_jump:
				velocity.y = JUMP_VELOCITY + extra_jump_power
			

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		
		
		was_on_floor = is_on_floor()
		
			
		move_and_slide()
		
		var is_left = velocity.x < 0
		sprite_2d.flip_h = is_left
