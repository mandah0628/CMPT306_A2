extends CharacterBody2D

var rotation_speed = 10.0
var max_speed = 300.0
var acceleration = 300.0
var ship_velocity = Vector2.ZERO
var deacceleration = 200

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
	
	#Deaccelerates the ship if the movement keys are not pressed
	if not Input.is_action_pressed("move_backward") and not Input.is_action_pressed("move_forward"):
		var velocity_length = ship_velocity.length()
		
		#if ship is in motion, reduce speed(reduces the magnitue of the vector)
		if velocity_length > 0:
			velocity_length -= deacceleration * delta
		
		#if ship is not in motion
		if velocity_length < 0:
			velocity_length = 0
		
		#if ship is in motion, apply the new reduced speed
		#by multuplying the new magnitued with the normal vector of the
		#direction of where the ship is going
		if velocity_length > 0:
			ship_velocity = ship_velocity.normalized() * velocity_length
			
		#if not, comes to complete stop
		else:
			ship_velocity = Vector2.ZERO
			
	#Limits the max speed
	if ship_velocity.length() > max_speed:
		ship_velocity = ship_velocity.normalized() * max_speed
		
	#Changes the ship position
	position += ship_velocity * delta
		
		
