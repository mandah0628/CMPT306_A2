extends CharacterBody2D

var rotation_speed = 10.0
var max_speed = 500.0
var acceleration = 275.0
var ship_velocity = Vector2.ZERO

func _process(delta):
	#Controls for turning left
	if Input.is_action_pressed("strafe_left"):
		rotation-=rotation_speed*delta
	
	#Controls for turning right
	if Input.is_action_pressed("strafe_right"):
		rotation+=rotation_speed*delta
		
	#Controls for moving forward
	if Input.is_action_pressed("move_forward"):
		var direction = Vector2(cos(rotation), sin(rotation))  
		ship_velocity += direction * acceleration * delta
		
	#Controls for moving backward
	if Input.is_action_pressed("move_backward"):
		var direction = Vector2(cos(rotation), sin(rotation))
		ship_velocity -= direction * acceleration * delta
		
	#Limits the max speed
	if ship_velocity.length() > max_speed:
		ship_velocity = ship_velocity.normalized() * max_speed
		
	#Changes the ship position
	position += ship_velocity * delta
		
		
