extends Node2D

var modes = ["moveSelect", "placeTower", "deleteTower"]
var mode = "moveSelect"
var selectedTower = "Archer"

signal towerSelected(selectedTower)

func changeMode(newMode: int) -> void:
	mode = modes[newMode]
	towerSelected.emit(false) # clear selection

var drag: bool = false
var touch: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag:
		print("drag")
		drag = true
	if (event.is_action_pressed("mainClick") and event is InputEventMouseButton and touch == false) or (event is InputEventScreenTouch and event.pressed == false and drag == false):
		if mode == "placeTower":
			placeTower(selectedTower)
		elif mode == "deleteTower":
			deleteTower()
		elif mode == "moveSelect":
			selectTower()
	if event.is_action_released("mainClick"):
		drag = false
	
	if event is InputEventScreenTouch:
		touch = true
	
func getBuildingsInCell(position: Vector2) -> Array:
	var cell_pos = position.snappedf(64)
	var objects = []
	
	for obj in get_children():
		if obj is Node2D and obj.position == cell_pos and obj is Tower:
			objects.append(obj)
	
	return objects

func placeTower(tower):
	if getBuildingsInCell(get_global_mouse_position()).size() == 0:
		var instance = load("res://Towers/"+tower+"Tower.tscn") 
		
		var obj = instance.instantiate()
		obj.position = get_global_mouse_position().snappedf(64)
		add_child(obj)

func deleteTower() -> void:
	if Input.is_action_just_pressed("mainClick"):
		for object in getBuildingsInCell(get_global_mouse_position()):
			object.queue_free()
	pass
		
func selectTower() -> void:
	var towers = getBuildingsInCell(get_global_mouse_position())
	var tower
	if towers.size() == 1:
		tower = towers[0]
	else:
		tower = false
	towerSelected.emit(tower)
		
