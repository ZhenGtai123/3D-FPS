extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Kills.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.kills == 2 or Global.kills > 2:
		$NavigationRegion3D/InnnerWalls/Room13/Portal/Area3D/CollisionShape3D.disabled = false
	$Kills.text = "Enemies left: " + str(42 - Global.kills)
