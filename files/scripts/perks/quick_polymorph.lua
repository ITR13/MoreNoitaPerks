dofile_once( "data/scripts/lib/coroutines.lua" )
dofile_once( "data/scripts/lib/utilities.lua" )


KEY = "LAST_QUICK_POLYMORPHED"

local last_quick_polymorph = tonumber(GlobalsGetValue(KEY, 0))
local frame_now = GameGetFrameNum()

if last_quick_polymorph + 5 < frame_now then
	local entity = GetUpdatedEntityID()
	local polymorph = GetGameEffectLoadTo( entity, "POLYMORPH", true );
	ComponentSetValue( polymorph, "frames", 1 );
	ComponentSetValue( polymorph, "polymorph_target", "data/entities/animals/sheep.xml" )
	GlobalsSetValue(KEY, tostring(frame_now))
end