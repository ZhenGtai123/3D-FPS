extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var random = RandomNumberGenerator.new();
	random.randomize();
	var random_number = random.randf_range(1, 100);
	Global.player_health = random_number;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
