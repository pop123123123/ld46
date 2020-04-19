extends Node2D

signal checkpointed_reached

func _ready():
	pass

func _process(_delta):
	pass

func _on_Checkpoint_body_entered(body):
	emit_signal("checkpointed_reached", body.get_position())
