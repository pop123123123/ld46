extends RigidBody2D

var moveSpeed = 5
var direction = 1

func _ready():
	pass


func _process(delta):
	pass

func _physics_process(delta):
	self.set_linear_velocity(Vector2(20, 0))
