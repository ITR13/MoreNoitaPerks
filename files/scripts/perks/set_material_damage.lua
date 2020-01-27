dofile_once( "data/scripts/lib/utilities.lua" )
dofile_once( "data/scripts/lib/coroutines.lua" )

function zip(...)
  local arrays, ans = {...}, {}
  local index = 0
  return
    function()
      index = index + 1
      for i,t in ipairs(arrays) do
        if type(t) == 'function' then ans[i] = t() else ans[i] = t[index] end
        if ans[i] == nil then return end
      end
      return unpack(ans)
    end
end

function quick_polymorph( entity )
	EntityAddComponent( entity, "LuaComponent", { 
		script_source_file="mods/perks_by_itr/files/scripts/perks/quick_polymorph.lua",
		execute_every_n_frame=1,
		execute_times=1,
		remove_after_executed=1,
	} )
end


function set_material_damage( entity, rebind_table )
	edit_component( entity, "DamageModelComponent", function(comp,vars)
		names = ComponentGetValue( comp, "materials_that_damage", "")
		values = ComponentGetValue( comp, "materials_how_much_damage", "" )

		new_values = ""

		for name, value in zip(string.gmatch(names, '([^,]+)'), string.gmatch(values, '([^,]+)')) do
			if rebind_table[name] ~= nil then
				value = tostring(rebind_table[name])
				rebind_table[name] = nil
			end
			if new_values then
				new_values = new_values..","..value
			else
				new_values = value
			end
		end

		for name, value in pairs(rebind_table) do
			if new_values then
				new_values = new_values..","..value
			else
				new_values = value
			end
			if names then
				names = names..","..name
			else
				names = name
			end
		end
		ComponentSetValue( comp, "materials_that_damage", names )
		ComponentSetValue( comp, "materials_how_much_damage", new_values )
	end)
	
	quick_polymorph(entity)
end

function get_material_damage(entity, material_name)
	found_value = nil
	edit_component( entity, "DamageModelComponent", function(comp,vars)
		names = ComponentGetValue( comp, "materials_that_damage", "")
		values = ComponentGetValue( comp, "materials_how_much_damage", "" )
		for name, value in zip(string.gmatch(names, '([^,]+)'), string.gmatch(values, '([^,]+)')) do
			if name == material_name then
				found_value = value
				break
			end
		end
	end)
	return found_value
end

function multiply_material_damage(entity, factor)
	edit_component( entity, "DamageModelComponent", function(comp,vars)
		names = ComponentGetValue( comp, "materials_that_damage", "")
		values = ComponentGetValue( comp, "materials_how_much_damage", "" )

		new_value = tostring(new_value)
		new_values = ""
		material_found = false

		for name, value in zip(string.gmatch(names, '([^,]+)'), string.gmatch(values, '([^,]+)')) do
			value = tostring(tonumber(value) * factor)
			if new_values then
				new_values = new_values..","..value
			else
				new_values = value
			end
		end

		ComponentSetValue( comp, "materials_how_much_damage", new_values )
	end)
	quick_polymorph( entity )
end
