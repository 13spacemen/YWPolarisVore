//Atmosphere properties
#define CRYOGAIA_ONE_ATMOSPHERE	82.4 //kPa
#define CRYOGAIA_AVG_TEMP	215 //kelvin

#define CRYOGAIA_PER_N2		0.16 //percent
#define CRYOGAIA_PER_O2		0.72
#define CRYOGAIA_PER_N2O	0.00 //Currently no capacity to 'start' a turf with this. See turf.dm
#define CRYOGAIA_PER_CO2	0.12
#define CRYOGAIA_PER_PHORON	0.00

//Math only beyond this point
#define CRYOGAIA_MOL_PER_TURF	(CRYOGAIA_ONE_ATMOSPHERE*CELL_VOLUME/(CRYOGAIA_AVG_TEMP*R_IDEAL_GAS_EQUATION))
#define CRYOGAIA_MOL_N2			(CRYOGAIA_MOL_PER_TURF * CRYOGAIA_PER_N2)
#define CRYOGAIA_MOL_O2			(CRYOGAIA_MOL_PER_TURF * CRYOGAIA_PER_O2)
#define CRYOGAIA_MOL_N2O		(CRYOGAIA_MOL_PER_TURF * CRYOGAIA_PER_N2O)
#define CRYOGAIA_MOL_CO2		(CRYOGAIA_MOL_PER_TURF * CRYOGAIA_PER_CO2)
#define CRYOGAIA_MOL_PHORON		(CRYOGAIA_MOL_PER_TURF * CRYOGAIA_PER_PHORON)

//Turfmakers
#define CRYOGAIA_SET_ATMOS	nitrogen=CRYOGAIA_MOL_N2;oxygen=CRYOGAIA_MOL_O2;carbon_dioxide=CRYOGAIA_MOL_CO2;phoron=CRYOGAIA_MOL_PHORON;temperature=CRYOGAIA_AVG_TEMP
#define CRYOGAIA_TURF_CREATE(x)	x/cryogaiab/nitrogen=CRYOGAIA_MOL_N2;x/cryogaia/oxygen=CRYOGAIA_MOL_O2;x/cryogaia/carbon_dioxide=CRYOGAIA_MOL_CO2;x/cryogaia/phoron=CRYOGAIA_MOL_PHORON;x/cryogaia/temperature=CRYOGAIA_AVG_TEMP;x/cryogaia/outdoors=TRUE;x/cryogaia/update_graphic(list/graphic_add = null, list/graphic_remove = null) return 0
#define CRYOGAIA_TURF_CREATE_UN(x)	x/cryogaia/nitrogen=CRYOGAIA_MOL_N2;x/cryogaia/oxygen=CRYOGAIA_MOL_O2;x/cryogaia/carbon_dioxide=CRYOGAIA_MOL_CO2;x/cryogaia/phoron=CRYOGAIA_MOL_PHORON;x/cryogaia/temperature=CRYOGAIA_AVG_TEMP

//Normal YW map defs
#define Z_LEVEL_CRYOGAIA_MAIN				1
#define Z_LEVEL_CRYOGAIA_LOWER				2
#define Z_LEVEL_CRYOGAIA_MINE				3
#define Z_LEVEL_CENTCOM						4

/datum/map/cryogaia
	name = "Cryogaia"
	full_name = "NSB Cryogaia"
	path = "cryogaia"

	zlevel_datum_type = /datum/map_z_level/cryogaia

	lobby_icon = 'icons/misc/title_yw2.dmi'
	lobby_screens = list("cryogaia")
	id_hud_icons = 'icons/mob/hud_jobs_vr.dmi'

/*	holomap_smoosh = list(list(
		Z_LEVEL_SURFACE_LOW,
		Z_LEVEL_SURFACE_MID,
		Z_LEVEL_SURFACE_HIGH,
		Z_LEVEL_SPACE_LOW,
		Z_LEVEL_SPACE_MID,
		Z_LEVEL_SPACE_HIGH)) */

	station_name  = "Cryogaia Outpost"
	station_short = "Yawn Wider"
	dock_name     = "NAS Midgard"
	boss_name     = "Central Command"
	boss_short    = "CentCom"
	company_name  = "NanoTrasen"
	company_short = "NT"
	starsys_name  = "Beta Aquarii"

	shuttle_docked_message = "The scheduled Shuttle to %dock_name% has arrived. It will depart in approximately %ETD%."
	shuttle_leaving_dock = "The Shuttle has left the Outpost. Estimate %ETA% until the tram arrives at %dock_name%."
	shuttle_called_message = "A scheduled crew transfer to %dock_name% is occuring. The tram will be arriving shortly. Those departing should proceed to the shuttle docking station within %ETA%."
	shuttle_recall_message = "The scheduled crew transfer has been cancelled."
	emergency_shuttle_docked_message = "The evacuation shuttle has arrived at the shuttle docking station. You have approximately %ETD% to board the shuttle."
	emergency_shuttle_leaving_dock = "The emergency shuttle has left the station. Estimate %ETA% until the shuttle arrives at %dock_name%."
	emergency_shuttle_called_message = "An emergency evacuation has begun, and an off-schedule shuttle has been called. It will arrive at the shuttle docking station in approximately %ETA%."
	emergency_shuttle_recall_message = "The evacuation shuttle has been recalled."

	station_networks = list(
							NETWORK_CARGO,
							NETWORK_CIVILIAN,
							NETWORK_COMMAND,
							NETWORK_ENGINE,
							NETWORK_ENGINEERING,
							NETWORK_ENGINEERING_OUTPOST,
							NETWORK_DEFAULT,
							NETWORK_MEDICAL,
							NETWORK_MINE,
							NETWORK_NORTHERN_STAR,
							NETWORK_RESEARCH,
							NETWORK_RESEARCH_OUTPOST,
							NETWORK_ROBOTS,
							NETWORK_PRISON,
							NETWORK_SECURITY,
							NETWORK_INTERROGATION
							)

	allowed_spawns = list("Tram Station","Gateway","Cryogenic Storage","Cyborg Storage")
	spawnpoint_died = /datum/spawnpoint/tram
	spawnpoint_left = /datum/spawnpoint/tram
	spawnpoint_stayed = /datum/spawnpoint/cryo

	meteor_strike_areas = list(/area/tether/surfacebase/outside/outside3)

	unit_test_exempt_areas = list(
		/area/tether/surfacebase/outside/outside1,
		/area/vacant/vacant_site,
		/area/vacant/vacant_site/east,
		/area/crew_quarters/sleep/Dorm_1/holo,
		/area/crew_quarters/sleep/Dorm_3/holo,
		/area/crew_quarters/sleep/Dorm_5/holo,
		/area/crew_quarters/sleep/Dorm_7/holo)
	unit_test_exempt_from_atmos = list( //I honestly don't know what the others of these effect, I likely won't touch anything further till I figure out.
		//area/engineering/atmos/intake, // Outside,-Not in use anymore, disabled. -Radiantflash
		/area/rnd/external, //  Outside,
		/area/tether/surfacebase/mining_main/external, // Outside,
		/area/tether/surfacebase/mining_main/airlock, //  Its an airlock,
		/area/tether/surfacebase/emergency_storage/rnd,
		/area/tether/surfacebase/emergency_storage/atrium)

	lateload_z_levels = list(
	//	list("Tether - Misc","Tether - Ships","Tether - Underdark"), //Stock Tether lateload maps. Disabled due to tether being phased out.
		list("Alien Ship - Z1 Ship"),
		list("Desert Planet - Z1 Beach","Desert Planet - Z2 Cave"),
		list("Remmi Aerostat - Z1 Aerostat","Remmi Aerostat - Z2 Surface")
		)

	lateload_single_pick = null //Nothing right now.

/datum/map/tether/perform_map_generation()

	new /datum/random_map/automata/cave_system/no_cracks(null, 1, 1, Z_LEVEL_CRYOGAIA_MINE, world.maxx, world.maxy) // Create the mining Z-level.
	new /datum/random_map/noise/ore(null, 1, 1, Z_LEVEL_CRYOGAIA_MINE, 64, 64)         // Create the mining ore distribution map.

	return 1

// Short range computers see only the six main levels, others can see the surrounding surface levels.
/datum/map/tether/get_map_levels(var/srcz, var/long_range = TRUE)
	if (long_range && (srcz in map_levels))
		return map_levels
	else if (srcz == Z_LEVEL_CENTCOM)
		return list() // Nothing on transit!
	else if (srcz >= Z_LEVEL_CRYOGAIA_MAIN && srcz <= Z_LEVEL_CRYOGAIA_MINE)
		return list(
			Z_LEVEL_CRYOGAIA_MAIN,
			Z_LEVEL_CRYOGAIA_LOWER,
			Z_LEVEL_CRYOGAIA_MINE)
	else
		return ..()

// For making the 6-in-1 holomap, we calculate some offsets ((Disabled because I don't have a clue to how to start making this for Cryogaia))

// We have a bunch of stuff common to the station z levels
/datum/map_z_level/cryogaia
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES
/*	holomap_legend_x = 220
	holomap_legend_y = 160 */

/datum/map_z_level/tether/cryogaia/main
	z = Z_LEVEL_CRYOGAIA_MAIN
	name = "Surface level"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/cryogaia
/*	holomap_offset_x = TETHER_HOLOMAP_MARGIN_X
	holomap_offset_y = TETHER_HOLOMAP_MARGIN_Y + TETHER_MAP_SIZE*0 */

/datum/map_z_level/cryogaia/lower
	z = Z_LEVEL_CRYOGAIA_LOWER
	name = "Subfloor"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/cryogaia

/datum/map_z_level/cryogaia/mining
	z = Z_LEVEL_CRYOGAIA_MINE
	name = "Subterranian depths"
	flags = MAP_LEVEL_STATION|MAP_LEVEL_CONTACT|MAP_LEVEL_PLAYER|MAP_LEVEL_CONSOLES|MAP_LEVEL_SEALED
	base_turf = /turf/simulated/floor/outdoors/rocks/cryogaia


/*
/datum/map_z_level/tether/wilderness
	name = "Wilderness"
	flags = MAP_LEVEL_PLAYER
	var/activated = 0
	var/list/frozen_mobs = list()

/datum/map_z_level/tether/wilderness/proc/activate_mobs()
	if(activated && isemptylist(frozen_mobs))
		return
	activated = 1
	for(var/mob/living/simple_animal/M in frozen_mobs)
		M.life_disabled = 0
		frozen_mobs -= M
	frozen_mobs.Cut()

/datum/map_z_level/tether/wilderness/wild_1
	z = Z_LEVEL_SURFACE_WILDERNESS_1

/datum/map_z_level/tether/wilderness/wild_2
	z = Z_LEVEL_SURFACE_WILDERNESS_2

/datum/map_z_level/tether/wilderness/wild_3
	z = Z_LEVEL_SURFACE_WILDERNESS_3

/datum/map_z_level/tether/wilderness/wild_4
	z = Z_LEVEL_SURFACE_WILDERNESS_4

/datum/map_z_level/tether/wilderness/wild_5
	z = Z_LEVEL_SURFACE_WILDERNESS_5

/datum/map_z_level/tether/wilderness/wild_6
	z = Z_LEVEL_SURFACE_WILDERNESS_6

/datum/map_z_level/tether/wilderness/wild_crash
	z = Z_LEVEL_SURFACE_WILDERNESS_CRASH

/datum/map_z_level/tether/wilderness/wild_ruins
	z = Z_LEVEL_SURFACE_WILDERNESS_RUINS
*/

