-- subgroups raw-material, production-machine, gun

-- ===== предметы =====

data:extend({
   {type = "item",
	name = "artillery-shell",
	icon = "__Artillery_v14_Mod__/media/artillery-shell.png",
	flags = {"goes-to-main-inventory"},
	subgroup = "ammo",
	order = "u",
	stack_size= 10, },
})

data:extend({
   {type = "item",
	name = "artillery-targeting-remote",
	icon = "__Artillery_v14_Mod__/media/artillery-targeting-remote.png",
	flags = {"goes-to-quickbar"},
	subgroup = "equipment",
	order = "ya",
	place_result = "artillery-targeting-remote",
	stack_size= 1, },
})

data:extend({
   {type = "item",
	name = "artillery-targeting-checker",
	icon = "__Artillery_v14_Mod__/media/artillery-targeting-checker.png",
	flags = {"goes-to-quickbar"},
	subgroup = "equipment",
	order = "yb",
	place_result = "artillery-targeting-checker",
	stack_size= 1, },
})
-- ===== Объекты =====
-- временные объекты для триггера события
data:extend({
  {
    type = "simple-entity",
    name = "artillery-targeting-remote",
    icon = "__Artillery_v14_Mod__/media/artillery-targeting-remote.png",
	max_health = 1,
	render_layer = "air-object",
	picture = { layers = { { filename = "__Artillery_v14_Mod__/media/artillery-targeting-remote.png", width=100, height=100, }, }, }
  },
})

data:extend({
  {
    type = "simple-entity",
    name = "artillery-targeting-checker",
    icon = "__Artillery_v14_Mod__/media/artillery-targeting-checker.png",
	max_health = 1,
	render_layer = "air-object",
	picture = { layers = { { filename = "__Artillery_v14_Mod__/media/artillery-targeting-checker.png", width=100, height=100, }, }, }
  },
})
-- снаряд
data:extend({
  {
	type = "projectile",
	name = "art-projectile",
	flags = {"not-on-map"},
	acceleration = 0.005,
	action =
	{
	  {
		type = "area",
		perimeter = 4,
		action_delivery =
		{ type = "instant",
		  target_effects =
		  {
			{ type = "damage", damage = {amount = 200, type = "explosion"} },
			{ type = "damage", damage = {amount = 100, type = "physical"} },
		  }
		}
	  },
	  {
		type = "area",
		perimeter = 6,
		action_delivery =
		{ type = "instant",
		  target_effects =
		  {
			{ type = "damage", damage = {amount = 50, type = "explosion"} },
			{ type = "damage", damage = {amount = 50, type = "physical"} },
		  }
		}
	  },
	  {
		type = "area",
		perimeter = 8,
		action_delivery =
		{ type = "instant",
		  target_effects =
		  {
			{ type = "damage", damage = {amount = 25, type = "physical"} },
		  }
		}
	  },
	},
	animation =
    {
      filename = "__Artillery_v14_Mod__/media/artillery-targeting-remote.png",
      frame_count = 1,
      width = 24,
      height = 24,
      priority = "low"
    },
  },
})
-- ===== Объект арты =====

data:extend({
  {
    type = "item",
    name = "artillery-turret",
    icon = "__Artillery_v14_Mod__/media/artillery-turret.png",
    flags = {"goes-to-quickbar"},
    subgroup = "defensive-structure",
    order = "u",
    place_result = "artillery-turret",
    stack_size = 10
  }
})

data:extend({
  {
    type = "container",
    name = "artillery-turret",
    icon = "__Artillery_v14_Mod__/media/artillery-turret.png",
	flags = {"placeable-player", "player-creation"},
	minable = {mining_time = 1, result = "artillery-turret"},
	inventory_size = 1,
	is_military_target=true,
	max_health = 2000,
	collision_box = {{-1.45, -1.45}, {1.45, 1.45}},
    selection_box = {{-1.5, -1.5}, {1.5, 1.5}},
	render_layer = "object",
	resistances =
    { { type = "fire", decrease = 15, percent = 50 },
      { type = "physical", decrease = 15, percent = 30 },
      { type = "impact", decrease = 50, percent = 50 },
      { type = "explosion", decrease = 15, percent = 30},
      { type = "acid", decrease = 10, percent = 20 } },
	picture =
    {
      layers =
      {
        {
          filename = "__Artillery_v14_Mod__/media/artillery-turret-sprite.png",
          width = 120,
          height = 165,
		  shift = {0.3, -1.1}
        },
      }
    },
  }
})
-- ===== Теха =====

data:extend({ 
  {
	type = "technology",
	name = "artillery-tech",
	icon = "__Artillery_v14_Mod__/media/artillery-turret-sprite.png",
	icon_size = 165,
	effects =
	{
	  { type = "unlock-recipe", recipe = "artillery-turret" },
	  { type = "unlock-recipe", recipe = "artillery-shell" },
	  { type = "unlock-recipe", recipe = "artillery-targeting-remote" },
	  { type = "unlock-recipe", recipe = "artillery-targeting-checker" },
	},
	prerequisites = {"military-4", "tanks"},
	unit={
		count = 200,
		ingredients = { {"science-pack-1", 1}, {"science-pack-2", 2}, {"science-pack-3", 1}, {"alien-science-pack", 1}, },
		time = 30, },
	order = "e-c-d"
  }
})

-- ===== рецепты =====

data:extend({
	{type = "recipe", energy_required=40,
	 name = "artillery-turret",
	 ingredients ={{"advanced-circuit",20},{"concrete",60},{"iron-gear-wheel",40},{"steel-plate",60}},
	 result="artillery-turret", enabled=false, },
})

data:extend({
	{type = "recipe", energy_required=15,
	 name = "artillery-shell",
	 ingredients ={{"explosive-cannon-shell",4},{"explosives",8},{"radar",1}},
	 result="artillery-shell", enabled=false, },
})

data:extend({
	{type = "recipe",
	 name = "artillery-targeting-remote",
	 ingredients ={{"processing-unit",1},{"radar",1}},
	 result="artillery-targeting-remote", enabled=false, },
})

data:extend({
	{type = "recipe",
	 name = "artillery-targeting-checker",
	 ingredients ={{"processing-unit",1},{"radar",1}},
	 result="artillery-targeting-checker", enabled=false, },
})