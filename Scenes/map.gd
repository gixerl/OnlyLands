extends Node2D
@onready var mapImage = $mapSprite

func _ready():
	load_countries()

func load_countries():
	var image = mapImage.get_texture().get_image()
	var pixel_color_dict = get_pixel_color_dict(image)
	var countries_dict = import_file("res://Assets/Map/Countries.txt")
	
	for country_color in countries_dict:
		var country = load("res://Scenes/country_area.tscn").instantiate()
		country.country_name = countries_dict[country_color]
		get_node("Countries").add_child(country)
	
func get_pixel_color_dict(image):
	var pixel_color_dict = {}
	for y in range(image.get_height()):
		for x in range(image.get_width()):
			var pixel_color = "#" + str(image.get_pixel(int(x), int(y)).to_html(false))
			if pixel_color not in pixel_color_dict:
				pixel_color_dict[pixel_color] = []
			pixel_color_dict[pixel_color].append(Vector2(x, y))
	return pixel_color_dict

# Import JSON files and converts to list or dictionary
func import_file(filepath):
	var file = FileAccess.open(filepath, FileAccess.READ)
	if file != null:
		return JSON.parse_string(file.get_as_text().replace("_", " "))
	else:
		print("Failed to open file:", filepath)
		return null
 
