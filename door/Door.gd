extends Area2D

enum Tool{
	WHISTLE,
	UMBRELLA,
	GUN,
	CROWBAR
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func use_tool(tool_index, player_pos):
	if tool_index == Tool.CROWBAR:
		if self.position.x-player_pos.x < 10:
			print("RIP LA PORTE")
			hide()
		else:
			print("Whoup whoup ca wiffe !")
