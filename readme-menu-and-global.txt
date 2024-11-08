res://global.gd based on https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html

To make the menus (and persistent global variables) work:
- If you want the current scene to change for any reason, call Global.goto_scene(path) with the path to the new scene.
- In the final level when the game is won, from a script call Global.goto_scene("res://ui/menu_won.tscn")
- In the player dies, from the player script call Global.goto_scene("res://ui/menu_lost.tscn")
- If you want any variables to transfer to other scenes, like player health and bullet count, use the apropriate variables Global.player_health and Global.player_bullet_count. If you copy their value to a local variable in a script, make sure to copy them back just before changing scenes.
- Before turning in set res://ui/menu_base.gd/TUTORIAL_SCENE_PATH to the correct path.
