extends Area2D
signal kill_target

func _ready():
	pass # Replace with function body.

func _process(delta):
	pass

func _on_Spike_area_entered(area):
	#TODO: you can go next to the spikes without dying
	if area.has_method("_kill_target"):
		emit_signal("kill_target")
