extends Node

# Saves connected player information
# Key: Name, Value: {id} (its a map so it can store more data on the future)
var players = {}

# Saves current player's name
var client_name: String


# Tell the server to add us to the player list with out new name! :D
func spawn_player():
	MultiplayerController.send_player_information.rpc_id(1, client_name, multiplayer.get_unique_id())
