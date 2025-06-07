extends Area2D
var country_name = ""


func _on_child_entered_tree(node: Node) -> void:
	if node.is_class("Polygon2D"):
		node.color = Color(1,1,1,0.5)
	


func _on_mouse_entered() -> void:
	print(country_name)


func _on_mouse_exited() -> void:
	pass # Replace with function body.


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_Index == MOUSE_BUTTON_LEFT and event.is_pressed():
		print(str(country_name) + "Clicked")
	
