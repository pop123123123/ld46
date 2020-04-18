extends KinematicBody2D
signal gameover

enum Tool{
	WHISTLE,
	UMBRELLA,
	GUN,
	CROWBAR
}

export var moveSpeed = 20
var moving = true

func _ready():
	pass

func _process(delta):
	if moving:
		self.move_and_slide(Vector2(moveSpeed, 0))

func _physics_process(delta):
	pass

func use_tool(tool_index, player_pos):
	if tool_index == Tool.WHISTLE:
		print("La petite bète a été siffled. PADANLARU")
		if moving:
			moving = false
		else:
			moving = true

# Hurtbox hit a treat
# Game over
func _on_HurtboxArea_body_entered(body):
	hide()
	emit_signal("gameover")
