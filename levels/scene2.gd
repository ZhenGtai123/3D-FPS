extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.visible = true
	Global.currentScene = "res://levels/scene2.tscn"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.kills == 8 or Global.kills > 8:
		$AudioStreamPlayer.play()
		$NavigationRegion3D/Building/door.visible = false
		$NavigationRegion3D/Building/door.set_collision_layer_value(1,false)

	$Kills.text = "Enemies left: " + str(8 - Global.kills)



func _on_area_3d_body_entered(body):	
	if body.is_in_group("player"):
		$player.queue_free()
		get_tree().change_scene_to_file("res://levels/3/level_3.tscn")

