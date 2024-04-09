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
var dash_counter = 0
var just_dashed = false;
var last_delta
var is_frozen = false

@onready var coyote_timer = %coyoteTimer
@onready var dash_timer = %dashTimer
@onready var frozen_timer = %frozenTimer


@onready var sprite_2d = $Sprite2D
@onready var dash_hitbox = %dashHitbox

@onready var jump_sound = %jumpSound
@onready var double_jump_sound = %doubleJumpSound
@onready var wall_jump = %wallJump
@onready var cieiling_hit = %cieilingHit
@onready var ceiling_hit_particels = %ceilingHitParticels
@export var is_killable : bool
@export var can_double_jump : bool
@export var can_wall_jump : bool
@export var can_dash : bool
var ignore_y_freeze = false
signal dashed

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	call_deferred("updateDashes",1)

func kill():
	can_move = false

func manage_animations():
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
	if direction_x && !is_dashing:
		if is_on_floor():
			velocity_x = MAX_SPEED_X * direction_x if abs(velocity.x) > MAX_SPEED_X else velocity.x + direction_x * INC_SPEED_X
		else:
			velocity_x = MAX_SPEED_X * direction_x
	else:
		velocity_x = MAX_SPEED_X * direction_x if abs(velocity_x) > MAX_SPEED_X else velocity_x
		velocity_x = move_toward(velocity_x, 0, SLOW_DOWN)
	if is_dashing:
		var direction_y = Input.get_axis("aim_up", "crouch")
		if !direction_y && direction_x == 0:
			direction_x = 1
		velocity_x = DASH_SPEED * direction_x	
	if is_frozen && !ignore_y_freeze:
		velocity_x = 0
	#print(velocity_x)
	velocity.x = velocity_x

func touch_floor():
	jump_amount = 0
	wall_jumped = false	
	
func ceiling_jump_resets():
	wall_jumped = false
	jump_amount = 1

func touch_ceiling():
	ceiling_jump_resets()
	cieiling_hit.play()
	if ceiling_hit_particels.emitting:
		ceiling_hit_particels.restart()
	else:
		ceiling_hit_particels.emit()

func manage_y_movement(delta):
	var velocity_y = velocity.y
	if not is_on_floor():
		velocity_y += gravity * delta	
	else:
		touch_floor()
	
	if was_on_floor and !is_on_floor():
		coyote_timer.start()
	if is_on_ceiling():
		touch_ceiling()
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		var do_jump = false
		if is_frozen:
			ignore_y_freeze = true
			
		var extra_jump_power = 0
		if (is_on_floor() or !coyote_timer.is_stopped()) && jump_amount == 0:
			do_jump = true
			jump_amount = 1
			jump_sound.play()
		elif can_wall_jump && (is_on_wall_only() && !wall_jumped):
			extra_jump_power = WALL_JUMP_EXTRA_VELOCITY
			do_jump = true				
			wall_jumped = true
			jump_amount = 1
			wall_jump.play()
		elif can_double_jump && jump_amount == 1:
			do_jump = true				
			jump_amount = 2
			double_jump_sound.play()
		if do_jump:
			velocity_y = JUMP_VELOCITY + extra_jump_power
	var direction_y = Input.get_axis("aim_up", "crouch")
	
	if is_dashing:
		if !direction_y:
			velocity_y = 0
		else :
			if just_dashed :
				velocity_y = DASH_SPEED * direction_y
	if is_frozen && (!ignore_y_freeze):
		velocity_y = 0		
	velocity.y = velocity_y
	
func dash_management():
	if can_dash && (Input.is_action_just_pressed("dash") && dash_counter > 0 && dash_timer.is_stopped()):
		unfreeze()
		if Input.is_action_pressed("aim_up"):
			dashing_up = true
		just_dashed = true
		is_dashing = true
		ignore_y_freeze = false
		#updateDashes(-1)
		ceiling_jump_resets()
		dashed.emit(dash_counter)
		self.is_killable = false
		dash_timer.start()

func updateDashes(dashAmount):
	dash_counter += dashAmount
	dashed.emit(dashAmount)

func _physics_process(delta):
	last_delta = delta
	if(can_move):	
		just_dashed = false
		dash_management()
		manage_animations()
		manage_y_movement(delta)	
		manage_x_movement()
		
		was_on_floor = is_on_floor()
		
		move_and_slide()
		
		var is_left = velocity.x < 0
		sprite_2d.flip_h = is_left

func _on_dash_timer_timeout():
	is_dashing = false
	self.is_killable = true
	dashing_up = false
	manage_y_movement(last_delta)
	manage_x_movement()
	if !is_on_floor():
		freeze()
	

func _on_dash_hitbox_area_entered(area):	
	var parent = area.get_parent()
	if !is_killable && "is_killable" in parent:
		updateDashes(2)
		SignalBus.hit(parent)
		

func freeze():
	is_frozen = true
	if !frozen_timer.is_stopped():
		frozen_timer.stop()
	frozen_timer.start()

func unfreeze():
	is_frozen = false
	if !frozen_timer.is_stopped():
		frozen_timer.stop()

func _on_frozen_timer_timeout():
	unfreeze()
