@tool
@icon("res://addons/func_godot/icons/icon_godambler3d.svg")
class_name FuncGodotFGDConditionalModelPointClass extends FuncGodotFGDPointClass
## FGD ConditionalModelPointClass entity definition.
##
## A resource used to define an FGD ConditionalModelPointClass entity. Extends the regular FuncGodotFGDPointClass.
## With this you can define a list of conditional models
##
## @tutorial(Quake Wiki Entity Article): https://quakewiki.org/wiki/Entity
## @tutorial(Level Design Book: Entity Types and Settings): https://book.leveldesignbook.com/appendix/resources/formats/fgd#entity-types-and-settings-basic
## @tutorial(Valve Developer Wiki FGD Article): https://developer.valvesoftware.com/wiki/FGD#Class_Types_and_Properties
## @tutorial(dumptruck_ds' Quake Mapping Entities Tutorial): https://www.youtube.com/watch?v=gtL9f6_N2WM
## @tutorial(Level Design Book: Display Models for Entities): https://book.leveldesignbook.com/appendix/resources/formats/fgd#display-models-for-entities
## @tutorial(Valve Developer Wiki FGD Article: Entity Description Section): https://developer.valvesoftware.com/wiki/FGD#Entity_Description
## @tutorial(TrenchBroom Manual: Display Models for Entities): https://trenchbroom.github.io/manual/latest/#display-models-for-entities

@export_tool_button("Attach Conditionals to metadata") var metadata_wrangle_action = metadata_wrangle
@export var defaultModelPath: ModelDescriptor = null
@export var conditionalStatements: Dictionary[String, ModelDescriptor]
@export var modelScaleMultiplier: int = 32;
@export var multiplyByScaleKey: bool = true

func metadata_wrangle() -> void:
	var scaleExpr := '"scale": '+str(modelScaleMultiplier)
	if multiplyByScaleKey:
		scaleExpr+="*scale"
	
	var modelSwitcher := "";
	if conditionalStatements or defaultModelPath:
		modelSwitcher = "{{ "
	
	if conditionalStatements:
		modelSwitcher += ""
		for conditionalStatement in conditionalStatements.keys():
			var modelDescriptor: ModelDescriptor = conditionalStatements.get(conditionalStatement)
			if !modelDescriptor:
				continue
			modelSwitcher += conditionalStatement + ' -> { "path": "'+modelDescriptor.path+'", "frame":'+str(modelDescriptor.frame)+', "skin":'+str(modelDescriptor.skin)+', '+scaleExpr+' }, '
		if !defaultModelPath:
			modelSwitcher = modelSwitcher.trim_suffix(", ")
	
	if defaultModelPath:
		modelSwitcher += '{ "path": "'+defaultModelPath.path+'", "frame":'+str(defaultModelPath.frame)+', "skin":'+str(defaultModelPath.skin)+', '+scaleExpr+' }'
		
	if conditionalStatements or defaultModelPath:
		modelSwitcher += " }}"
	self.meta_properties["model"] = modelSwitcher

func _init() -> void:
	prefix = "@PointClass"
