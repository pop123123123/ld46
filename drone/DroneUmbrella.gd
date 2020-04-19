extends KinematicBody2D

export var speed = 1.0
export var loop = false
export var loop_distance = 40

var pos_start = null
var pos_end = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pos_start = self.position.x
	pos_end = pos_start + sign(speed) * loop_distance

var turning = true
var eff_speed = 0
var acc = 1
func _physics_process(delta):
	if turning and abs(eff_speed) < abs(speed) or sign(speed) != sign(eff_speed):
		var left = min(acc, abs(speed - eff_speed))*sign(speed)
		eff_speed += left
	elif turning:
		eff_speed = speed
		turning = false
	if loop and abs(self.position.x - pos_start) > abs(loop_distance) and sign(speed) != abs(self.position.x - pos_start) and not turning:
		speed *= -1
		var start = pos_start
		pos_start = pos_end
		pos_end = start
		turning = true
	self.set_position(self.get_position() + Vector2(eff_speed, 0))
