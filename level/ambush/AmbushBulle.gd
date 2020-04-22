extends Sprite


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Trigger_body_entered(body):
	self.visible = true
	$GetOut.play()
	$Timer.start()
	
func _on_Timer_timeout():
	self.visible = false
