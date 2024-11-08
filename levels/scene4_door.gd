extends GridMap

const KILL_AMOUNT = 16
var door = null

# Called when the node enters the scene tree for the first time.
func _ready():
	door = get_node(".")
	door.set_collision_layer_value(1,true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_area_3d_before_body_entered(body):
	if body.is_in_group("player"):
		if Global.kills >= KILL_AMOUNT:
			# Open the door by removing the collision shape
			door.visible = false
			door.set_collision_layer_value(1,false)

