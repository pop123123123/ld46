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

func _process(delta):
	var dist = player.get_position().distance_to(target.get_position())
	var lim = 600
	
	var zoom_val = max(0.5, dist/lim)
	self.zoom = Vector2(zoom_val, zoom_val)

	var camera_pose = player.get_position().linear_interpolate(target.position, 0.5)

	var direction = camera_pose.direction_to(player.get_position()).x
	if direction < 0:
		direction = -1
	else:
		direction = 1
	
	var direction_shift
	if dist <= 30:
		direction_shift = dist*direction
	else:
		direction_shift = direction*30
	
	self.set_position(camera_pose+Vector2(direction_shift, 0))
	#self.set_position(camera_pose)
