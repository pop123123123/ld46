class_name Bullet
extends RigidBody2D

#export var linear_velocity : Vector2

var disabled = false

func _ready():
	($Timer as Timer).start()


func _physics_process(delta):
	self.position += linear_velocity * delta

func disable():
	if disabled:
		return
	
	($AnimationPlayer as AnimationPlayer).play("shutdown")
	disabled = true

func _on_Bullet_body_entered(body):
	print(body)
	if body.has_method("hit_by_bullet"):
		body.call("hit_by_bullet")
	elif body.has_method("get_tileset"):
		disable()


func _on_Area2D_area_entered(area):
	#print('area', ((area as Area2D).get_owner() as RigidBody2D).get_name())
	if area.has_method("hit_by_bullet"):
		area.call("hit_by_bullet")
