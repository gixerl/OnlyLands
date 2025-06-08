extends Area2D


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index==MOUSE_BUTTON_LEFT and event.pressed:
		for node in get_parent().get_children():
			node.modulate = Color(1,1,1)
		self.modulate = Color(1,0,0)
		print(name)
