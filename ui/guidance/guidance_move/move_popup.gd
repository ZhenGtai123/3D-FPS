extends PopupPanel

# THIS IS THE POPUP PANEL FOR SHOWING THE USER HOW TO MOVE AROUND THE MAP.
# IT NEEDS TO BE CALLED WHEN THE USER FIRST ENTERS THE MAP.
# IT NEEDS TO DISSAPEAR AFTER A CERTAIN AMOUNT OF TIME, WHEN THE USER HAS 
#  MOVED AROUND THE MAP.
# THE ONLY THING THIS SCRIPT NEEDS TO DO IS TOGGLE THE VISIBILITY OF THE POPUP 
#  PANEL.
# THE REST OF THE LOGIC IS HANDLED BY THE MAP SCENE.

# Constants for time delay
const TIME_DELAY = 5.0  # Adjust this as needed (in seconds)

# Variables
var timer_active = false
var move_started = false
var popup_hidden = true

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set it to unfocusable
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)
	set_handle_input_locally(false)
	set_disable_input(true)

	# Set the initial visibility of the popup panel
	show()
	Global.popup_move = true

	# Check if visibility is set to true
	if popup_hidden and not visible:
		# If the popup is hidden, show it
		visible = true
		popup_hidden = false
	
	# Start a timer to hide the popup after a certain time 
	$Timer.set_wait_time(TIME_DELAY)
	$Timer.start()
	timer_active = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if timer_active and check_if_input_was_move():
		move_started = true
		
func check_if_input_was_move():
	# if Input.is_action_just_pressed("move_around_map"): 
	# 	# The "move_around_map" action should be triggered when the user moves 
	#	# around the map.
	# 	return true
	if (Input.is_action_just_pressed("forward") 
		or Input.is_action_just_pressed("backward") 
		or Input.is_action_just_pressed("left") 
		or Input.is_action_just_pressed("right")
	):
		# WASD keys should be triggered when the user moves around the map.
		return true
	if (Input.is_action_just_pressed("jump") 
		or Input.is_action_just_pressed("sprint")
	):
		# Jumping or sprinting should also be triggered when the user moves 
		# around the map.
		return true
	return false

# Check if there are any active popups
func check_active_popups():
	if Global.popup_reload or Global.popup_health or Global.popup_shoot:
		return false
	if not Global.popup_move:
		return true
	return false

# Called when the timer times out
func _on_timer_timeout():
	if move_started:
		Global.popup_move = false
		hide()  # Hide the popup
		queue_free()  # Remove the popup from the scene
	else:
		# If the user hasn't moved, restart the timer
		$Timer.start()
		timer_active = true

# Called when the popup is hidden
func _on_popup_hide():
	# Set the popup_hidden variable to true
	popup_hidden = true

# # Called when the node receives input
# func _on_label_gui_input(event):
# 	if event is InputEventMouseButton:
# 		# If the user clicks on the popup, hide it
# 		hide()
# 		queue_free()  # Remove the popup from the scene
