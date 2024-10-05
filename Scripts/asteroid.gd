class_name Asteroid extends Area2D

var movement_vector = Vector2(0,-1)
var speed := 50.0

enum AsteroidSize{SMALL,MEDIUM,LARGE}
@export var size := AsteroidSize.LARGE

@onready var sprite = $Sprite2D
@onready var collision_shape = $CollisionShape2D
@onready var explosion_se = $Explosion

signal exploded(pos,size)

func _ready():
	rotation=randf_range(0, 2*PI)
	
	match size:
		AsteroidSize.LARGE:
			speed = randf_range(50,100)
			sprite.texture = preload("res://Textures/Texture 2/PNG/Meteors/meteorBrown_big4.png")
			collision_shape.set_deferred("shape", preload("res://Resources/asteroid_large.tres"))
		AsteroidSize.MEDIUM:
			speed = randf_range(100,150)
			sprite.texture = preload("res://Textures/Texture 2/PNG/Meteors/meteorBrown_med3.png")
			collision_shape.set_deferred("shape", preload("res://Resources/asteroid_medium.tres"))
		AsteroidSize.SMALL:
			speed = randf_range(150, 200)
			sprite.texture = preload("res://Textures/Texture 2/PNG/Meteors/meteorBrown_small2.png")
			collision_shape.set_deferred("shape", preload("res://Resources/asteroid_small.tres"))




func _physics_process(delta):
	global_position +=movement_vector.rotated(rotation) * speed * delta
	
	var radius = collision_shape.shape.radius
	var screen_size = get_viewport_rect().size
	
	if position.x + radius< 0:
		position.x = screen_size.x + radius
	elif position.x - radius > screen_size.x:
		position.x = -radius
	
	# Wrap vertically
	if position.y + radius < 0:
		position.y = screen_size.y + radius
	elif position.y - radius > screen_size.y:
		position.y = -radius


func explode():
	explosion_se.play()
	emit_signal("exploded", global_position, size)
	queue_free()
