extends CanvasLayer
signal retry

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func launch_game_over():
	yield(get_tree().create_timer(1), "timeout")
	self.get_node("GameOverNode/Button").disabled = false
	var colorRect = self.get_node("GameOverNode")
	while colorRect.modulate.a < 255:
		colorRect.modulate.a  += 0.02
		yield(get_tree(),"idle_frame")

func _on_Button_pressed():
	emit_signal("retry")
