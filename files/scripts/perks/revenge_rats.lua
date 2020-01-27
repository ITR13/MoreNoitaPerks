dofile_once("data/scripts/lib/utilities.lua")

function damage_received( damage, desc, entity_who_caused, is_fatal )
	local entity_id    = GetUpdatedEntityID()
	local pos_x, pos_y = EntityGetTransform( entity_id )
	
	if ( entity_who_caused == entity_id ) or ( ( EntityGetParent( entity_id ) ~= NULL_ENTITY ) and ( entity_who_caused == EntityGetParent( entity_id ) ) ) then return end

	if script_wait_frames( entity_id, 5 ) then  return  end
	
	SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + entity_id )
	
	local extra_hp = math.max( 0, pos_y * 0.0002 )
	local extra_damage = math.max( 0, pos_y * 0.0001 )

	local eid = EntityLoad( "data/entities/misc/perks/plague_rats_rat.xml", pos_x, pos_y )
	EntityRemoveTag( eid, "homing_target" )
	
	edit_component( eid, "DamageModelComponent", function(comp,vars)
		local hp = tonumber(ComponentGetValue( comp, "hp"))
		vars.max_hp = hp + extra_hp
		vars.hp = hp + extra_hp
	end)
	
	edit_component( eid, "AnimalAIComponent", function(comp,vars)
		local damage_min = tonumber(ComponentGetValue( comp, "attack_melee_damage_min"))
		local damage_max = tonumber(ComponentGetValue( comp, "attack_melee_damage_max"))
		local damage_dash = tonumber(ComponentGetValue( comp, "attack_dash_damage"))
		
		vars.attack_melee_damage_min = damage_min + extra_damage
		vars.attack_melee_damage_max = damage_max + extra_damage
		vars.attack_dash_damage = damage_dash + extra_damage
	end)
end
