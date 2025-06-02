extends Control

var Classes = preload("res://Jsons/classes.json")

@onready var classSelect = $VBoxContainer/Container/HBoxContainer/ScrollContainer/VBoxContainer
@onready var classDesc = $VBoxContainer/Container/HBoxContainer/VBoxContainer/RichTextLabel
@onready var className = $"VBoxContainer/Container/HBoxContainer/VBoxContainer/ClassName"

var _char

func Init(char):
	_char = char

func _ready():
	LoadClasses()

var _chosenClass = ""

func _change(clas):
	_chosenClass = clas.class
	className.text = _chosenClass.split(" ")[0] # Hacky, but for this it works.
	classDesc.text = clas.description

func LoadClasses():
	for v in Classes.data:
		var button = Button.new()
		button.text = v.class
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		classSelect.add_child(button)
		button.pressed.connect(func():
			_change(v)
		)
	_change(Classes.data[0])
	

func _on_button_pressed() -> void:
	_char.UpdateClass(_chosenClass)
	_char.Undim()
	hide()
	
