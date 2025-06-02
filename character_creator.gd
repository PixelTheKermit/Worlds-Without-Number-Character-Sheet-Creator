extends Control

var _template: JSON = preload("res://Jsons/Template.json")
var Data: Dictionary
var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

enum LoadError {
	OK,
	INVALID_FORMAT
}

@onready var _mainPanel = $Panel
@onready var _regularDim = $"Panel/ColorRect"

#region Details
@onready var _nameEdit = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer/NameEdit
@onready var _classEdit = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer/HBoxContainer/ClassEdit
@onready var _allignmentEdit = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer/HBoxContainer2/AllignmentEdit
@onready var _backgroundEdit = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer/HBoxContainer3/BackgroundEdit
@onready var _hitDie = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer2/VBoxContainer6/LineEdit
@onready var _levelEdit = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer2/VBoxContainer/LevelEdit

@onready var _attackBonus = $Panel/HBoxContainer/Panel/VBoxContainer/GridContainer2/VBoxContainer5/LineEdit
#endregion

#region Saving And Loading
@onready var _fileDim = $ColorRect
@onready var _saveDialog = $ColorRect/SaveDialog
@onready var _loadDialog = $ColorRect/LoadDialog
#endregion

@onready var attributes = $Panel/HBoxContainer/TabContainer/Attributes
@onready var _classSelect = $Panel/ClassSelect
@onready var _alignSelect = $Panel/AllignmentSelect

func _ready() -> void:
	RNG.randomize()
	attributes.InitAttributes(self)
	_classSelect.Init(self)
	LoadSheet(_template)

func LoadSheet(json: JSON) -> LoadError:
	if json.data is Array:
		return LoadError.INVALID_FORMAT
	
	Data = json.data
	Data.merge(_template.data)
	_nameEdit.text = Data.name
	_classEdit.text = Data.class
	_allignmentEdit.text = Data.alignment
	_backgroundEdit.text = Data.background
	
	attributes.LoadSheet()
	RecalcHitDie()
	UpdateAttackBonus()
	
	return LoadError.OK

func _on_save_pressed() -> void:
	_mainPanel.hide()
	_fileDim.show()
	_saveDialog.show()
	_saveDialog.current_file = Data.name + ".json"

func _on_save_dialog_canceled() -> void:
	_fileDim.hide()
	_mainPanel.show()

func _on_save_dialog_file_selected(path: String) -> void:
	var data = JSON.stringify(Data, "	",)
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data)
	_fileDim.hide()
	_mainPanel.show()

func _on_load_pressed() -> void:
	_mainPanel.hide()
	_fileDim.show()
	_loadDialog.show()
	_loadDialog.current_file = ""

func _on_load_dialog_canceled() -> void:
	_fileDim.hide()
	_mainPanel.show()

func _on_load_dialog_file_selected(path: String) -> void:
	var file = FileAccess.open(path, FileAccess.READ)
	var json = JSON.new()
	json.parse(file.get_as_text())
	LoadSheet(json)
	_fileDim.hide()
	_mainPanel.show()

func _on_name_edit_text_changed(new_text: String) -> void:
	Data.name = new_text

func _on_class_edit_text_changed(new_text: String) -> void:
	Data.class = new_text
	RecalcHitDie()

func _on_background_edit_text_changed(new_text: String) -> void:
	Data.background = new_text

func _on_allignment_edit_text_changed(new_text: String) -> void:
	Data.alignment = new_text

static func ToMod(val: int) -> int:
	if val <= 3:
		return -2
	elif val <= 7:
		return -1
	elif val <= 13:
		return 0
	elif val <= 17:
		return 1
	else:
		return 2

func RecalcHitDie() -> void:
	_hitDie.text = str(int(1 * Data.level)) + "d" + str(6)
	var plus = int(GetClassHP() + ToMod(int(Data.attributes.con)) * Data.level)
	_hitDie.text += "+" if plus > 0 else "-" if plus < 0 else ""
	_hitDie.text += str(abs(plus)) if plus != 0 else ""

func GetClassHP() -> int:
	var lower = Data.class.to_lower()
	if lower == "warrior":
		return 2 * Data.level
	elif lower == "mage":
		return -1 * Data.level
	elif lower == "adventurer (partial mage/partial mage)":
		return -1 * Data.level
	elif lower == "adventurer (partial expert/partial warrior)":
		return 2 * Data.level
	elif lower == "adventurer (partial mage/partial warrior)":
		return 2 * Data.level
	return 0

func GetClassAttackBonus() -> int:
	var lower = Data.class.to_lower()
	if lower in ["expert", "adventurer (partial expert/partial mage)"]:
		return int(Data.level / 2)
	elif lower in ["mage", "adventurer (partial mage/partial mage)"]:
		return int(Data.level / 5)
	elif lower == "warrior":
		return Data.level
	elif lower in ["adventurer (partial expert/partial warrior)", "adventurer (partial mage/partial warrior)"]:
		return 1 + (1 if Data.level >= 5 else 0) + int(Data.level / 2)
	return 0

func UpdateAttackBonus():
	Data.attackBonus = float(GetClassAttackBonus())
	_attackBonus.text = str(int(Data.attackBonus))

func UpdateClass(className: String):
	Data.class = className
	_classEdit.text = className
	RecalcHitDie()
	UpdateAttackBonus()

func _on_level_edit_text_changed(new_text: String) -> void:
	if new_text.is_valid_int():
		Data.level = float(int(new_text))
		RecalcHitDie()
		UpdateAttackBonus()

func _on_level_edit_focus_exited() -> void:
	_levelEdit.text = str(int(Data.level))

func _on_class_edit_button_pressed() -> void:
	_classSelect.show()
	Dim()

func Dim():
	_regularDim.show()

func Undim():
	_regularDim.hide()

func _on_allignment_select_return_allignment(alignment: String) -> void:
	Data.alignment = alignment
	_allignmentEdit.text = Data.alignment
	_alignSelect.hide()
	Undim()

func _on_allign_select_pressed() -> void:
	_alignSelect.show()
	Dim()


func _on_allignment_edit_focus_exited() -> void:
	_allignmentEdit.text = Data.alignment
