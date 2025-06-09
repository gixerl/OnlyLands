extends Node2D
var nodes_path = "res://Assets/Map/countries-nodes.txt"
var country_scene = preload("res://Scenes/country.tscn")
var attributes_path = "res://Assets/Map/countries-attributes.txt"

#choose which continents are in the game
var continents_active= {
	"Europe" = 1,
	"Asia" = 0,
	"Africa" = 0,
	"South America" = 0,
	"North America" = 0,
	"Antarctica" = 0,
	"Oceania" = 0,
	"Seven seas (open ocean)" = 0,
	"" = 0
}
var names = {}

func _ready() -> void:
	var nodes = FileAccess.open(nodes_path,FileAccess.READ)
	var attributes = FileAccess.open(attributes_path, FileAccess.READ)
	var polygons = {}
	
	#comb through attributes
	while not attributes.eof_reached():
		var line = attributes.get_line()
		var parts = line.split(",")
		var shapeid = 0
		if parts.size() < 10 or continents_active[parts[93]]==0:
			continue
		
		if parts.size()<10:
			continue
		#set up Names Dictionary
		shapeid=parts[0].to_int()
		var name = parts[19]
		names[shapeid] = name
		
	#set up polygons Dictionary
	while not nodes.eof_reached():
		var line = nodes.get_line()
		var parts = line.split(",")
		var shapeid = 0
		var partid = 0
		if parts.size() < 4 or parts[0].to_int() not in names:
			continue
			
		shapeid=parts[0].to_int()
		partid=parts[1].to_int()
		var x = parts[2].to_float()
		var y = parts[3].to_float()
		
		##IF WE WANT EUROPE ONLY- THIS REMOVES AMERICA TAIL OF RUSSIA AND RANDOM FRANCE ISLAND
		if shapeid==43 and partid==0 or shapeid==18 and partid == 11:		#if france, if russia
			continue
		
		if not polygons.has(shapeid):
			polygons[shapeid]=[]
		while polygons[shapeid].size() <= partid:
			polygons[shapeid].append([])
		polygons[shapeid][partid].append(Vector2(x, -y))
		
	for shapeid in polygons.keys():
		create_shape(shapeid, polygons[shapeid])
	
func create_shape(shapeid,parts):
	#create new country scene
	var shape_area=country_scene.instantiate()
	#add name and color to new country
	shape_area.name = names[shapeid]
	shape_area.country_color = Color(colors_dict.get(shape_area.name,Color(1,1,1)) ,0.8 )
	add_child(shape_area)
	
	for partid in range(parts.size()):
		var polygon_points = parts[partid]
		create_part(shape_area,partid,polygon_points)
		
func create_part(parent_node,partid,points):
	var unique_points = points.duplicate()
	var polygon = Polygon2D.new()
	polygon.polygon=unique_points
	polygon.name= str(partid)
	
	var collision_polygon = CollisionPolygon2D.new()
	collision_polygon.polygon=unique_points
	collision_polygon.name= str(partid)
	
	var line = Line2D.new()
	line.points=unique_points
	line.name= str(partid)
	line.modulate = Color(0,0,0)
	line.width = 0.3
	line.closed=true
	
	parent_node.add_child(polygon)
	parent_node.add_child(collision_polygon)
	parent_node.add_child(line)
	

#dictionary mapping countries to their colors
var colors_dict := {
	"Albania":              Color("#E41C24"),
	"Andorra":              Color("#ED2939"),
	"Austria":              Color("#ED2939"),
	"Belarus":              Color("#C8313E"),
	"Belgium":              Color("#000000"),
	"Bosnia and Herzegovina": Color("#002395"),
	"Bulgaria":             Color("#00966E"),
	"Croatia":              Color("#171796"),
	"Cyprus":               Color("#D57800"),  # copper-orange
	"Czech Republic":       Color("#11457E"),
	"Denmark":              Color("#C60C30"),
	"Estonia":              Color("#0071B7"),
	"Finland":              Color("#003580"),
	"France":               Color("#0055A4"),
	"Germany":              Color("#000000"),
	"Greece":               Color("#0D5EAF"),
	"Hungary":              Color("#C8102E"),
	"Iceland":              Color("#003897"),
	"Ireland":              Color("#169B62"),
	"Italy":                Color("#009246"),
	"Latvia":               Color("#9E3039"),
	"Liechtenstein":        Color("#0022A5"),
	"Lithuania":            Color("#FDB913"),
	"Luxembourg":           Color("#009BDE"),
	"Malta":                Color("#C60C30"),
	"Moldova":              Color("#0033A0"),
	"Monaco":               Color("#CE1126"),
	"Montenegro":           Color("#D10C17"),
	"Netherlands":          Color("#AE1C28"),
	"North Macedonia":      Color("#D20000"),
	"Norway":               Color("#BA0C2F"),
	"Poland":               Color("#DC143C"),
	"Portugal":             Color("#006600"),
	"Romania":              Color("#002B7F"),
	"Russia":               Color("#D52B1E"),
	"San Marino":           Color("#00AEEF"),
	"Serbia":               Color("#C6363C"),
	"Slovakia":             Color("#0B4F9F"),
	"Slovenia":             Color("#0058A8"),
	"Spain":                Color("#AA151B"),
	"Sweden":               Color("#006AA7"),
	"Switzerland":          Color("#FF0000"),
	"Turkey":               Color("#E30A17"),
	"Ukraine":              Color("#0057B8"),
	"United Kingdom":       Color("#00247D"),
	"Vatican City":         Color("#FFD700"),
}
