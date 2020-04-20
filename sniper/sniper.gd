extends Node2D
signal kill_target
signal shock_player

export(NodePath) var player
export(NodePath) var target

export var max_dist_fire = 300
export var reloading_time = 5
export var aiming_time = 2

var is_alive = true
var is_reloading = false
var is_aiming = false
var anim
var new_anim

func _ready():
	player = get_node(player) as RigidBody2D
	target = get_node(target) as KinematicBody2D
	
	$AimTimer.wait_time = aiming_time
	$CoolDownTimer.wait_time = reloading_time
	$GuyArea/Hitbox.disabled = true
	
	set_process(true)

func _process(delta):
	update()
	if can_aim_and_shoot():
		aim_and_shoot()

	# Animation handling
	if is_alive:
		if is_reloading:
			new_anim = "shoot"
		elif is_aiming:
			new_anim = "show"
		else:
			new_anim = "hide"
	else:
		new_anim = "death"
	
	if new_anim != anim:
		anim = new_anim
		$GuyArea/AnimatedSprite.play(anim)
		
	var angle = $GuyArea.get_global_position().angle_to_point(target.get_position())
	$GuyArea.set_rotation(angle+PI)
	
func can_aim_and_shoot():
	var dist = self.get_position().distance_to(target.get_position())
	return dist < max_dist_fire && is_alive && not is_reloading && not is_aiming

func aim_and_shoot():
	var direction = sign((self.get_position()-target.get_position()).x)
	if direction == -1:
		update_aim_right()
	else:
		update_aim_left()
	
	# The sniper is vulnerable while it aims
	$GuyArea/Hitbox.disabled = false
	
	$AimTimer.start()
	is_aiming = true
	
func shoot():
	$ShootAudioPlayer.play()
	
	$CoolDownTimer.start()
	
	# The sniper is invincible when reloading
	$GuyArea/Hitbox.disabled = true
	
	#TODO: Spawn bullet

	# For the moment: raycasts
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray($GuyArea/GunEnd.get_global_position(), target.get_position())
	
	# If the target is not covered: kills it
	if result.collider == target:
		emit_signal("kill_target")
	if result.collider == player || result.collider.get_name() == "Umbrella":
		emit_signal("shock_player")

# Draw laser sight
# The width is decreasing with time
func _draw():
	if is_aiming and is_alive:
		var space_state = get_world_2d().direct_space_state
		# Global coordinates
		var result = space_state.intersect_ray($GuyArea/GunEnd.get_global_position(), target.get_position())
		
		var time_left = $AimTimer.get_time_left()
		var max_ray_width = 5
		# Screen coordinates

		var gun = $GuyArea.transform.xform($GuyArea/GunEnd.get_position())
		draw_line(gun, result.position-self.get_position(), Color(0, 0, 255), time_left*(max_ray_width/aiming_time))

func update_aim_right():
	$GuyArea/AnimatedSprite.set_position(Vector2(61.902, 27.616))
	$GuyArea/AnimatedSprite.flip_h = false
	$GuyArea/Hitbox.set_position(Vector2(33.9, 5.037))
	$GuyArea/GunEnd.set_position(Vector2(57.116, 7.21))

func update_aim_left():
	$GuyArea/AnimatedSprite.set_position(Vector2(-59.481, 27.616))
	$GuyArea/AnimatedSprite.flip_h = true
	$GuyArea/Hitbox.set_position(Vector2(-33.741, 5.037))
	$GuyArea/GunEnd.set_position(Vector2(-56.291, 7.21))

# The sniper aimed enough: he now can shoot
func _on_AimTimer_timeout():
	is_aiming = false
	if is_alive:
		shoot()
	is_reloading = true

func _on_CoolDownTimer_timeout():
	is_reloading = false
	
func _on_death():
	is_alive = false
	set_process(false)
	$GuyArea/Hitbox.disabled = true

func hit_by_bullet():
	_on_death()
