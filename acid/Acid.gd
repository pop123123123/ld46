extends Node2D

export var amount = 50
export var width = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	$Emitter.amount = amount
	($Emitter.emission_shape as RectangleShape2D).extents.x = width

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
