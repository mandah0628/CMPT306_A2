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
@onready var laser_scene = preload("res://Scenes/laser.tscn")
@onready var muzzle = $Muzzle
var laser_speed  = 500.0


func _process(delta):
	#Controls for firing a laser
	if Input.is_action_pressed("fire"):
		fire_laser()
	
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
	var laser = laser_scene.instance()

	laser.position = muzzle.global_position
	laser.rotation = rotation
	
	var direction = Vector2.RIGHT.rotated(rotation)  # RIGHT is the forward direction in Godot	
	laser.set("velocity", direction * laser_speed)  # Assuming your laser script uses velocity for movement
	
	# Add the laser to the scene
	get_parent().add_child(laser)
