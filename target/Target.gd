extends KinematicBody2D
signal gameover

export var moveSpeed = 20

func _ready():
	pass

func _process(delta):
	self.move_and_slide(Vector2(20, 0))
	self.position
	#self.set_linear_velocity(Vector2(moveSpeed, 1))

func _physics_process(delta):
	pass

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(body):
	hide()
	emit_signal("gameover")
