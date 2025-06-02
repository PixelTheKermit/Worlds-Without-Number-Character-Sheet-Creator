extends Control

# This is actually awful.

signal ReturnAllignment(alignment: String)


func _on_lawful_good_pressed() -> void:
	ReturnAllignment.emit("Lawful Good")


func _on_neutral_good_pressed() -> void:
	ReturnAllignment.emit("Neutral Good")


func _on_chaotic_good_pressed() -> void:
	ReturnAllignment.emit("Chaotic Good")


func _on_lawful_neutral_pressed() -> void:
	ReturnAllignment.emit("Lawful Neutral")


func _on_true_neutral_pressed() -> void:
	ReturnAllignment.emit("True Neutral")


func _on_chaotic_neutral_pressed() -> void:
	ReturnAllignment.emit("Chaotic Neutral")


func _on_lawful_evil_pressed() -> void:
	ReturnAllignment.emit("Lawful Evil")


func _on_neutral_evil_pressed() -> void:
	ReturnAllignment.emit("Neutral Evil")


func _on_chaotic_evil_pressed() -> void:
	ReturnAllignment.emit("Chaotic Evil")
