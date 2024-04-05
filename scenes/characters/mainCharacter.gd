extends CharacterBody2D

var can_move = true
const MAX_SPEED_X = GlobalVars.constants.mainCharacter.MAX_SPEED_X
const INC_SPEED_X = GlobalVars.constants.mainCharacter.INC_SPEED_X
const SLOW_DOWN = GlobalVars.constants.mainCharacter.SLOW_DOWN
const JUMP_VELOCITY = GlobalVars.constants.mainCharacter.JUMP_VELOCITY
const WALL_JUMP_EXTRA_VELOCITY = GlobalVars.constants.mainCharacter.WALL_JUMP_EXTRA_VELOCITY
const DASH_SPEED = GlobalVars.constants.mainCharacter.DASH_SPEED
const DASH_ROTATION = GlobalVars.constants.mainCharacter.DASH_ROTATION
const DASH_SKEW = GlobalVars.constants.mainCharacter.DASH_SKEW
var dashing_up = false
var x_speed = 0.0
var jump_amount = 0
var animation_name = ""
var was_on_floor = false
var wall_jumped = false
var is_dashing = false
var dash_counter = 1

@onready var coyote_timer = %coyoteTimer
@onready var dash_timer = %dashTimer


@onready var sprite_2d = $Sprite2D

@onready var jump_sound = %jumpSound
@onready var double_jump_sound = %doubleJumpSound
@onready var wall_jump = %wallJump
@onready var cieiling_hit = %cieilingHit
@onready var ceiling_hit_particels = %ceilingHitParticels
@export var is_killable : bool


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func kill():
	can_move = false

func manage_animations():
	var upsideDown = false
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
	if is_dashing:
		animation_name = "dash"
	sprite_2d.animation = animation_name

func manage_x_movement():
	var direction_x = Input.get_axis("left", "right")
	var velocity_x = 0
	if direction_x:
		if is_on_floor():
			velocity_x = MAX_SPEED_X * direction_x if abs(velocity.x) > MAX_SPEED_X else velocity.x + direction_x * INC_SPEED_X
		else:
			velocity_x = MAX_SPEED_X * direction_x
	else:
		velocity_x = move_toward(velocity.x, 0, SLOW_DOWN)
	if is_dashing:
		if !dashing_up && direction_x == 0:
			print('not dashing up')
			direction_x = 1
		velocity_x = DASH_SPEED * direction_x
		print(velocity_x)
		#skew_and_rotate(DASH_SKEW,DASH_ROTATION, direction_x)
	velocity.x = velocity_x

func manage_y_movement(delta):
	var velocity_y = velocity.y
	if not is_on_floor():
		velocity_y += gravity * delta	
	else:
		jump_amount = 1
		wall_jumped = false		
		
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	if is_on_ceiling():
		wall_jumped = false
		jump_amount = 1
		cieiling_hit.play()
		ceiling_hit_particels.emit()
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		var do_jump = false
		var extra_jump_power = 0
		if is_on_floor() or !coyote_timer.is_stopped():
			do_jump = true
			jump_amount = 1
			jump_sound.play()
		elif is_on_wall_only() && !wall_jumped:
			extra_jump_power = WALL_JUMP_EXTRA_VELOCITY
			do_jump = true				
			wall_jumped = true
			jump_amount = 1
			wall_jump.play()
		elif jump_amount == 1:
			do_jump = true				
			jump_amount = 2
			double_jump_sound.play()
		if do_jump:
			velocity_y = JUMP_VELOCITY + extra_jump_power
	if is_dashing:
		if !dashing_up:
			velocity_y = velocity.y
		if Input.is_action_pressed("aim_up") && !dashing_up:
			dashing_up = true
			velocity_y = DASH_SPEED * -1
	velocity.y = velocity_y
func _physics_process(delta):
	if(can_move):	
		if Input.is_action_just_pressed("dash") && dash_counter > 0 && dash_timer.is_stopped():
			is_dashing = true
			#dash_counter -= 1
			self.is_killable = false
			dash_timer.start()
		manage_animations()
		manage_y_movement(delta)	
		manage_x_movement()
		
		was_on_floor = is_on_floor()
		
		move_and_slide()
		
		var is_left = velocity.x < 0
		sprite_2d.flip_h = is_left

func skew_and_rotate(skew, rotation, direction):
	sprite_2d.skew = skew
	sprite_2d.rotation = rotation * direction

func _on_dash_timer_timeout():
	is_dashing = false
	self.is_killable = true
	dashing_up = false
	#skew_and_rotate(0,0,0)

func _on_hit_box_area_entered(area):	
	var parent = area.get_parent()
	if !is_killable && "is_killable" in parent:
		SignalBus.hit(parent)
