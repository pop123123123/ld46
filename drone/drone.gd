extends RigidBody2D

const UP = Vector2(0, -1)

export var speed = 1.0
export var loop = false
export var loop_distance = 40

var pos_start = null
var pos_end = null

var width = null
var up = null
var left_propeller = null
var right_propeller = null
var gravity = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pos_start = self.position.x
	pos_end = pos_start + sign(speed) * loop_distance
	
	var mi = INF
	var ma = -INF
	for p in $Shape.get_polygon():
		if p.x < mi:
			mi = p.x
		if p.x > ma:
			ma = p.x
		if up == null or p.y < up:
			up = p.y
	width = ma - mi
	left_propeller = Vector2(-width/2, up)
	right_propeller = Vector2(width/2, up)
	gravity = self.get_weight() * 10
	self.add_force(Vector2(0,0), gravity * UP)

#func _process(delta):
#	pass
var turning = true

func _physics_process(delta):
	var local_left_propeller = self.get_transform().basis_xform(left_propeller.normalized()) * left_propeller.length()
	var local_right_propeller = self.get_transform().basis_xform(right_propeller.normalized()) * right_propeller.length()

	var f = self.get_transform().basis_xform(UP).normalized() * gravity * delta

	var c = 4
	var acc = 6
	var a = - f / 2 * sign(speed)
	if turning and abs(self.linear_velocity.x) < abs(speed) or sign(speed) != sign(self.linear_velocity.x):
		var left = min(1, abs(speed - self.linear_velocity.x))
		self.apply_impulse(local_left_propeller, -a*left/c)
		self.apply_impulse(local_right_propeller, a*left/c)
		if sign(f.x) == sign(speed):
			self.apply_central_impulse(Vector2(f.x*acc, 0))
	elif turning:
		self.set_linear_velocity(Vector2(speed, self.get_linear_velocity().y))
		self.set_angular_velocity(0)
		turning = false
	else:
		self.set_angular_velocity(0)
	
	if loop:
		if abs(self.position.x - pos_start) > abs(loop_distance) and sign(speed) != abs(self.position.x - pos_start) and not turning:
			speed *= -1
			var start = pos_start
			pos_start = pos_end
			pos_end = start
			turning = true
