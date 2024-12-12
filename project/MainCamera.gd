extends Camera2D

var ZoomMin: Vector2 = Vector2(0.5,0.5)
var ZoomMax: Vector2 = Vector2(5.5,5.5)
var ZoomSpd: Vector2 = Vector2(0.3,0.3)
var PanSpeed: float = 1.0

var startZoom: Vector2
var startDist: float
var touchPoints: Dictionary = {}


func _input(event):
	print(event)
	if event is InputEventScreenTouch:
		_handle_touch(event)
	elif event is InputEventScreenDrag:
		_handle_drag(event)

	if event.is_action_pressed("zoomOut"):
		if zoom > ZoomMin:
			zoom -= ZoomSpd
	if event.is_action_pressed("zoomIn"):
		if zoom < ZoomMax:
			zoom +=ZoomSpd
	pass

func _handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touchPoints[event.index] = event.position
	else:
		touchPoints.erase(event.index)



func _handle_drag(event: InputEventScreenDrag):
	touchPoints[event.index] = event.position
	# Handle 1 touch point
	if touchPoints.size() == 1:
		position -= event.relative * PanSpeed / zoom
		
	if touchPoints.size() == 2:
		# Find the index of the not moving
		var pivotIndex = 1 if event.index == 0 else 0

		# get the 3 point involved
		var pivotPoint: Vector2 = touchPoints[pivotIndex]
		var oldPoint: Vector2 = touchPoints[event.index]
		var newPoint: Vector2 = event.position

		var oldVector: Vector2 = oldPoint - pivotPoint
		var newVector: Vector2 = newPoint - pivotPoint
		
		var deltaScale = newVector.length() / oldVector.length()
		zoom *= deltaScale
		touchPoints[event.index] = newPoint
		
		var drag_vector: Vector2 = event.relative
		offset -= drag_vector / 2 * zoom
		#if zoom < ZoomMin:
		#	zoom = ZoomMin
		#elif zoom > ZoomMax:
		#	zoom = ZoomMax

var speed = 1000
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var velocity = Vector2()  # The player's movement vector.
	if Input.is_action_pressed("moveRight"):
		velocity.x += 1
	if Input.is_action_pressed("moveLeft"):
		velocity.x -= 1
	if Input.is_action_pressed("moveDown"):
		velocity.y += 1
	if Input.is_action_pressed("moveUp"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed / zoom.x
	position += velocity * _delta
