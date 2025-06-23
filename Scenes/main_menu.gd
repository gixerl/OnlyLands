extends Node2D
@onready var soundtrack: AudioStreamPlayer2D = $Soundtrack

@onready var text_edit: TextEdit = $CanvasLayer/Informationen
@onready var victory: CanvasLayer = $Victory

func _ready():
	if get_tree().current_scene.name == "Selection_screen":
		soundtrack.process_mode = Node.PROCESS_MODE_ALWAYS
		get_node("CanvasLayer/Map Country Picker/Settings").position = Vector2(974, 40)
		get_node("CanvasLayer/Map Country Picker/Options").position = Vector2(-954, -615)
		var characters = get_tree().root.get_node("Selection_screen/CanvasLayer/Characters")
		var new_texture = load("res://Assets/Characters/%s.png" % GameState.selected_country)
		characters.texture = new_texture
		characters.visible = true

func _on_button_pressed() -> void:
	if text_edit.visible:
		text_edit.visible = false
	else:
		text_edit.visible = true


func _on_return_pressed() -> void:
	get_tree().quit()
