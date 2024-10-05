extends Control


@onready var score = $Score:
	set(value):
		score.text = "SCORE:" +str(value)
		
var lives_scene = preload("res://Scenes/lives.tscn")
@onready var lives = $LiveContainer

func init_lives(amount):
	for i in lives.get_children():
		i.queue_free()
	for j in amount:
		var i = lives_scene.instantiate()
		lives.add_child(i)
