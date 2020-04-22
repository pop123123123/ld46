extends Node2D
signal kill_target
signal shock_player

var player
var target

export var enable_rotation = true

export var use_trigger = true
var trigger_activated = false

export var max_dist_fire = 300

export var aiming_time = 2.0
export var cooldown_time = 3.0
export var exposed_time = 1.0

export var fix_death_direction = false
export var left_direction : bool
export var raise_on_death : float

var is_alive = true
var is_reloading = false
var is_exposed = false
var is_aiming = false
var anim
var new_anim

var WILHEMCOUNT = 7
var wilhemCount = 0

func _ready():
	player = self.get_parent().get_node("Player") as RigidBody2D
	target = self.get_parent().get_node("Target") as KinematicBody2D
	
	$AimTimer.wait_time = aiming_time
	$CoolDownTimer.wait_time = cooldown_time
	$ExposedTimer.wait_time = exposed_time
	
	$GuyArea/Hitbox.disabled = true
	
	set_process(true)

func _process(delta):
	update()
	if can_aim_and_shoot():
		aim_and_shoot()

	# Animation handling
	if is_alive:
		if is_reloading:
			new_anim = "hide"
		elif is_aiming:
			new_anim = "show"
		elif is_exposed:
			new_anim = "shoot"
		else:
			new_anim = "hide"
	else:
		new_anim = "death"
	
	if new_anim != anim:
		anim = new_anim
		$GuyArea/AnimatedSprite.play(anim)
		look_target()
	
func look_target():
	if is_alive:		
		var direction = sign((self.get_position()-target.get_position()).x)
		
		if enable_rotation:
			var angle = $GuyArea.get_global_position().angle_to_point(target.get_position())
			if direction == -1:
				$GuyArea.set_rotation(angle+PI)
			else:
				$GuyArea.set_rotation(angle)

func can_aim_and_shoot():
	var dist = self.get_position().distance_to(target.get_position())
	return dist < max_dist_fire && is_alive && not is_exposed && not is_reloading && not is_aiming && trigger_check()

func trigger_check():
	return not use_trigger || trigger_activated

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
const max_ray_width = 6
func _draw():
	if is_aiming and is_alive:
		var space_state = get_world_2d().direct_space_state
		# Global coordinates
		var result = space_state.intersect_ray($GuyArea/GunEnd.get_global_position(), target.get_position(), [], 0xFFFFFFFF)
		#var result = space_state.intersect_ray($GuyArea.get_global_position(), target.get_position(), [], 0xFFFFFFFF)
		
		var time_left = $AimTimer.get_time_left()
		
		# Do not print line durig first frames of animation (the sniper is not aiming)
		if $AimTimer.wait_time-time_left > 0.5:
			# Screen coordinates
			var gun = $GuyArea.transform.xform($GuyArea/GunEnd.get_position())
			draw_line(gun, result.position-self.get_position(), Color(140.0/255, 145.0/255, 247.0/255), time_left*(max_ray_width/aiming_time))
			draw_line(gun, result.position-self.get_position(), Color(1,1,1), time_left*(max_ray_width/aiming_time/3))

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
		$ExposedTimer.start()
		is_exposed = true

func _on_CoolDownTimer_timeout():
	is_reloading = false
	
func _on_ExposedTimer_timeout():
	is_exposed = false
	$CoolDownTimer.start()
	is_reloading = true
	
	# The sniper is invincible when reloading
	$GuyArea/Hitbox.disabled = true
	
func _on_death():
	self.position.y += raise_on_death
	if fix_death_direction:
		if left_direction:
			update_aim_left()
		else:
			update_aim_right()
	
	$GuyArea.set_rotation(0)
	
	$GuyArea/Hitbox.disabled = true
	wilhemCount = wilhemCount + 1
	if WILHEMCOUNT == wilhemCount:
		wilhemCount = 0
		($deathWilhem as AudioStreamPlayer2D).play()
	else:
		if is_alive:
			($death as AudioStreamPlayer2D).play()
	$GuyArea/AnimatedSprite.play("death")
	is_alive = false

func hit_by_bullet():
	_on_death()

func _on_Trigger_body_entered(_body):
	trigger_activated = true
