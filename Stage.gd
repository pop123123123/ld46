extends Node2D

var level_scenes = [preload("res://tuto/Tuto.tscn")]
var current_level_index = 0

var current_level

func _ready():
	_load_level(current_level_index)

func _end_of_level():
	self.remove_child(current_level)
	current_level_index += 1
	
	if current_level_index == level_scenes.size():
		#TODO: credits screen ?
		pass
	else:
		_load_level(current_level_index)
	
func _reload_level():
	self.remove_child(current_level)
	_load_level(current_level_index)
	
func _load_level(index):
	current_level = level_scenes[index].instance()
	add_child(current_level)
	current_level.connect("end_of_level", self, "_end_of_level")
	current_level.connect("reload_level", self, "_reload_level")
