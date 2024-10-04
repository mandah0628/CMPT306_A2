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

func _process(delta):
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
	
	
func show_thruster(thruster: Sprite2D):
	thruster.visible = true
	frame_count = max_frames
	
	if thruster == left_thruster:
		right_thruster.visible = false
		
	elif thruster == right_thruster:
		left_thruster.visible = false


func hide_thrusters():
	if frame_count > 0:
		frame_count -= 1
	else:
		left_thruster.visible = false
		right_thruster.visible = false
