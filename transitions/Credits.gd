extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var displaySize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var endScreen = get_node("EndScreen")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
