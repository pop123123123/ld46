extends RigidBody2D
signal gameover

enum Tool{
	WHISTLE,
	UMBRELLA,
	GUN,
	CROWBAR
}

export var moveSpeed = 50
var moving = true

func _ready():
	#($AnimationPlayer as AnimationPlayer).play("running")
	pass

func _process(_delta):
	if moving:
		self.set_axis_velocity(Vector2(moveSpeed, 0))
		($AnimationPlayer as AnimationPlayer).play("running")
	else:
		self.set_axis_velocity(Vector2(0, 0))

func _physics_process(_delta):
	pass

func use_tool(tool_index, _player_pos):
	if tool_index == Tool.WHISTLE:
		print("La petite bète a été siffled. PADANLARU")
		if moving:
			moving = false
		else:
			moving = true

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(_body):
	hide()
	emit_signal("gameover")
