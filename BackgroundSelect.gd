extends Control

var _backgrounds = preload("res://Jsons/Backgrounds.json")

@onready var _root = $"../.."

@onready var _selectContainer = $VBoxContainer/Container/HBoxContainer/ScrollContainer/VBoxContainer
@onready var _name = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/Label
@onready var _bgDetails = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/RichTextLabel
@onready var _freeSkills = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer
@onready var _quickSkills = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer2/ScrollContainer/VBoxContainer
@onready var _growth = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer3/ScrollContainer/VBoxContainer
@onready var _learning = $VBoxContainer/Container/HBoxContainer/VBoxContainer2/HBoxContainer/VBoxContainer4/ScrollContainer/VBoxContainer

var _choicesGrowth = []
var _choicesLearning = []

var _selected = ""

func FindAndSwitch(backName: String):
	for bg in _backgrounds.data:
		if bg.name == backName:
			FlipToBackground(bg)

func FlipToBackground(background: Dictionary):
	_bgDetails.text = background.desc
	_name.text = background.name
	_selected = background.name
	
	for i in (_freeSkills.get_children() + _quickSkills.get_children()
	+ _growth.get_children() + _learning.get_children()):
		i.queue_free()
	
	_choicesGrowth = []
	_choicesLearning = []
	
	for i in background.freeSkills:
		var label = Label.new()
		label.text = i
		_freeSkills.add_child(label)
	
	for i in background.quickSkills:
		var label = Label.new()
		label.text = i
		_quickSkills.add_child(label)
	
	for i in background.growth:
		var label = Label.new()
		label.text = i
		_growth.add_child(label)
		_choicesGrowth.append(label)
	
	for i in background.learning:
		var label = Label.new()
		label.text = i
		_learning.add_child(label)
		_choicesLearning.append(label)

func _ready() -> void:
	for background in _backgrounds.data:
		var butt = Button.new()
		butt.text = background.name
		
		butt.pressed.connect(func():
			FlipToBackground(background)
		)
		
		_selectContainer.add_child(butt)
	
	FlipToBackground(_backgrounds.data[0])

func _on_roll_pressed() -> void:
	for i in _choicesGrowth + _choicesLearning:
		i.self_modulate = Color.WHITE
	
	var leSize = max(_choicesGrowth.size(), _choicesLearning.size()) - 1
	# Just... pray this doesn't fail.
	var used = {}
	for _i in range(3):
		if used.size() > leSize:
			break
		
		var i = _root.RNG.randi_range(0, leSize)
		# Possibly can get 'infinite' iteration. However I don't think
		# such a case will ever happen and it doesn't really matter
		# much for performance.
		while i in used:
			i = _root.RNG.randi_range(0, leSize)
		used[i] = true
		if i < _choicesGrowth.size():
			if i < _choicesLearning.size():
				_choicesGrowth[i].self_modulate = Color.YELLOW
				_choicesLearning[i].self_modulate = Color.YELLOW
			else:
				_choicesGrowth[i].self_modulate = Color.GREEN
		elif i < _choicesLearning.size():
			_choicesLearning[i].self_modulate = Color.GREEN


func _on_button_pressed() -> void:
	hide()
	_root.Data.background = _selected
	_root.UpdateBackground()
	_root.Undim()
