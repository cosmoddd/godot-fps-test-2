extends Node

export var active = false
export var splitStrang = []
export(String) var builtString

export(NodePath) var textLabelPath
var textLabel

var time = 0
var stringIndex = 0
var over = false

export(float) var dynamicTime = .5

func _ready():
	textLabel = get_node(textLabelPath)
	pass

func _BuildDialog(strang):
	builtString = ""
	# textLabel.bbcode_text = "" # reset
	stringIndex = 0
	splitStrang = strang.split(" ")

	pass
	
func _process(delta):
	if (!active || stringIndex >= splitStrang.size()):
		pass

	else: 
		if (time < dynamicTime && over == false):
			time += delta
			pass
		else:
			over = true
			# print("do something...")
			print(stringIndex)
			time = 0
			builtString = (builtString+splitStrang[stringIndex]+" ")
			# print(builtString)
			stringIndex+=1
			textLabel.bbcode_text = builtString # build the string!
			over = false
			pass
			# bbcode_text = builtString[stringIndex]
			# append_bbcode(builtString)

