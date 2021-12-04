extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

# Apenas para debug, mostra clientes conectados no servidor
func _process(delta):
	$RichTextLabel.text = str(Network.players)
	pass
