extends Node2D

const saveFileName = "user://checkpoint.tmp"

var level_path = "res://main/MainScene.tscn"
var levelInstance = null

# Retrieves savefile's spawn position and applies it to the player
func _ready():
	levelInstance = load(level_path)
	var player = self.get_node("Player")
	var target = self.get_node("Target")
	
	var spawn_pos = _get_spawn_pos()
	if spawn_pos:
		player.set_position(spawn_pos)
		target.set_position(spawn_pos+Vector2(10, 0))

func _get_spawn_pos():
	var savefile = File.new()
	var doFileExists = savefile.file_exists(saveFileName)
	
	if not doFileExists:
		return null
	
	if savefile.open(saveFileName, File.READ) != 0:
		return null
	
	var line = savefile.get_line()
	savefile.close()
	
	var positions = line.split(',')
	
	return Vector2(positions[0], positions[1])

func _set_spawn_pos(checkpoint_pos):
	var savefile = File.new()
	if savefile.open(saveFileName, File.WRITE) != 0:
		print("Error opening file")
		
	var vector2_serialized = str(checkpoint_pos.x) + "," + str(checkpoint_pos.y)
	savefile.store_line(vector2_serialized)
	
	savefile.close()

func _process(_delta):
	var reset = Input.is_action_just_pressed("reset")
	var hard_reset = Input.is_action_just_pressed("hard_reset")
	
	# Reloads the savefile
	if reset:
		retry()
	
	# Destroys the savefile
	if hard_reset:
		var dir = Directory.new()
		dir.remove("user://checkpoint.tmp")
		retry()

func _on_Target_gameover():
	self.get_node("GameOverScreen").launch_game_over()

func _on_Player_use_interactive_tool(tool_index, player_position):
	get_tree().call_group("Interactives", "use_tool", tool_index, player_position)

func _on_CheckpointHandler_checkpointed_reached(checkpoint_pos):
	_set_spawn_pos(checkpoint_pos)

func retry():
	queue_free()
	var your_current_level_var = levelInstance.instance()
	get_parent().add_child(your_current_level_var)
