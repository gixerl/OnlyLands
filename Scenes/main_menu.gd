extends Node2D

@onready var text_edit: TextEdit = $CanvasLayer/Informationen


func _on_button_pressed() -> void:
	if text_edit.visible:
		text_edit.visible = false
	else:
		text_edit.visible = true
