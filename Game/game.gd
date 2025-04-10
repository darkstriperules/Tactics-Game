extends Node2D

@onready var mainTileMap = $MainGameplay/TileMapLayer
@onready var multiplayerSpawner = $MainGameplay/MultiplayerSpawner
@onready var mainGameplay = $MainGameplay
@onready var troopSelector = $TroopSelector


const Unit = preload("res://Game/Unit.tscn")
var units: Array = []
enum GAMESTATE {INIT, START, PLAN, ACTIVE, END}
var P1Status

#To get troops, do:
#troopSelector.squadTroops
#This returns an array with the selected troops
#TODO make sure to use TroopMatcher.random_troop() if no troop selected!
#This means if the return is null to setting a troop, it should randomize it!!!

func _ready() -> void:
	if Multiplayer.is_host:
		_host_join()

func _process(delta: float) -> void:
	if !troopSelector.visible && !mainGameplay.visible:
		mainGameplay.visible = true

func _host_join() -> void:
	multiplayerSpawner.spawn_function = add_player
	
	multiplayer.peer_connected.connect(
		func(pid):
			print("Peer " + str(pid) + " has joined the game!")
			multiplayerSpawner.spawn(pid)
			mainTileMap.initialize.rpc()
	)
	
	multiplayerSpawner.spawn(multiplayer.get_unique_id())

func add_player(pid):
	var unit = Unit.instantiate()
	unit.name = str(pid)
	mainTileMap.add_child(unit)
	#uni.global_position = $TileMapLayer.get_child(units.size()).global_position
	units.append(unit)
	
	return unit
