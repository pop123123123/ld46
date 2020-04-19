extends Camera2D

export(NodePath) var playerPath
export(NodePath) var targetPath

var player
var target

func _ready():
	player = get_node(playerPath) as RigidBody2D
	target = get_node(targetPath) as KinematicBody2D
	if player!=null&&target!=null:
		set_process(true)

func _process(_delta):
	#var dist = player.get_position().distance_to(target.get_position())
	#var lim = 600
	
	var la_distance = (player.get_position()-target.get_position())*1.2
	var zoom_val = max(1, sqrt(1*la_distance.length()/300))
	
	self.zoom = Vector2(zoom_val, zoom_val)
	self.set_position(target.get_position()+la_distance/2)
