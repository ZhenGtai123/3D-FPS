extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	mouse_force_pass_scroll_events = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
