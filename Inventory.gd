extends Control

@onready var _root = $"../../../.."
@onready var _rich = $HBoxContainer/VBoxContainer/Panel/TextEdit

@onready var _copper = $HBoxContainer/VBoxContainer2/GridContainer/Copper
@onready var _silver = $HBoxContainer/VBoxContainer2/GridContainer/Silver
@onready var _gold = $HBoxContainer/VBoxContainer2/GridContainer/Gold

#@onready var _weaponStorage = $GridContainer/VBoxContainer/Panel/ScrollContainer/VBoxContainer

var _folderPath = "res://Jsons/Items/"
var _itemData = []

func _loadItemData(path: String = _folderPath):
	var dirAccess = DirAccess.open(_folderPath)
	for folder in dirAccess.get_directories():
		if folder == path:
			continue
		
		_loadItemData(folder)
		
	for file in dirAccess.get_files():
		if not file.ends_with(".json"):
			continue
		
		_itemData += load(dirAccess.get_current_dir() + "/" + file).data

func Load():
	_rich.text = _root.Data.placeholderInventory
	_gold.text = str(int(_root.Data.coins.gp))
	_silver.text = str(int(_root.Data.coins.sp))
	_copper.text = str(int(_root.Data.coins.cp))

func _ready():
	_loadItemData()
	
	print(_itemData)

func _on_copper_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_root.Data.coins.cp = float(new_text)

func _on_silver_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_root.Data.coins.sp = float(new_text)

func _on_gold_text_changed(new_text: String) -> void:
	if new_text.is_valid_float():
		_root.Data.coins.gp = float(new_text)


func _on_gold_focus_exited() -> void:
	_gold.text = str(int(_root.Data.coins.gp))

func _on_silver_focus_exited() -> void:
	_silver.text = str(int(_root.Data.coins.sp))

func _on_copper_focus_exited() -> void:
	_copper.text = str(int(_root.Data.coins.cp))

func _on_text_edit_text_changed() -> void:
	_root.Data.placeholderInventory = _rich.text
