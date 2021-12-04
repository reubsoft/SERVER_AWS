extends Node


const PORT_SERVER = 36999
const MAX_PLAYER = 5

# Player info, associate ID to data
var players = {}
var self_data = {name = ''}

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self,"_player_disconnected")
	create_server()


func create_server():
	var peer = NetworkedMultiplayerENet.new()
	peer.create_server(PORT_SERVER, MAX_PLAYER)
	get_tree().network_peer = peer
	if get_tree().get_network_unique_id() != 1:
		print("ERRO AO INICIAR SERVIDOR")
		print("ERROR: ", get_tree().get_network_unique_id())
		exit_server()
		

func exit_server():
	get_tree().network_peer = null
	get_tree().quit()
	
# Cliente conecta no servidor e chama esse método
remote func _request_player_info_to_server(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_rpc_sender_id()
	# Store the info
	players[id] = info
	
	for player in players:
		if id != player:
			rpc_id(id, '_request_player_info', player, players[player])
	
remote func _request_message(message):
	var id = get_tree().get_rpc_sender_id()
	print("USER ",id," :", message)
	for player in players:
		if player != id:
			rpc_id(player, '_send_message', id, message)

func _player_connected(id):
	print("_player_connected : ", id)
	
func _player_disconnected(id):
	players.erase(id)
	print("player disconnected : ", id)


