extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids

var asteroid_scene = preload("res://Scenes/asteroid.tscn")

func _ready():
	player.connect("laser_shot", _on_player_laser_shot)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)

	
func _on_asteroid_exploded(pos,size):
	for i in range(2):
		match size:
			Asteroid.AsteroidSize.LARGE:
				spawn_asteroid(pos,Asteroid.AsteroidSize.MEDIUM)
			Asteroid.AsteroidSize.MEDIUM:
				spawn_asteroid(pos,Asteroid.AsteroidSize.SMALL)
			Asteroid.AsteroidSize.SMALL:
				pass

func spawn_asteroid(pos,size):
	var asteroid_instance = asteroid_scene.instantiate()
	asteroid_instance.global_position = pos
	asteroid_instance.size = size
	asteroid_instance.connect("exploded", _on_asteroid_exploded)
	asteroids.add_child(asteroid_instance)
