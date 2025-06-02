extends LineEdit

## A quick class to keep the code clean
class_name AttributeLineEdit
@export var Attribute: String = "null"
@export var ModLineEdit: LineEdit

signal AttributeEdit(new_val: int, attribute: String, modLineEdit: LineEdit)

signal FocusLeft(lineEdit: LineEdit, attribute: String)

func _ready():
	text_changed.connect(func(str):
		if ModLineEdit == null:
			push_warning("ModLineEdit attribute not set.")
			return
		
		if str.is_valid_int():
			AttributeEdit.emit(int(str), Attribute, ModLineEdit)
	)
	
	focus_exited.connect(func():
		FocusLeft.emit(self, Attribute)
	)
