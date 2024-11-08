extends Node

const TUTORIAL_SCENE_PATH = "res://main.tscn"
const LEVEL_3_SCENE_PATH = "res://levels/3/level_3.tscn"
const LEVEL_4_SCENE_PATH = "res://levels/scene4.tscn"
const PLAYER_MAX_HEALTH = 100
const PLAYER_START_HEALTH = PLAYER_MAX_HEALTH
const PLAYER_MAX_CURRENT_AMMO = 30
const PICKUP_AMMO_AMOUNT = 45
const PICKUP_AMMO_FIRST_CURRENT_AMOUNT = PLAYER_MAX_CURRENT_AMMO
const PICKUP_AMMO_FIRST_RESERVE_AMOUNT = 2 * PLAYER_MAX_CURRENT_AMMO
const PICKUP_HEALTH_AMOUNT = 25

@onready var player_health
@onready var player_current_ammo = 0
@onready var player_reserve_ammo = 0
@onready var popup_move
@onready var popup_health
@onready var popup_reload
@onready var popup_shoot
@onready var kills = 0
@onready var currentScene = TUTORIAL_SCENE_PATH
@onready var current_scene_path = TUTORIAL_SCENE_PATH
var current_scene = null


func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)


func goto_scene(path):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.
	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()
	# Load the new scene.
	var s = ResourceLoader.load(path)
	# Instance the new scene.
	current_scene = s.instantiate()
	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)
	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene
