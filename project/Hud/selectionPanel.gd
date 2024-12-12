extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var current_scene = get_tree().get_current_scene()
	current_scene.towerSelected.connect(_onSelection)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var currentSelectedTower

@onready var selectionOutline: Node2D = get_tree().get_current_scene().find_child("SelectionOutline")

func _onSelection(selectedTower) -> void:
	if selectedTower:
		currentSelectedTower = selectedTower
		visible = true
		# Move Selection Outline
		selectionOutline.position = currentSelectedTower.position
		selectionOutline.visible = true
	else:
		visible = false
		selectionOutline.visible = false
	pass
			
func _onUpgrade() -> void:
	currentSelectedTower.upgradeTower()
	
func _onDelete() -> void:
	currentSelectedTower.queue_free()
	visible = false
	selectionOutline.visible = false
