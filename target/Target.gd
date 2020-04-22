extends KinematicBody2D
signal gameover

enum Tool{
	UMBRELLA,
	GUN,
	NOTHING
}

export var force = 1 * 60
var gravity = force * 10

var is_alive = true

export var acid_resistance = 3
var lifepoints

var prevPosition = Vector2(0, 0)

func _ready():
	lifepoints = acid_resistance

func _process(_delta):
	if is_alive:
		if not ($walk as AudioStreamPlayer2D).is_playing():
			($walk as AudioStreamPlayer2D).play()		
		($AnimatedSprite as AnimatedSprite).play("running")
		prevPosition = self.position

func _physics_process(delta):
	if is_alive:
		var coll = move_and_collide(Vector2(0, 5), false, false, true)
		if coll and coll.get_collider().has_method('get_tileset'):
			self.move_and_slide_with_snap(Vector2(force, 1), Vector2(0, 20), Vector2(0, 1), true, 4, PI)
		elif coll:
			self.move_and_slide(Vector2(force, 0), Vector2(0, 1))
		else:
			self.move_and_slide_with_snap(Vector2(0, gravity), Vector2(0, 20), Vector2(0, 1), true, 4, PI)

func use_tool(tool_index, _player_pos):
	pass

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(_body):
	if _body.is_in_group('hurt'):
		$LifebarTimer.start()
		($damage as AudioStreamPlayer2D).play()
		lifepoints -= 1
		if lifepoints == 0:
			_kill_target()

func _kill_target():
	if is_alive:
		is_alive = false
		($damage as AudioStreamPlayer2D).play()
		($death as AudioStreamPlayer2D).play()
		($AnimatedSprite as AnimatedSprite).play("death")
		
		emit_signal("gameover")

func _on_LifebarTimer_timeout():
	lifepoints = acid_resistance
