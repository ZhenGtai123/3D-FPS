extends PopupPanel

# THIS IS THE POPUP PANEL FOR SHOWING THE USER THAT CAN SHOOT AND LOOK AROUND.
# IT NEEDS TO BE CALLED WHEN THE USER IS ABLE TO SHOOT AND LOOK AROUND.
# IT NEEDS TO DISSAPEAR AFTER A CERTAIN AMOUNT OF TIME.
# THE ONLY THING THIS SCRIPT NEEDS TO DO IS TOGGLE THE VISIBILITY OF THE POPUP 
#  PANEL.
# THE REST OF THE LOGIC IS HANDLED BY THE MAP SCENE.

# Constants for time delay and show delay
const TIME_DELAY = 5.0  # Adjust this as needed (in seconds)
const SHOW_DELAY = 20.0 # Adjust this as needed (in seconds)

# Variables
var timer_active = false
var popup_hidden = true
var look_around = false
var shoot = false
var show_timer = null
var popup_timer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set it to unfocusable
	set_flag(Window.FLAG_NO_FOCUS, true)
	set_flag(Window.FLAG_MOUSE_PASSTHROUGH, true)
	set_handle_input_locally(false)
	set_disable_input(true)

	# Set the initial visibility of the popup panel
	visible = false
	popup_hidden = true

	# Save the timer in a variable
	popup_timer = $Timer

	# Set a new timer with the show delay
	show_timer = Timer.new()
	show_timer.set_wait_time(SHOW_DELAY)
	show_timer.set_autostart(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_if_user_looks_around() and check_active_popups():
		# Set the initial visibility of the popup panel
		show_popup_shoot()
	else:
		# Check if the SHOW_DELAY timer is finished
		if (show_timer.is_stopped() 
			and not timer_active 
			and check_active_popups()
		):
			# Try to force the popup to show up
			show_popup_shoot()

	# Check if the timer is finished
	if timer_active and popup_timer.is_stopped():
		# If the timer is finished, hide the popup
		hide()
		queue_free()  # Remove the popup from the scene

# Show the popup
func show_popup_shoot():
	show()
	Global.popup_shoot = true

	# Check if visibility is set to true
	if popup_hidden and not visible:
		# If the popup is hidden, show it
		visible = true
		popup_hidden = false
	
	# Start a timer to hide the popup after a certain time  
	popup_timer.set_wait_time(TIME_DELAY)
	popup_timer.start()
	timer_active = true

func _input(event):
	if (event is InputEventMouseButton 
		and event.button_index == MOUSE_BUTTON_LEFT 
		and event.pressed
	):
		shoot = true
	if (event is InputEventMouseMotion):
		look_around = true

# Check if the user is able to look around
func check_if_user_looks_around():
	if (shoot or look_around):
		return true
	return false

# Check if there are any active popups
func check_active_popups():
	if Global.popup_health or Global.popup_move or Global.popup_health:
		return false
	if not Global.popup_shoot:
		return true
	return false

# Called when the timer times out
func _on_timer_timeout():
	Global.popup_shoot = false
	hide()  # Hide the popup
	queue_free()  # Remove the popup from the scene

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
