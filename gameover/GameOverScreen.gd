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

# Set GameOver screen size to window size
func update_to_window_size():
	var windowSize = get_viewport().get_size()
	var background = (get_node("GameOverNode/Background") as ColorRect)
	var display = (get_node("GameOverNode/Display") as Node2D)
	background.set_size(windowSize)
	display.set_position(Vector2(windowSize.x / 2, windowSize.y / 2))

func launch_game_over():
	($loose as AudioStreamPlayer).play()
	update_to_window_size()
	# Wait a second before showing GameOver screen
	yield(get_tree().create_timer(1), "timeout")
	var gameOver = get_node("GameOverNode")
	var moi = get_tree()
	while gameOver.modulate.a < 255:
		gameOver.modulate.a  += 1
		yield(moi,"idle_frame")
