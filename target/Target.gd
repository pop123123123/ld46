extends KinematicBody2D
signal gameover

enum Tool{
	WHISTLE,
	UMBRELLA,
	GUN,
	CROWBAR
}

export var force = 1 * 60
var gravity = force * 1000
var moving = true


func _process(_delta):
	if moving:
		($AnimationPlayer as AnimationPlayer).play("running")

func _physics_process(delta):
	if moving:
		if move_and_collide(Vector2(0, 8), false, false, true):
			self.move_and_slide_with_snap(Vector2(force*delta, 0), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
		else:
			self.move_and_slide_with_snap(Vector2(0, gravity*delta), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
	else:
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
	_kill_target()

func _kill_target():
	hide()
	emit_signal("gameover")
