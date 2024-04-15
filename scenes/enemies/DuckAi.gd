extends CharacterBody2D

@onready var animated_sprite_2d = %AnimatedSprite2D


signal mainCharacterIsDead

var animation_name = ""
const SPEED = -150
var actual_speed
const JUMP_VELOCITY = -400.0
@onready var ray_cast_2d = %RayCast2D
@onready var ray_cast_2d_2 = %RayCast2D2
@onready var ray_cast_2d_3 = $RayCast2D3

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false

func _ready():	
	actual_speed = SPEED

func _physics_process(delta):
	if !SignalBus.isGamePaused():
		animation_name = "idle"
		if(velocity.y != 0):
			animation_name = "fall"	
		#animated_sprite_2d.animation = animation_name
		if ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding() or ray_cast_2d_3.is_colliding():
			flip()
		if not is_on_floor():
			velocity.y += gravity * delta		
		velocity.x = actual_speed
		
		move_and_slide()

func flip():
	facing_right = !facing_right
	animated_sprite_2d.flip_h = facing_right
	actual_speed = -1 * actual_speed
	ray_cast_2d.target_position.x = ray_cast_2d.target_position.x * -1
	ray_cast_2d_2.target_position.x = ray_cast_2d_2.target_position.x * -1
	ray_cast_2d_3.target_position.x = ray_cast_2d_3.target_position.x * -1
	


func _on_hit_box_area_entered(area):	
	if area.name == "hitBox" && area.get_parent().name == "mainCharacter":
		SignalBus.hitMainCharacter()
