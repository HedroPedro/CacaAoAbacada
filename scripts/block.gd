extends Control

@onready var wordLabel := $TextureButton/Word
@onready var soundButton := $SoundButton/TextureButton
@onready var soundStream := $AudioStreamPlayer2D
var audio : AudioStreamOggVorbis
var index : int
var toCall : Callable

func _ready() -> void:
	soundButton.connect("pressed", _say)

func _say() -> void:
	soundStream.stream = audio
	soundStream.play()

func update(valDict : Dictionary) -> void:
	wordLabel.text = valDict["silaba"]
	audio = valDict["som"]

func _on_texture_button_pressed() -> void:
	toCall.call(index)
