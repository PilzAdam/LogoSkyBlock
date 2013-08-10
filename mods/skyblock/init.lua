
minetest.register_on_mapgen_init(function(params)
	if params.mgname ~= "singlenode" then
		minetest.log("error", "Logo SkyBlock requires mapgen singlenode")
	end
end)

minetest.register_on_respawnplayer(function(player)
	player:setpos({x=0, y=0, z=0})
	return true
end)

minetest.register_node("skyblock:air", {
	description = "Fake Air",
	drawtype = "airlike",
	sunlight_propagates = true,
	paramtype = "light",
	drop = "",
	walkable = false,
	pointable = false,
	digable = false,
	buildable_to = true,
})

default.cool_lava_flowing = function(pos)
	if math.random(100) == 1 then
		minetest.set_node(pos, {name="default:stone_with_iron"})
	else
		minetest.set_node(pos, {name="default:stone"})
	end
	minetest.sound_play("default_cool_lava", {pos = pos,  gain = 0.25})
end

minetest.register_craft({
	type = "cooking",
	output = "default:coal_lump",
	recipe = "default:tree",
})

minetest.register_chatcommand("spawn", {
	params = "<none>",
	description = "Respawn",
	privs = {},
	func = function(name, param)
		local player = minetest.get_player_by_name(name)
		player:setpos({x=0, y=0, z=0})
	end,
})

minetest.register_on_generated(function(minp, maxp, blockseed)
	if minp.x == -32 and minp.y == -32 and minp.z == -32 and
		maxp.x == 47 and maxp.y == 47 and maxp.z == 47 then
		minetest.place_schematic({x=-5, y=-5, z=-6}, minetest.get_modpath("skyblock").."/schematics/skyblock.mts")
		
		local chestpos = {
			x = math.random(-3,  3),
			y = math.random(-5, -3),
			z = math.random(-2,  2),
		}
		-- Dont fly in air
		chestpos.y = chestpos.y - 1
		while minetest.get_node(chestpos).name == "air" do
			chestpos.y = chestpos.y - 1
		end
		chestpos.y = chestpos.y + 1
		
		minetest.set_node(chestpos, {name="default:chest", param2=math.random(0,3)})
		
		local meta = minetest.get_meta(chestpos)
		local inv = meta:get_inventory()
		inv:add_item("main", "bucket:bucket_lava")
	end
end)
