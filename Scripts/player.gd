extends CharacterBody2D

#movement variables
var rotation_speed = 10.0
var max_speed = 300.0
var ship_velocity = Vector2.ZERO

#Animation variables
@onready var left_thruster = $LeftThruster
@onready var right_thruster = $RightThruster
@onready var main_thruster = $MainThruster
var max_frames = 3
var frame_count = 0

#Laser variables
@onready var muzzle = $Muzzle
var laser_scene = preload("res://Scenes/laser.tscn")
signal laser_shot(laser)
var overheat = false

#Camera variables
var screen_size = Vector2.ZERO


func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	if Input.is_action_pressed("fire"):
		if !overheat:
			overheat = true
			fire_laser()
			await get_tree().create_timer(0.15).timeout
			overheat = false

func _physics_process(delta):
	#Controls for turning left
	if Input.is_action_pressed("move_left"):
		rotation-=rotation_speed*delta
		show_thruster(left_thruster)
		
	#Controls for turning right
	elif Input.is_action_pressed("move_right"):
		rotation+=rotation_speed*delta
		show_thruster(right_thruster)
		
	else:
		hide_thrusters()
		
	#Limits the max speed
	if ship_velocity.length() > max_speed:
		ship_velocity = ship_velocity.normalized() * max_speed
		
	#Changes the ship position
	position += ship_velocity * delta
	
#Function to display the thruster animations
func show_thruster(thruster: Sprite2D):
	thruster.visible = true
	frame_count = max_frames
	
	if thruster == left_thruster:
		right_thruster.visible = false
		
	elif thruster == right_thruster:
		left_thruster.visible = false

#Function to remove the thruster animation
func hide_thrusters():
	if frame_count > 0:
		frame_count -= 1
	else:
		left_thruster.visible = false
		right_thruster.visible = false
		
		
#Function to fire the laser from the ship
func fire_laser():
	var laser_instance = laser_scene.instantiate()
	
	laser_instance.global_position = muzzle.global_position
	laser_instance.rotation = rotation
	emit_signal("laser_shot", laser_instance)


func screen_wrap():
	if position.x < 0:
		position.x = screen_size.x
	elif position.x > screen_size.x:
		position.x = 0
	
	# Wrap vertically
	if position.y < 0:
		position.y = screen_size.y
	elif position.y > screen_size.y:
		position.y = 0
