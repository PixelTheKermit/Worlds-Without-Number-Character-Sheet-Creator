extends Control

var _backgrounds = preload("res://Jsons/Backgrounds.json")

@onready var _selectContainer = $VBoxContainer/Container/HBoxContainer/ScrollContainer/VBoxContainer
@onready var _bgDetails = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/RichTextLabel

func _ready() -> void:
	for background in _backgrounds.data:
		var butt = Button.new()
		butt.text = background.name
		
		butt.pressed.connect(func():
			_bgDetails.text = background.desc
			
		)
		
		_selectContainer.add_child(butt)
