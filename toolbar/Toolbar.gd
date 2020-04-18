extends Control

const COUNT = 4

var index = 0

var SelectedTheme = load("res://toolbar/selected.tres") as Theme
var UnselectedTheme = load("res://toolbar/unselected.tres") as Theme

# Called when the node enters the scene tree for the first time.
func _ready():
	update_selected()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var old_index = index
	if Input.is_action_just_released("next_toolbar"):
		print(index)
		index += 1
	elif Input.is_action_just_released("previous_toolbar"):
		index -= 1
	index = index % COUNT
	if old_index != index:
		update_selected()

func update_selected():
	var i = 0
	for item in $HToolbar.get_children():
		print(i)
		if i == index:
			print("selected")
			item.get_child(1).visible = true
		else:
			item.get_child(1).visible = false
		i += 1
