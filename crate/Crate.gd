extends RigidBody2D

var cutTime = 1.87
var totalDuration = 7.5
var timeBetweenEachSound = 1

var lastPosition = Vector2(0, 0)
var lastVelocity = Vector2(0, 0)

var soundOffset = 0
var timeSincePlay = 0

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timeSincePlay += delta
	if (self.lastPosition - self.position).length() > 1:
		if not ($Sound as AudioStreamPlayer2D).is_playing():
			timeSincePlay = 0
			($Sound as AudioStreamPlayer2D).play(soundOffset)
	if ($Sound as AudioStreamPlayer2D).is_playing() and timeSincePlay > timeBetweenEachSound:
		($Sound as AudioStreamPlayer2D).stop()
		soundOffset += cutTime
		if soundOffset > totalDuration:
			soundOffset = 0
	if self.get_linear_velocity() == Vector2(0, 0) and lastVelocity[1] > 1:
		($impact as AudioStreamPlayer2D).play()		
			
	lastPosition = self.position
	lastVelocity = self.get_linear_velocity()
