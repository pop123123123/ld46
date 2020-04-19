extends Area2D
signal kill_target

export(NodePath) var target
export var max_dist_fire = 300
export var reloading_time = 5
export var aiming_time = 2

var is_alive = true
var is_reloading = false
var is_aiming = false

func _ready():
	target = get_node(target) as KinematicBody2D
	$AimTimer.wait_time = aiming_time
	$CoolDownTimer.wait_time = reloading_time
	$Hitbox.disabled = true
	set_process(true)

func _process(delta):
	update()
	if can_aim_and_shoot():
		aim_and_shoot()
	
func can_aim_and_shoot():
	var dist = self.get_position().distance_to(target.get_position())
	return dist < max_dist_fire && is_alive && not is_reloading && not is_aiming

func aim_and_shoot():
	#TODO: animation -> vise
	
	# The sniper is vulnerable while it aims
	$Hitbox.disabled = false
	
	$AimTimer.start()
	is_aiming = true
	
func shoot():
	$ShootAudioPlayer.play()
	
	$CoolDownTimer.start()
	
	#TODO: animation -> caché
	# The sniper is invincible when reloading
	$Hitbox.disabled = true
	
	#TODO: Spawn bullet

	# For the moment: raycasts
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(self.get_position(), target.get_position())

	# If the target is not covered: kills it
	if result.collider == target:
		emit_signal("kill_target")

# Draw laser sight
# The width is decreasing with time
func _draw():
	if is_aiming:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(self.get_position(), target.get_position())
		
		var time_left = $AimTimer.get_time_left()
		var max_ray_width = 5
		draw_line(Vector2(0, 0), result.position-self.get_position(), Color(255, 0, 0), time_left*(max_ray_width/aiming_time))

# The sniper aimed enough: he now can shoot
func _on_AimTimer_timeout():
	is_aiming = false
	if is_alive:
		shoot()
	is_reloading = true

func _on_CoolDownTimer_timeout():
	is_reloading = false
