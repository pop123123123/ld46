extends Control

const COUNT = 3

export var index = 2

var SelectedTheme = load("res://toolbar/selected.tres") as Theme
var UnselectedTheme = load("res://toolbar/unselected.tres") as Theme

# Called when the node enters the scene tree for the first time.
func _ready():
	update_selected()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var old_index = index
	if Input.is_action_just_released("next_toolbar"):
		index += 1
	elif Input.is_action_just_released("previous_toolbar"):
		index -= 1
		
	if Input.is_action_just_released("select_umbrella"):
		index = 0
	elif Input.is_action_just_released("select_gun"):
		index = 1
	elif Input.is_action_just_released("select_hands"):
		index = 2
		
	# Godot script has a strange modulus
	while index < 0:
		index += 3
	index = index % COUNT
	if old_index != index:
		update_selected()

func update_selected():
	var i = 0
	if index == 0:
		($umbrella as AudioStreamPlayer).play()
	if index == 1:
		($gun as AudioStreamPlayer).play()
	for item in $HToolbar.get_children():
		if i == index:
			item.get_child(1).visible = true
		else:
			item.get_child(1).visible = false
		i += 1
