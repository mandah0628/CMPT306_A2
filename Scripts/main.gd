extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player
@onready var asteroids = $Asteroids
@onready var explosion_se = $Asteroids/Asteroid/Explosion
@onready var hud = $UI/HUD
@onready var spawn_pos = $Spawn

var asteroid_scene = preload("res://Scenes/asteroid.tscn")

var score := 0:
	set(value):
		score=value
		hud.score = score
var lives = int:
	set(value):
		lives = value
		hud.init_lives(lives)

func _ready():
	score = 0
	player.connect("laser_shot", _on_player_laser_shot)
	player.connect("died", _on_player_died)
	
	for asteroid in asteroids.get_children():
		asteroid.connect("exploded", _on_asteroid_exploded)

func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func _on_player_laser_shot(laser):
	lasers.add_child(laser)

	
func _on_asteroid_exploded(pos,size,points):
	score+= points
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
	asteroids.call_deferred("add_child", asteroid_instance)


func _on_player_died():
	lives -= 1
	if lives <=0:
		get_tree().reload_current_scene()
	else:
		await get_tree().create_timer(1).timeout
		player.respawn(spawn_pos.global_position)
