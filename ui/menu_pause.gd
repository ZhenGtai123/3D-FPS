extends "res://ui/menu_base.gd"


func _ready():
	var unpauseButton = $Unpause
	unpauseButton.pressed.connect(self.pause_handler)
	super()
	self.hide()


func _process(delta):
	if Input.is_action_just_pressed("pauseGame"):
		pause_handler()
	else:
		super(delta)


func pause_handler():
	if get_tree().paused:
		unpause()
	else:
		pause()


func unpause():
	$"../Kills".show()
	self.hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false

func pause():
	$"../Kills".hide()
	self.show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = true


func start():
	unpause()
	super()
