extends Control


func _ready():
	$AudioStreamPlayer.play()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var startButton = $Start
	startButton.pressed.connect(self.start)
	var quitButton = $Quit
	quitButton.pressed.connect(self.quit)


func _process(_delta):
	
	if Input.is_action_just_pressed("startGame"):
		start()
	elif Input.is_action_just_pressed("exitGame"):
		quit()


func start():
	
	get_tree().change_scene_to_file(Global.currentScene)


func quit():
	get_tree().quit()
