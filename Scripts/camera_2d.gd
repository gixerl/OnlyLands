extends Camera2D
var zoomTarget = Vector2()
@export var zoomSpeed : float = 10;

func _ready():
	zoomTarget=zoom
	pass
func _process(delta):
	Zoom(delta)
	SimplePan(delta)
	ClickAndDrag()
			

func Zoom(delta):
	var zoomTargetBefore = zoomTarget
	if Input.is_action_pressed("camera_zoom_in"):
		zoomTarget = zoom*1.1
	if Input.is_action_pressed("camera_zoom_out"):
		zoomTarget = zoom*0.9
	
	if zoomTarget.x < 50 && zoomTarget.x >= 3:
		zoom = zoom.slerp(zoomTarget, zoomSpeed * delta)
	else:
		zoomTarget = zoomTargetBefore 
	
func SimplePan(delta):
	var moveAmount = Vector2.ZERO
	if Input.is_action_pressed("camera_move_right"):
		moveAmount.x +=1
	if Input.is_action_pressed("camera_move_left"):
		moveAmount.x -=1
	if Input.is_action_pressed("camera_move_up"):
		moveAmount.y -=1
	if Input.is_action_pressed("camera_move_down"):
		moveAmount.y +=1
		
	moveAmount = moveAmount.normalized()
	
	position+=moveAmount * delta * 400 * 1/zoom.x
	
func ClickAndDrag():
	pass
