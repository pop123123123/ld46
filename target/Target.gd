extends KinematicBody2D
signal gameover

enum Tool{
	WHISTLE,
	UMBRELLA,
	GUN,
	CROWBAR
}

export var force = 100
var gravity = force * 10
var moving = true

func _ready():
	#($AnimationPlayer as AnimationPlayer).play("running")
	self.move_and_slide(Vector2(force, 0), Vector2(0, 1))

func _process(_delta):
	if moving:
		($AnimationPlayer as AnimationPlayer).play("running")

func _physics_process(delta):
	if moving:
		if test_move(self.transform, Vector2(0, 8)):
			self.move_and_slide_with_snap(Vector2(force, 0), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
			print('is')
		else:
			self.move_and_slide_with_snap(Vector2(0, gravity), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
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
