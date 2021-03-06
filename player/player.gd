class_name Player
extends RigidBody2D

signal use_interactive_tool

enum Tool{
	UMBRELLA,
	GUN,
	NOTHING
}

# Character Demo, written by Juan Linietsky.
#
#  Implementation of a 2D Character controller.
#  This implementation uses the physics engine for
#  controlling a character, in a very similar way
#  than a 3D character controller would be implemented.
#
#  Using the physics engine for this has the main advantages:
#    - Easy to write.
#    - Interaction with other physics-based objects is free
#    - Only have to deal with the object linear velocity, not position
#    - All collision/area framework available
#
#  But also has the following disadvantages:
#    - Objects may bounce a little bit sometimes
#    - Going up ramps sends the chracter flying up, small hack is needed.
#    - A ray collider is needed to avoid sliding down on ramps and
#      undesiderd bumps, small steps and rare numerical precision errors.
#      (another alternative may be to turn on friction when the character is not moving).
#    - Friction cant be used, so floor velocity must be considered
#      for moving platforms.

const WALK_ACCEL = 5000.0
const WALK_DEACCEL = 800.0
const WALK_MAX_VELOCITY = 140.0
const AIR_ACCEL = 1000.0
const AIR_DEACCEL = 200.0
const JUMP_VELOCITY = 500
const STOP_JUMP_FORCE = 450.0
const MAX_SHOOT_POSE_TIME = 0.3
const MAX_FLOOR_AIRBORNE_TIME = 0.15

const SOUND_DECAY = 20

var prevJumping = false

var anim = ""
# One animation per tool
var anim_iddle_tool = ["idleUmbrella", "idleGun", "idle"]
var anim_run_tool = ["runUmbrella", "runGun", "run"]
var anim_jumping_tool = ["jumpingUmbrella", "jumpingGun", "jumping"]
var anim_falling_tool = ["fallingUmbrella", "fallingGun", "falling"]

var siding_left = false
var jumping = false
var stopping_jump = false
var shoot = false
var shooting = false

var is_shocked = false
var is_alive = true

var sound_decay = SOUND_DECAY
var sound_offset = 0

var floor_h_velocity = 0.0

var airborne_time = 1e20
var shoot_time = 1e20

var Bullet = preload("res://player/Bullet.tscn")

var tool_index = Tool.NOTHING

func _ready():
	switch_umbrella(false)
	pass
	#hide_all_items()

func _process(_delta):
	if _can_control():
		#var use = Input.is_action_just_pressed("use")
		var use = Input.is_action_pressed("use")
		
		var new_tool_index = self.get_node("Tools/Toolbar").index
		
		# On tool change
		if new_tool_index != tool_index:
			tool_index = new_tool_index
			switch_umbrella(false)
			# Shifts the sprite to match umbrella animartion
			if tool_index == Tool.UMBRELLA:
				switch_umbrella(true)
			
		# Use a tool
		if use:
			if tool_index == Tool.GUN:
				shoot = true
		else:
			shoot = false

func _integrate_forces(s):
		# Retrieves the index of the selected tool
		var tool_index = self.get_node("Tools/Toolbar").index
		
		var lv = s.get_linear_velocity()
		var step = s.get_step()
		
		var new_anim = anim
		var new_siding_left = siding_left
		
		# Get the controls.
		var move_left = Input.is_action_pressed("move_left") && _can_control()
		var move_right = Input.is_action_pressed("move_right") && _can_control()
		var jump = Input.is_action_pressed("jump") && _can_control()
		var spawn = Input.is_action_pressed("spawn") && _can_control()
		
		if spawn:
			call_deferred("_spawn_enemy_above")
		
		# Deapply prev floor velocity.
		lv.x -= floor_h_velocity
		floor_h_velocity = 0.0
		
		# Find the floor (a contact with upwards facing collision normal).
		var found_floor = false
		var floor_index = -1
		
		for x in range(s.get_contact_count()):
			var ci = s.get_contact_local_normal(x)
			
			if ci.dot(Vector2(0, -1)) > 0.6:
				found_floor = true
				floor_index = x
		
		# A good idea when implementing characters of all kinds,
		# compensates for physics imprecision, as well as human reaction delay.
		if shoot and not shooting:
			call_deferred("_shot_bullet")
		else:
			shoot_time += step
		
		if found_floor:
			airborne_time = 0.0
		else:
			airborne_time += step # Time it spent in the air.
		
		var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME
	
		# Process jump.
		if jumping:
			if lv.y > 0:
				# Set off the jumping flag if going down.
				jumping = false
			elif not jump:
				stopping_jump = true
			
			if stopping_jump:
				lv.y += STOP_JUMP_FORCE * step
		
		if not prevJumping and on_floor:
			($fall as AudioStreamPlayer).play()
		
		if on_floor:
			# Process logic when character is on floor.
			if move_left and not move_right:
				if lv.x > -WALK_MAX_VELOCITY:
					lv.x -= WALK_ACCEL * step
			elif move_right and not move_left:
				if lv.x < WALK_MAX_VELOCITY:
					lv.x += WALK_ACCEL * step
			else:
				var xv = abs(lv.x)
				xv -= WALK_DEACCEL * step
				if xv < 0:
					xv = 0
				lv.x = sign(lv.x) * xv
				
			if move_left or move_right:
				if sound_decay == SOUND_DECAY:
					sound_decay = 0
					($SoundWalk as AudioStreamPlayer2D).stop()
					($SoundWalk as AudioStreamPlayer2D).play(sound_offset)
					sound_offset += 0.5
					if sound_offset > 9:
						sound_offset = 0
				sound_decay += 1
			
			if not move_left and not move_right:
				sound_decay = SOUND_DECAY
				($SoundWalk as AudioStreamPlayer2D).stop()
				
			if jumping:
				sound_decay = SOUND_DECAY
				($SoundWalk as AudioStreamPlayer2D).stop()
			
			# Check jump.
			if not jumping and jump:
				lv.y = -JUMP_VELOCITY
				jumping = true
				stopping_jump = false
				($SoundJump as AudioStreamPlayer2D).play()
			
			if jumping:
				new_anim = anim_jumping_tool[tool_index]
			elif abs(lv.x) < 0.1:
				if shoot_time < MAX_SHOOT_POSE_TIME:
					new_anim = "idle_weapon"
				else:
					new_anim = anim_iddle_tool[tool_index]
			else:
				if shoot_time < MAX_SHOOT_POSE_TIME:
					new_anim = "run_weapon"
				else:
					new_anim = anim_run_tool[tool_index]
		else:
			# Process logic when the character is in the air.
			if move_left and not move_right:
				if lv.x > -WALK_MAX_VELOCITY:
					lv.x -= AIR_ACCEL * step
			elif move_right and not move_left:
				if lv.x < WALK_MAX_VELOCITY:
					lv.x += AIR_ACCEL * step
			else:
				var xv = abs(lv.x)
				xv -= AIR_DEACCEL * step
				
				if xv < 0:
					xv = 0
				lv.x = sign(lv.x) * xv
			
			if lv.y < 0:
				if shoot_time < MAX_SHOOT_POSE_TIME:
					new_anim = "jumping_weapon"
				else:
					new_anim = anim_jumping_tool[tool_index]
			else:
				if shoot_time < MAX_SHOOT_POSE_TIME:
					new_anim = "falling_weapon"
				else:
					new_anim = anim_falling_tool[tool_index]
		
		# Check siding.
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		# Update siding.
		if new_siding_left != siding_left:
			if new_siding_left:
				($AnimatedSprite as AnimatedSprite).scale.x = -1
			else:
				($AnimatedSprite as AnimatedSprite).scale.x = 1
			
			siding_left = new_siding_left
		
		# Change animation.
		if _can_control() && new_anim != anim:
			anim = new_anim
			($AnimatedSprite as AnimatedSprite).play(anim)
		
		shooting = shoot
		
		# Apply floor velocity.
		if found_floor:
			floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
			lv.x += floor_h_velocity
		
		# Finally, apply gravity and set back the linear velocity.
		lv += s.get_total_gravity() * step
		s.set_linear_velocity(lv)
		prevJumping = on_floor


func _shot_bullet():
	shoot_time = 0
	var bi = Bullet.instance()
	var ss
	if siding_left:
		ss = -1.0
	else:
		ss = 1.0
	var pos = position + ($BulletShoot as Position2D).position * Vector2(ss, 1.0)
		
	bi.position = pos
	get_parent().add_child(bi)
	
	bi.linear_velocity = Vector2(400.0 * ss, 0)
	
	($SoundShoot as AudioStreamPlayer2D).play()
	
	add_collision_exception_with(bi) # Make bullet and this not collide.

func switch_umbrella(activate):
	if activate:
		($Umbrella).set_collision_layer_bit(3, 1)
		$AnimatedSprite.set_position(Vector2(0, -13.622))
	else:
		($Umbrella).set_collision_layer_bit(3, 0)
		($AnimatedSprite).set_position(Vector2(0, 0))
			
func _can_control():
	return not is_shocked && is_alive

func _on_shock():
	$ShockTimer.start()
	is_shocked = true
	anim = "shock"
	($AnimatedSprite as AnimatedSprite).play(anim)
	$SoundShock.play()
	switch_umbrella(false)

func _on_ShockTimer_timeout():
	is_shocked = false
	if tool_index == Tool.UMBRELLA:
		switch_umbrella(true)

func _on_Target_gameover():
	switch_umbrella(false)
	
	is_alive = false
	anim = "fail"
	($AnimatedSprite as AnimatedSprite).play(anim)
