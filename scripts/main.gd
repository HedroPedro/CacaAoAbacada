extends Node2D

@onready var movie := $Movie/Control/Movie

func _ready() -> void:
	movie.finished.connect(_change)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _change() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
