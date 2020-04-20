extends Area2D
signal kill_target

export(NodePath) var target
export var max_dist_fire = 300
export var reloading_time = 5
export var aiming_time = 2

var noselPosition
var is_alive = true
var is_reloading = false
var is_aiming = false
var anim
var new_anim

func _ready():
	target = get_node(target) as KinematicBody2D
	noselPosition = get_node("GunEnd").get_position()
	$AimTimer.wait_time = aiming_time
	$CoolDownTimer.wait_time = reloading_time
	$Hitbox.disabled = true
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
		$AnimatedSprite.play(anim)
	
	
func can_aim_and_shoot():
	var dist = self.get_position().distance_to(target.get_position())
	return dist < max_dist_fire && is_alive && not is_reloading && not is_aiming

func aim_and_shoot():
	# The sniper is vulnerable while it aims
	$Hitbox.disabled = false
	
	$AimTimer.start()
	is_aiming = true
	
func shoot():
	$ShootAudioPlayer.play()
	
	$CoolDownTimer.start()
	
	# The sniper is invincible when reloading
	$Hitbox.disabled = true
	
	#TODO: Spawn bullet

	# For the moment: raycasts
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(noselPosition, target.get_position())

	# If the target is not covered: kills it
	if result.collider == target:
		emit_signal("kill_target")

# Draw laser sight
# The width is decreasing with time
func _draw():
	if is_aiming and is_alive:
		var space_state = get_world_2d().direct_space_state
		var result = space_state.intersect_ray(noselPosition, target.get_position())
		
		var time_left = $AimTimer.get_time_left()
		var max_ray_width = 5
		draw_line(Vector2(0, 0), result.position - noselPosition, Color(255, 0, 0), time_left*(max_ray_width/aiming_time))

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
	$Hitbox.disabled = true

func hit_by_bullet():
	_on_death()
