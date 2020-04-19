extends Node2D

signal checkpointed_reached

func _ready():
	pass

func _process(delta):
	pass

func _on_Checkpoint1_body_entered(body):
	var checkpoint_pos = self.get_node("Checkpoint1").get_position()
	emit_signal("checkpointed_reached", checkpoint_pos)


func _on_Checkpoint2_body_entered(body):
	var checkpoint_pos = self.get_node("Checkpoint2").get_position()
	emit_signal("checkpointed_reached", checkpoint_pos)
