extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.kills == 3:
		$AudioStreamPlayer3D.play()
		$floor/walls/door.visible = false
		$floor/walls/door.set_collision_layer_value(1,false)
		
	

