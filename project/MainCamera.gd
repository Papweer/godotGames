extends Camera2D

var ZoomMin: Vector2 = Vector2(0.5,0.5)
var ZoomMax: Vector2 = Vector2(5.5,5.5)
var ZoomSpd: Vector2 = Vector2(0.3,0.3)
var PanSpeed: float = 1.0

var start_zoom: Vector2
var start_dist: float
var touch_points: Dictionary = {}
var start_angle: float
var current_angle: float


func _input(event):
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
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_zoom = zoom
		start_dist = 0



func _handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	# Handle 1 touch point
	if touch_points.size() == 1:
		position -= event.relative * PanSpeed / zoom
		
	# Handle 2 touch points
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])

		var zoom_factor = start_dist / current_dist
		zoom = start_zoom / zoom_factor
		if zoom < ZoomMin:
			zoom = ZoomMin
		elif zoom > ZoomMax:
			zoom = ZoomMax

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
