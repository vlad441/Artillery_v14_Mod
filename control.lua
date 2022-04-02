local art_distance = 300
local art_mindistance = 32
local art_cooldown = 180
local old_tick = {0,0}
local artfire={status=0,delay=0,turrets={},player={},firepos={}}

script.on_event(defines.events.on_tick, function(event)
	if artfire.status>0 then
		if artfire.status==1 then artfire.delay=artfire.delay-1 if artfire.delay<=0 then artfire.status=2 end return end 
		if artfire.delay>0 then artfire.delay=artfire.delay-1 return end artfire.delay = 40
		if #artfire.turrets>0 then
			table.remove(artfire.turrets, 1)
			ArtFire(artfire.player, artfire.firepos)
		else artfire.status=0 end
	end
end)
-- == ==
script.on_event(defines.events.on_put_item, function(event)
	local player = game.players[event.player_index]
	if player.cursor_stack.valid_for_read and player.cursor_stack.name == "artillery-targeting-remote" then
		ArtPrepare(player, event.position, event.tick);
	end
	if player.cursor_stack.valid_for_read and player.cursor_stack.name == "artillery-targeting-checker" then
		ArtCheck(player, event.position);
	end
end)

script.on_event(defines.events.on_built_entity, function(event)
	local entity = event.created_entity
	if entity.name == "artillery-targeting-remote" then entity.destroy()
		game.players[event.player_index].cursor_stack.set_stack({name = "artillery-targeting-remote", count = 1}) return end
	if entity.name == "artillery-targeting-checker" then entity.destroy()
		game.players[event.player_index].cursor_stack.set_stack({name = "artillery-targeting-checker", count = 1}) return end
end)

function ArtCheck(player, fireposition)
	local artobjs = player.surface.find_entities_filtered{area={{fireposition.x-art_distance, fireposition.y-art_distance},{fireposition.x+art_distance,fireposition.y+art_distance}},name="artillery-turret"}
	local artlist={0,0,0} local dist={0,0,0} local shells=0
	
	for key,value in pairs(artobjs) do
		local pifagordist = pifagor(fireposition.x, fireposition.y, artobjs[key].position.x, artobjs[key].position.y)
		if pifagordist <= art_distance then
			if pifagordist >= art_mindistance then artlist[2]=artlist[2]+1 dist[3]=pifagordist 
				local shellcnt=artobjs[key].get_inventory(defines.inventory.chest).get_item_count("artillery-shell")
				if shellcnt >=1 then artlist[1]=artlist[1]+1 dist[1]=pifagordist shells=shells+shellcnt end
			else artlist[3]=artlist[3]+1 dist[2]=pifagordist end
		end
	end if artlist[1]<=0 then dist[1]=dist[2] if artlist[3]<=0 then dist[1]=dist[3] end end 
	player.print("[ArtCheck] ("..tostring(fireposition.x)..", "..tostring(fireposition.y)..") Готовы: "..tostring(artlist[1]).."/"..tostring(artlist[2]).."("..tostring(artlist[3])..") (sh: "..tostring(shells)..", dist: "..tostring(math.floor(dist[1]*100)/100)..")")
end

function ArtPrepare(player, fireposition, evtick)
	if old_tick[2]+30 > evtick then return end old_tick[2]=evtick
	if old_tick[1]+art_cooldown > evtick then player.print("[Artillery] Перезарядка: "..tostring(old_tick[1]+art_cooldown-evtick)) return end
	if #artfire.turrets>0 then player.print("[Artillery] Огонь еще не завершен") return end
	
	local artobjs = player.surface.find_entities_filtered{area={{fireposition.x-art_distance, fireposition.y-art_distance},{fireposition.x+art_distance,fireposition.y+art_distance}},name="artillery-turret"}
	local artready = {} local artsrange=0
	for key,value in pairs(artobjs) do
		local pifagordist = pifagor(fireposition.x, fireposition.y, artobjs[key].position.x, artobjs[key].position.y)
		if pifagordist <= art_distance and pifagordist >= art_mindistance then artsrange=artsrange+1 
			if artobjs[key].get_inventory(defines.inventory.chest).get_item_count("artillery-shell")>=1 then
				table.insert(artready, artobjs[key])
				artobjs[key].get_inventory(defines.inventory.chest).remove({name="artillery-shell"})
			end end
	end if #artready<=0 then if artsrange<=0 then player.print("[Artillery] Вне зоны поражения") else player.print("[Artillery] Нет боеприпасов") end return end 
	artfire.turrets=artready artfire.player=player artfire.firepos=fireposition artfire.status=1 artfire.delay=60 old_tick[1]=evtick
end

function ArtFire(player, fireposition)
	player.surface.create_entity{name="big-explosion", position=fireposition, force="neutral"}
	local ArtTarget = player.surface.create_entity{name="artillery-targeting-remote", position=fireposition, force="neutral"}
	player.surface.create_entity{name="art-projectile", position=fireposition, target=ArtTarget, force="neutral", speed=0}
	ArtTarget.destroy() end

function pifagor(x1, y1 , x2, y2) return math.sqrt(math.pow(x2-x1,2)+math.pow(y2-y1,2)); end

--/c game.player.force.reset() - reset all
--/c game.player.force.enable_all_recipes() - Открыть все рецепты
--/c game.player.force.technologies[' '].researched=true - Исследовать теху