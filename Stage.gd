extends Node2D

var level_scenes = [preload("res://transitions/Startup.tscn"), preload("res://tuto/Tuto.tscn")] # TO ADD STARTUP SCREEN
# [preload("res://transitions/Startup.tscn"), preload("res://tuto/Tuto.tscn"), preload("res://levels/Levelshooting.tscn"), preload("res://level/Ambush.tscn"), preload("res://levelClassicRemastered.tscn")]
var credits_scene = preload("res://transitions/Credits.tscn")
var current_level_index = 0

var current_level
var currentPlayer
var startMusicPlayer
var mainMusicPlayer
var endMusicPlayer

func _ready():
	startMusicPlayer = get_node("StartMusic") as AudioStreamPlayer
	mainMusicPlayer = get_node("MainMusic") as AudioStreamPlayer
	endMusicPlayer = get_node("EndMusic") as AudioStreamPlayer
	
	changeMusicTrack("StartMusic")
	_load_level(current_level_index)
	
func _process(_delta):
	if Input.is_action_pressed("quit"):
	  get_tree().quit()

func _end_of_level():
	self.remove_child(current_level)
	current_level_index += 1
	print(current_level_index)
	if current_level_index == level_scenes.size():
		changeMusicTrack("EndMusic")
		add_child(credits_scene.instance())
	else:
		changeMusicTrack("MainMusic")
		_load_level(current_level_index)
	
func _reload_level():
	self.remove_child(current_level)
	_load_level(current_level_index)
	
func _load_level(index):
	current_level = level_scenes[index].instance()
	add_child(current_level)
	current_level.connect("end_of_level", self, "_end_of_level")
	current_level.connect("reload_level", self, "_reload_level")

func changeMusicTrack(newPlayer):
	if currentPlayer != newPlayer:
		startMusicPlayer.stop()
		mainMusicPlayer.stop()
		endMusicPlayer.stop()

		if newPlayer == "StartMusic":
			startMusicPlayer.play()
		elif newPlayer == "MainMusic":
			mainMusicPlayer.play()
		elif newPlayer == "EndMusic":
			endMusicPlayer.play()

		currentPlayer = newPlayer
	
