extends Area2D
var country_color = Color(1,1,1)


@onready var characters = get_tree().root.get_node("Main/CanvasLayer/Characters")
@onready var enemies = get_tree().root.get_node("CanvasLayer/Characters")
@onready var info = get_tree().root.get_node("Main/CanvasLayer/Info")
@onready var infotext = get_tree().root.get_node("Main/CanvasLayer/Informationen")

var new_texture
var new_text
func _ready():
	self.modulate = country_color
	if name == GameState.selected_country:
		self.modulate = Color(1, 0, 0)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.country_locked and self.name == GameState.selected_country:
			return
		for node in get_parent().get_children():
			if "country_color" in node:
				node.modulate = node.country_color
		self.modulate = Color(1,0,0)
		new_texture = load("res://Assets/Characters/%s.png" % name)
		new_text = FileAccess.open("res://Assets/Infos/%s.txt" % name, FileAccess.READ)
		new_text = new_text.get_as_text()
		characters.visible = true
		info.visible = true
		characters.texture = new_texture
		infotext.text = new_text
		
