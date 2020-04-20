extends CanvasLayer
signal retry

var me

func _ready():
	me = get_tree()

# Set GameOver screen size to window size
func update_to_window_size():
	var displaySize = Vector2(ProjectSettings.get_setting("display/window/size/width"), ProjectSettings.get_setting("display/window/size/height"))
	var background = (get_node("GameOverNode/Background") as ColorRect)
	var display = (get_node("GameOverNode/Display") as Node2D)
	background.set_size(displaySize)
	display.set_position(displaySize / 2)

func launch_game_over():
	($loose as AudioStreamPlayer).play()
	update_to_window_size()
	# Wait a second before showing GameOver screen
	var gameOver = get_node("GameOverNode") as Control
	yield(me.create_timer(1), "timeout")
	while gameOver.modulate.a < 255:
		gameOver.modulate.a += 1
		yield(me,"idle_frame")
