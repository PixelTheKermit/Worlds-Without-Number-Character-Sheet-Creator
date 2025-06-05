extends PanelContainer

@onready var _hideMe = $VBoxContainer/Panel
@onready var _info = $VBoxContainer/Panel/RichTextLabel
@onready var _name = $VBoxContainer/HBoxContainer/Label
@onready var _dropdown = $VBoxContainer/HBoxContainer/Dropdown

signal InfoPressed()

func _on_info_pressed() -> void:
	InfoPressed.emit()

func _on_dropdown_pressed() -> void:
	if _hideMe.visible:
		_dropdown.text = "⬇️"
		_hideMe.hide()
	else:
		_dropdown.text = "⬆️"
		_hideMe.show()
		
