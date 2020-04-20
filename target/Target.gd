extends KinematicBody2D
signal gameover

enum Tool{
	UMBRELLA,
	GUN,
	WHISTLE,
	NOTHING
}

export var force = 1 * 60
var gravity = force * 10
var moving = true

var prevPosition = Vector2(0, 0)

func _process(_delta):
	if (prevPosition - self.position).length() > 1.5:
		($damage as AudioStreamPlayer2D).play()
	if moving:
		if not ($walk as AudioStreamPlayer2D).is_playing():
			($walk as AudioStreamPlayer2D).play()		
		($AnimatedSprite as AnimatedSprite).play("running")
	prevPosition = self.position

func _physics_process(delta):
	if moving:
		var coll = move_and_collide(Vector2(0, 5), false, false, true)
		if coll and coll.get_collider().has_method('get_tileset'):
			print('tile')
			self.move_and_slide_with_snap(Vector2(force, 1), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
		elif coll:
			print('pa tile')
			self.move_and_slide(Vector2(force, 0), Vector2(0, 1))
		else:
			print('fall')
			self.move_and_slide_with_snap(Vector2(0, gravity), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
	else:
		pass

func use_tool(tool_index, _player_pos):
	if tool_index == Tool.WHISTLE:
		print("La petite bète a été siffled. PADANLARU")

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(_body):
	_kill_target()

func _kill_target():
	moving = false
	($death as AudioStreamPlayer2D).play()
	($AnimatedSprite as AnimatedSprite).play("death")
	#hide()
	emit_signal("gameover")
