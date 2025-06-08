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
	var shape_area=country_scene.instantiate()

	shape_area.name = names[shapeid]
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
	line.modulate = Color(0,0,0,0.8)
	line.width = 0.3
	line.closed=true
	
	parent_node.add_child(polygon)
	parent_node.add_child(collision_polygon)
	parent_node.add_child(line)
	
