function OnPlayerSpawned( player_entity )
	local x, y = EntityGetTransform( player_entity )
	-- EntityLoad("data/entities/_debug/spawn_perk.xml", x, y )
end

FILE_ROOT = "mods/perks_by_itr/files/"

ModLuaFileAppend( "data/scripts/perks/perk_list.lua", FILE_ROOT.."perks.lua" )
