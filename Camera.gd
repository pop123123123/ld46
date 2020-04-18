extends Camera2D

export(NodePath) var playerPath
export(NodePath) var targetPath

var player
var target

func _ready():
	player = get_node(playerPath) as RigidBody2D
	target = get_node(targetPath) as RigidBody2D
	if player!=null&&target!=null: 
		set_process(true)

func _process(delta):
	self.set_position(player.get_position().linear_interpolate(target.get_position(), 0.5))
