extends Node2D

signal checkpointed_reached

func _ready():
	pass

func _process(_delta):
	pass

func _on_Checkpoint_body_entered(body):
	var checkpointTest = self.get_node("CanvasLayer/CheckpointActivated")
	checkpointTest.visible = true
	emit_signal("checkpointed_reached", body.get_position())
	yield(_waiting(), "completed")
	checkpointTest.visible = false

func _waiting():
	yield(get_tree().create_timer(2), "timeout")
