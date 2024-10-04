extends Node2D

@onready var lasers = $Lasers
@onready var player = $Player

func _ready():
	player.connect("laser_shot", on_player_laser_shot)
	
func on_player_laser_shot(laser):
	lasers.add_child(laser)
