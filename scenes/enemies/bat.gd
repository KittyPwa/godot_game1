extends CharacterBody2D

@onready var animated_sprite_2d = %AnimatedSprite2D
@export var horizontal_move : bool
@export var vertical_move : bool
@export var is_killable : bool

var animation_name = ""
const SPEED = GlobalVars.constants.ennemies.bat.SPEED
var actual_speed_v
var actual_speed_h
const JUMP_VELOCITY = GlobalVars.constants.ennemies.bat.JUMP_VELOCITY
@onready var ray_cast_2d = %RayCast2D
@onready var ray_cast_2d_2 = %RayCast2D2
@onready var ray_cast_2d_3 = $RayCast2D3
@onready var ray_cast_2d_4 = $RayCast2D4
@onready var ray_cast_2d_5 = $RayCast2D5
@onready var ray_cast_2d_6 = $RayCast2D6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var facing_right = false
var facing_up = false

func _ready():	
	actual_speed_v = SPEED * -1
	actual_speed_h = SPEED

func _physics_process(_delta):
	
	animation_name = "flying"
	if !horizontal_move && !vertical_move:
		animation_name = "idle"
	animated_sprite_2d.animation = animation_name
	if ray_cast_2d.is_colliding() or ray_cast_2d_2.is_colliding() or ray_cast_2d_3.is_colliding():			
		if horizontal_move:
			flip_horizontal()
	if ray_cast_2d_4.is_colliding() or ray_cast_2d_5.is_colliding() or ray_cast_2d_6.is_colliding():			
		if vertical_move:
			flip_vertical()
	if horizontal_move:
		velocity.x = actual_speed_h
	if vertical_move:
		velocity.y = actual_speed_v
	
	move_and_slide()

func flip_horizontal():
	facing_right = !facing_right
	animated_sprite_2d.flip_h = facing_right
	actual_speed_h = -1 * actual_speed_h
	ray_cast_2d.target_position.x = ray_cast_2d.target_position.x * -1
	ray_cast_2d_2.target_position.x = ray_cast_2d_2.target_position.x * -1
	ray_cast_2d_3.target_position.x = ray_cast_2d_3.target_position.x * -1
	
func flip_vertical():	
	facing_up = !facing_up
	actual_speed_v = -1 * actual_speed_v
	ray_cast_2d_4.target_position.y = ray_cast_2d_4.target_position.y * -1
	ray_cast_2d_5.target_position.y = ray_cast_2d_5.target_position.y * -1
	ray_cast_2d_6.target_position.y = ray_cast_2d_6.target_position.y * -1

func _on_hit_box_area_entered(area):	
	if area.get_parent().name == "mainCharacter":
		SignalBus.hitMainCharacter()

func kill():
	queue_free()
