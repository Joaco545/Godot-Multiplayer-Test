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


#region CONNECTION EVENTS

# Called on server and client on connection event
func peer_connected(id):
	print("Player {id} conected!".format({"id": id}))
	


# Called on server and client on disconnect event
func peer_disconnected(id):
	print("Player {id} disconnected".format({"id": id}))
	


# Called on client on connection event
func connected_to_server():
	print("Connected to server sucessfuly")
	
	is_client_connected = true
	


# Called on client on initial connection failed event
func connection_failed():
	print("Coudn't connect to server")
	
	is_client_connected = false
	


# Called on client on server disconnetion event
func server_disconnected():
	print("Disconnected from server")
	

#endregion


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
