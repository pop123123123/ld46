extends Node2D

func _ready():
	pass

func _process(delta):
	pass

# TODO: print gameover screen
func _on_Target_gameover():
	print("T'as perdu gros nullos")


func _on_Player_use_interactive_tool(tool_index, player_position):
	get_tree().call_group("Interactives", "use_tool", tool_index, player_position)
