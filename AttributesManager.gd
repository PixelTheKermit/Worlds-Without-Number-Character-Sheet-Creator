extends Control

@onready var _skillContainer = $HBoxContainer/VBoxContainer2/VFlowContainer
@onready var _attributes = $HBoxContainer/VBoxContainer/Attributes

@onready var _moveRate = $HBoxContainer/VBoxContainer/MOV/LineEdit
@onready var _hpIn = $HBoxContainer/VBoxContainer/HP/LineEdit

@onready var _skillPoints = $HBoxContainer/VBoxContainer2/HBoxContainer/SkillPoints

var _char

func InitAttributes(charCreator):
	_char = charCreator

func LoadSheet():
	_skillPoints.text = str(int(_char.Data.skillPoints))

	for child: Control in _attributes.get_children():
		var inputNode: AttributeLineEdit = child.get_node("./AttributeInput")
		inputNode.text = str(int(_char.Data.attributes[inputNode.Attribute]))
		inputNode.text_changed.emit(inputNode.text)

	for skill in _skillContainer.get_children():
		skill.queue_free()

	for skill in _char.Data.skills:
		var hBoxContainer = HBoxContainer.new()
		
		var info = _char.Data.skills[skill]
		
		var skillLabel = Label.new()
		skillLabel.custom_minimum_size.x = 100
		skillLabel.text = skill.capitalize()
		hBoxContainer.add_child(skillLabel)
		
		var skillValue = LineEdit.new()
		skillValue.custom_minimum_size.x = 50
		skillValue.text = str(int(info.val))
		skillValue.text_changed.connect(func(str):
			if str.is_valid_int():
				info.val = float(int(str))
		)
		skillValue.focus_exited.connect(func():
			skillValue.text = str(int(info.val)))
		hBoxContainer.add_child(skillValue)
		
		var skillMod = Label.new()
		skillMod.text = "+ " + info.mod.to_upper()
		skillMod.custom_minimum_size.x = 75
		hBoxContainer.add_child(skillMod)
		_skillContainer.add_child(hBoxContainer)
	
	_hpIn.text = str(int(_char.Data.hp))

func _on_attribute_input_attribute_edit(new_val: int, attribute: String, modLineEdit: LineEdit) -> void:
	modLineEdit.text = str(_char.ToMod(new_val))
	
	_char.Data.attributes[attribute] = float(new_val)
	_char.RecalcHitDie()

func _on_attribute_input_focus_left(lineEdit: LineEdit, attribute: String) -> void:
	lineEdit.text = str(int(_char.Data.attributes[attribute]))

func _on_hp_random_button_pressed() -> void:
	var health: int = _char.GetClassHP() 
	for _v in range(_char.Data.level):
		health += _char.RNG.randi_range(1, 6)
		health += _char.ToMod(int(_char.Data.attributes.con))
	
	health = max(health, 1)
	
	_hpIn.text = str(health)
	_char.Data.hp = float(health)

func _on_hp_edit_focus_exited() -> void:
	_hpIn.text = str(int(_char.Data.hp))

func _on_skill_points_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_char.Data.skillPoints = float(int(new_text))

func _on_skill_points_focus_exited() -> void:
	_skillPoints.text = str(int(_char.Data.skillPoints))

func _on_hp_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		_char.Data.hp = float(int(new_text))
