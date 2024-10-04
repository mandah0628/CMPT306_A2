extends CharacterBody2D

var rotation_speed = 200.0

func _movementProcess(delta):
	if Input.is_action_pressed("ui_left"):
		rotation-=rotation_speed*delta
	
	if Input.is_action_pressed(delta):
		rotation+=rotation_speed*delta
