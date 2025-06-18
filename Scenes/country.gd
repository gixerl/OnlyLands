extends Area2D
var country_color = Color(1,1,1)

@onready var characters = get_tree().root.get_node("Main/CanvasLayer/Characters")
@onready var enemies = get_tree().root.get_node("CanvasLayer/Characters")
@onready var info = get_tree().root.get_node("Main/CanvasLayer/Info")
@onready var infotext = get_tree().root.get_node("Main/CanvasLayer/Informationen")
@onready var neighbors = {}

var new_texture
var new_text
func _ready():
	self.modulate = country_color
	if GameState.conquered_countries.has(name):
		self.modulate = Color(0, 1, 0)
		var file_path = "res://Assets/neighbors.json"
		var file = FileAccess.open(file_path, FileAccess.READ)
		var json_content = file.get_as_text()
		file.close()
		var json = JSON.new()
		var result = json.parse(json_content)
		neighbors = json.get_data()
		for country in GameState.conquered_countries:
			for neib in neighbors[country]["neighbors"]:
				if !GameState.conquered_countries.has(neib):
					GameState.attackable_neighbors.append(neib)
	for node in get_parent().get_children():		
		if GameState.attackable_neighbors.has(node.name):
			node.modulate = Color(0, 0, 1)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		if GameState.country_locked and (GameState.conquered_countries.has(name) or !GameState.attackable_neighbors.has(name)):
			return
		for node in get_parent().get_children():
			if "country_color" in node:
				# the own country cannot be changed after pressing the start button
				# TODO remove
				if node.name == GameState.selected_country and GameState.country_locked:
					continue
				elif node.name == GameState.selected_enemy and GameState.enemy_locked:
					continue					
				elif GameState.attackable_neighbors.has(node.name):
					node.modulate = Color(0, 0, 1)
				else:
					node.modulate = node.country_color
		if GameState.country_locked and get_tree().current_scene.name == "Main":
			return
		if !(GameState.country_locked and GameState.enemy_locked):
			self.modulate = Color(1, 0, 0)
		if not GameState.country_locked:
			GameState.selected_country = name
		elif not GameState.enemy_locked:
			GameState.show_attack = true
			get_tree().root.get_node("Selection_screen/CanvasLayer/Map Country Picker/Attack").visible = true
			GameState.selected_enemy = name
		else:
			return
		if get_tree().current_scene.name == "Main":
			new_texture = load("res://Assets/Characters/%s.png" % name)
			characters.visible = true
			characters.texture = new_texture
		else:
			assert(GameState.country_locked == true)	# should be in selection screen
			characters = get_tree().root.get_node("Selection_screen/CanvasLayer/Characters")
			new_texture = load("res://Assets/Characters/%s.png" % GameState.selected_country)
			characters.texture = new_texture
			characters.visible = true
			enemies = get_tree().root.get_node("Selection_screen/CanvasLayer/Enemies")
			new_texture = load("res://Assets/Characters/%s.png" % name)
			enemies.visible = true
			enemies.texture = new_texture
		if info != null:
			new_text = FileAccess.open("res://Assets/Infos/%s.txt" % name, FileAccess.READ)
			new_text = new_text.get_as_text()
			info.visible = true
			infotext.text = new_text
