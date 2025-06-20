extends Node

var selected_country: String = ""
var country_locked: bool = false
var selected_enemy: String = ""
var enemy_locked: bool = false
var show_attack: bool = false
var conquered_countries: PackedStringArray = PackedStringArray()
var attackable_neighbors: PackedStringArray = PackedStringArray()
# GameState.gd (Autoload)
func update_attackable_neighbors():
	var file_path = "res://Assets/neighbors.json"
	var file = FileAccess.open(file_path, FileAccess.READ)
	var json_content = file.get_as_text()
	file.close()

	var json = JSON.new()
	var result = json.parse(json_content)
	var neighbors = json.get_data()

	attackable_neighbors.clear()

	for country in conquered_countries:
		for neib in neighbors[country]["neighbors"]:
			if not conquered_countries.has(neib):
				attackable_neighbors.append(neib)
