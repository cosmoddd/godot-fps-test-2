extends Area

signal TriggerEntered

export(Resource) var dialogData
export(bool) var inTrigger
export (String, FILE, "*.json") var dailogPath 
export(String) var diaKey
export var dialogDict = {}
export(Array) var keys
export(Array) var diaArray
export(String) var currentDialog = "zooby zooby zoo"

export(NodePath) var textLabel1Path
var textLabel1

var optionScreen = false
var textTweenFader

func _ready():
	TextInit()
	textLabel1 = get_node(textLabel1Path)
	textLabel1.modulate.a = 0
	pass # Replace with function body.


func TextInit():
	var dat = File.new()
	dat.open(dailogPath, dat.READ)
	var parsedText = parse_json(dat.get_as_text())
	dat.close()
	dialogDict = parsedText
	# print(testDir)
	keys = dialogDict.keys()
	if (dialogDict.keys().has(diaKey)):
		diaArray = (dialogDict[diaKey])
		print("We are trying to display: "+diaArray[0])
		print(dialogData.currentPosition)
	else:
		print("NO KEY HERE, boys")
		pass
	# $"Dialog Router"._ThisLine()
	# $"Dialog Router"._PersonSpeaks()  # test
	pass

func _on_body_entered(body):
	print(body.name)
	print("Trigger entered!")
	emit_signal("TriggerEntered")
	$"Dialog Router".t = 0
	inTrigger = true
	$"Dialog Router"._ThisLine()
	$"Dialog Router"._PersonSpeaks()
	$TextFadeTweener.playback_speed = 1  # fade in the text
	$TextFadeTweener.interpolate_property(textLabel1, "modulate",Color( 1, 1, 1, textLabel1.modulate.a), Color( 1, 1, 1, 1 ), 1, Tween.EASE_IN, Tween.EASE_OUT)
	$TextFadeTweener.start()

	#	InitSoundSourceAndRouter(textBuilder1, textBuilder2, textBuilder3, dialogMode);  actually build the dialog
	pass

func _on_body_exited(body):
	print(body.name)
	print("Trigger exited!")
	inTrigger = false;
	# $TextFadeTweener.playback_speed = -1
	$TextFadeTweener.interpolate_property(textLabel1, "modulate", Color( 1, 1, 1, textLabel1.modulate.a), Color( 1, 1, 1, 0), 1, Tween.EASE_IN, Tween.EASE_OUT)
	$TextFadeTweener.start()
	pass

# public void DeactivateSoundSource(DialogBuilderCMD textBuilder1, DialogBuilderCMD textBuilder2, DialogBuilderCMD textBuilder3, DialogType dialogMode)
# {
# 	if (textBuilder1)
# 		textBuilder1.enabled = false;

# 	if (textBuilder2)
# 		textBuilder2.enabled = false;

# 	if (textBuilder3)
# 		textBuilder3.enabled = false;
# }

# public void SaveDialogVariables()
# {
# 	dialogSO.SaveData();
# }

# public void Escape()
# {
# 	GetComponent<Collider>().enabled = false;
# 	OnTriggerExit();
# }

# public void TestMessage(string s)
# {
# 	print(s);
# }

# }
