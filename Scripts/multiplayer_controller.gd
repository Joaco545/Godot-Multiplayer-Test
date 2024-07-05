extends Node

const MAX_PLAYERS = 4

var is_host = false
var is_client_connected = false

var peer: ENetMultiplayerPeer



func _ready():
	
	multiplayer.peer_connected.connect(peer_connected)
	multiplayer.peer_disconnected.connect(peer_disconnected)
	multiplayer.connected_to_server.connect(connected_to_server)
	multiplayer.connection_failed.connect(connection_failed)
	multiplayer.server_disconnected.connect(server_disconnected)
	
	pass


#region NETWORKING SETUP

# Creates a server and connects you to it!
func initialize_server(port:int):
	if is_host or is_client_connected:
		print("Cannot initilize a server while connected!")
		return
	
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(port)
	
	if error != OK:
		print("Could not create server, error: %s", error)
		return
	
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Server created sucessfully")
	
	is_host = true
	
	# If the server is also a client, switch to lobby scene
	if !OS.has_feature("dedicated_server"):
		SceneManager.switch_scene("LOBBY")
	
	pass


func join_server(address:String, port:int):
	if is_host or is_client_connected:
		print("Cannot join while already connected!")
		return
	
	peer = ENetMultiplayerPeer.new()
	peer.create_client(address, port)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	
	multiplayer.set_multiplayer_peer(peer)
	
	print("Client created sucessfully")
	
	pass


#endregion


#region CONNECTION EVENTS

# Called on server and client on connection event
func peer_connected(id):
	print("Player {id} conected!".format({"id": id}))
	
	# Spawn new player on Lobby
	
	pass


# Called on server and client on disconnect event
func peer_disconnected(id):
	print("Player {id} disconnected".format({"id": id}))
	
	# Remove player (any time)
	
	pass


# Called on client on connection event
func connected_to_server():
	print("Connected to server sucessfuly")
	is_client_connected = true
	
	# Load lobby
	SceneManager.switch_scene("LOBBY")
	# Spawn all other players and sync pos
	# Get player name (Done on lobby)
	# Send info to others (Done on lobby)
	
	pass


# Called on client on initial connection failed event
func connection_failed():
	print("Coudn't connect to server")
	is_client_connected = false
	
	# Do nothing?
	
	pass


# Called on client on server disconnetion event
func server_disconnected():
	print("Disconnected from server")
	is_client_connected = false
	
	# Go back to main menu alone
	SceneManager.switch_scene("MAIN_MENU")
	
	pass

#endregion


#region GAME SETUP

@rpc("any_peer")
func send_player_information(name, id):
	# Si no me registre, o cambio mi ID (me re-conecte mas tarde al server)
	if !GameManager.players.has(name) or GameManager.players[name].id != id:
		GameManager.players[name] = {
			"id" : id
		}
	
	if multiplayer.is_server():
		for i in GameManager.players:
			if GameManager.players[i].id == id:
				continue;
			send_player_information.rpc(i, GameManager.players[i].id)
		
	pass

#endregion
