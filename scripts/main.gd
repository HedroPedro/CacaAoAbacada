extends Node2D

@onready var movie := $Movie/Control/Movie

func _ready() -> void:
	movie.finished.connect(_change)
	randomize()

func _change() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
