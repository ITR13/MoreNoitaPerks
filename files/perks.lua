local FILE_ROOT = "mods/perks_by_itr/files/"
local PERK_UI_GFX_DIR = FILE_ROOT.."ui_gfx/perk_icons/"
local PERK_ITEM_GFX_DIR = FILE_ROOT.."items_gfx/perks/"
local PERK_SCRIPT_DIR = FILE_ROOT.."scripts/perks/"

dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( PERK_SCRIPT_DIR.."set_material_damage.lua" )


local protection_radioactivity = get_perk_with_id(perk_list, "PROTECTION_RADIOACTIVITY")
if protection_radioactivity ~= nil then
	protection_radioactivity["func"] = function( entity_perk_item, entity_who_picked, item_name )
		set_material_damage( entity_who_picked,
		{
			ice_radioactive_static		= 0,
			ice_poison_static			= 0,
			radioactive_gas				= 0,
			radioactive_gas_static		= 0,
			cloud_radioactive			= 0,
			radioactive_liquid			= 0,
			radioactive_liquid_fading	= 0,
			radioactive_liquid_yellow	= 0,
			ice_radioactive_glass		= 0,
			ice_poison_glass			= 0,
			rock_static_poison			= 0,
			rock_static_radioactive		= 0,
		} )
	end
end

table.insert(perk_list,
{
	id = "HIGH_GRAVITY",
	ui_name = "High gravity",
	ui_description = "Your movement is heavier and you jump and fly shorter.",
	ui_icon = PERK_UI_GFX_DIR.."high_gravity.png",
	perk_icon = PERK_ITEM_GFX_DIR.."high_gravity.png",
	stackable = STACKABLE_MAX_AMOUNT,
	usable_by_enemies = true,
	func = function( entity_perk_item, entity_who_picked, item_name )

		local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
		if( models ~= nil ) then
			for i,model in ipairs(models) do
				local gravity = tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * 1.8
				ComponentSetValue( model, "pixel_gravity", gravity )
			end
		end

	end,
} )


table.insert(perk_list,
{
	id = "CHEAP_REROLL",
	ui_name = "Cheaper rerolls",
	ui_description = "Rerolls cost less",
	ui_icon = PERK_UI_GFX_DIR.."cheaper_rerolls.png",
	perk_icon = PERK_ITEM_GFX_DIR.."cheaper_rerolls.png",
	stackable = STACKABLE_MAX_AMOUNT,
	usable_by_enemies = true,
	func = function( entity_perk_item, entity_who_picked, item_name )
		local perk_reroll_count = tonumber( GlobalsGetValue( "TEMPLE_PERK_REROLL_COUNT", "0" ) )
		perk_reroll_count = perk_reroll_count - 3 --200 * 2^-3 = 25
		GlobalsSetValue( "TEMPLE_PERK_REROLL_COUNT", tostring( perk_reroll_count ) )
	end,
} )


table.insert(perk_list,
{
	id = "BLEED_TELEPORTIUM",
	ui_name = "Teleporting blood",
	ui_description = "You bleed teleportium",
	ui_icon = PERK_UI_GFX_DIR.."teleportium_blood.png",
	perk_icon = PERK_ITEM_GFX_DIR.."teleportium_blood.png",
	usable_by_enemies = true,
	func = function( entity_perk_item, entity_who_picked, item_name )

		local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
		if( damagemodels ~= nil ) then
			for i,damagemodel in ipairs(damagemodels) do
				ComponentSetValue( damagemodel, "blood_material", "magic_liquid_teleportation" )
				ComponentSetValue( damagemodel, "blood_spray_material", "magic_liquid_teleportation" )
				ComponentSetValue( damagemodel, "blood_multiplier", "3.0" )
				ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
				ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
			end
		end
	end,
} )



table.insert(perk_list,
{
	id = "BLEED_FIRE",
	ui_name = "Blazing blood",
	ui_description = "You bleed fire",
	ui_icon = PERK_UI_GFX_DIR.."fire_blood.png",
	perk_icon = PERK_ITEM_GFX_DIR.."fire_blood.png",
	game_effect = "PROTECTION_FIRE",
	usable_by_enemies = true,
	func = function( entity_perk_item, entity_who_picked, item_name )

		local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
		if( damagemodels ~= nil ) then
			for i,damagemodel in ipairs(damagemodels) do
				ComponentSetValue( damagemodel, "blood_material", "fire" )
				ComponentSetValue( damagemodel, "blood_spray_material", "fire" )
				ComponentSetValue( damagemodel, "blood_multiplier", "6.0" )
				ComponentSetValue( damagemodel, "blood_sprite_directional", "data/particles/bloodsplatters/bloodsplatter_directional_purple_$[1-3].xml" )
				ComponentSetValue( damagemodel, "blood_sprite_large", "data/particles/bloodsplatters/bloodsplatter_purple_$[1-3].xml" )
			end
		end
	end,
} )


table.insert(perk_list,
{
	id = "REVENGE_RATS",
	ui_name = "Revenge rats",
	ui_description = "Spawns a plague rat whenever you take damage",
	ui_icon = PERK_UI_GFX_DIR.."revenge_rats.png",
	perk_icon = PERK_ITEM_GFX_DIR.."revenge_rats.png",
	usable_by_enemies = true,
	func = function( entity_perk_item, entity_who_picked, item_name )
		EntityAddComponent( entity_who_picked, "LuaComponent",
		{
			script_damage_received = PERK_SCRIPT_DIR.."revenge_rats.lua",
			execute_every_n_frame = "-1",
		} )
		GenomeSetHerdId( entity_who_picked, "rat" )
	end,
} )


table.insert(perk_list,
{
	id = "ACID_BODY",
	ui_name = "Acid body",
	ui_description = "Immune to acids, but voletile towards water",
	ui_icon = PERK_UI_GFX_DIR.."acid_body.png",
	perk_icon = PERK_ITEM_GFX_DIR.."acid_body.png",
	stackable = STACKABLE_MAX_AMOUNT,
	usable_by_enemies = false,
	func = function( entity_perk_item, entity_who_picked, item_name )
		water_damage = get_material_damage( entity_who_picked, "water" )
		if water_damage ~= nil then
			water_damage = tostring(tonumber(water_damage) + 0.002)
		else
			water_damage = "0.002"
		end
		
		set_material_damage( entity_who_picked,
		{
			acid			=	0,
			ice_acid_static	=	0,
			ice_acid_glass	=	0,
			acid_gas		=	0,
			acid_gas_static =	0,
			water_static	=	water_damage,
			water			=	water_damage,
			water_temp		=	water_damage,
			water_ice		=	water_damage,
			water_swamp		=	water_damage,
			swamp			=	water_damage,
			water_salt		=	water_damage,
			water_fading	=	water_damage,
		} )
	end,
} )


table.insert(perk_list,
{
	id = "LAVA_IMMUNITY",
	ui_name = "Lava dweller",
	ui_description = "Take no damage from lava, but be careful of fire!",
	ui_icon = PERK_UI_GFX_DIR.."lava_immunity.png",
	perk_icon = PERK_ITEM_GFX_DIR.."lava_immunity.png",
	usable_by_enemies = false,
	func = function( entity_perk_item, entity_who_picked, item_name )
		set_material_damage( entity_who_picked,
		{
			lava = 0
		} )
	end,
} )
