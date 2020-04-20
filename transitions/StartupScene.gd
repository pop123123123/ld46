extends Node2D
signal end_of_level

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _process(_delta):
	var use = Input.is_action_pressed("use")
	# Press Use key to start playing
	if use:
		emit_signal("end_of_level")
