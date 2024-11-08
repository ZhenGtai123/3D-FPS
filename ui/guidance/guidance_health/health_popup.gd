extends PopupPanel

# THIS IS THE POPUP PANEL FOR SHOWING THE USER THAT THEY GOT HIT BY A BULLET.
# IT NEEDS TO BE CALLED WHEN THE USER GETS HIT BY A BULLET.
# IT NEEDS TO DISSAPEAR AFTER A CERTAIN AMOUNT OF TIME.
# THE ONLY THING THIS SCRIPT NEEDS TO DO IS TOGGLE THE VISIBILITY OF THE POPUP 
#  PANEL.
# THE REST OF THE LOGIC IS HANDLED BY THE MAP SCENE.

# Constants for time delay
const TIME_DELAY = 5.0  # Adjust this as needed (in seconds)
const MAX_HEALTH = 100

# Variables
var popup_hidden = true

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if check_if_player_got_hit() and check_active_popups():
		# Set the initial visibility of the popup panel
		show()
		Global.popup_health = true

		# Check if visibility is set to true
		if popup_hidden and not visible:
			# If the popup is hidden, show it
			visible = true
			popup_hidden = false
		
		# Start a timer to hide the popup after a certain time  
		$Timer.set_wait_time(TIME_DELAY)
		$Timer.start()

# Check if the player got hit by a bullet
func check_if_player_got_hit():
	# Check if the player got hit by a bullet
	# If the player got hit by a bullet, return true
	if Global.player_health < MAX_HEALTH:
		return true
	# Otherwise, return false
	return false

# Check if there are any active popups
func check_active_popups():
	if Global.popup_reload or Global.popup_move or Global.popup_shoot:
		return false
	if not Global.popup_health:
		return true
	return false

# Called when the timer times out
func _on_timer_timeout():
	Global.popup_health = false
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
