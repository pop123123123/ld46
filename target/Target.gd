extends RigidBody2D
signal gameover

export var alive = true
var moveSpeed = 20

func _ready():
	pass


func _process(delta):
	pass

func _physics_process(delta):
	self.set_linear_velocity(Vector2(moveSpeed, 0))

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(body):
	hide()
	emit_signal("gameover")
