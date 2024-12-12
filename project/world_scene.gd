extends Node2D

var modes = ["moveSelect", "placeTower", "deleteTower"]
var mode = "moveSelect"
var selectedTower = "Archer"

signal towerSelected(selectedTower)

func changeMode(newMode: int) -> void:
	mode = modes[newMode]
	towerSelected.emit(false) # clear selection

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("mainClick") and event.pressed:
		if mode == "placeTower":
			placeTower(selectedTower)
		elif mode == "deleteTower":
			deleteTower()
		elif mode == "moveSelect":
			selectTower()
		
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
		
