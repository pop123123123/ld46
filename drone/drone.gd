extends RigidBody2D

const UP = Vector2(0, -1)

export var speed = 1.0

var dir = 0
var width = null
var up = null
var left_propeller = null
var right_propeller = null
var gravity = null

# Called when the node enters the scene tree for the first time.
func _ready():
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
var i = 0

func _physics_process(delta):
	var local_left_propeller = self.get_transform().basis_xform(left_propeller.normalized()) * left_propeller.length()
	var local_right_propeller = self.get_transform().basis_xform(right_propeller.normalized()) * right_propeller.length()

	var f = self.get_transform().basis_xform(UP).normalized() * gravity * delta
	var a = f/2
	var b = f/2

	var c = 4
	var acc = 6
	a *= 1 if speed < 0 else -1
	var frames = 7 * (speed if speed > 0 else -speed)
	if i < frames:
		print(local_left_propeller, local_right_propeller)

		self.apply_impulse(local_left_propeller, -a /c)
		self.apply_impulse(local_right_propeller, a /c)
		self.apply_central_impulse(Vector2(f.x*acc, 0))
		i += 1
	elif i == frames:
		self.apply_central_impulse(Vector2(f.x*acc, 0))
		i += 1
	else:
		self.set_angular_velocity(0)
