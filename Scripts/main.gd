extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player

func _ready():
	player.connect("laser_shot", on_player_laser_shot)
	
func _process(delta):
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
func on_player_laser_shot(laser):
	lasers.add_child(laser)
