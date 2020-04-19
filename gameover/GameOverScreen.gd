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
	self.get_node("GameOverNode").visible = true
	self.get_node("GameOverNode/Button").disabled = false

func _on_Button_pressed():
	emit_signal("retry")
