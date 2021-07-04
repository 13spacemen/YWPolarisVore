// These come with shuttle functionality. Need to be assigned a (unique) shuttle datum name.
// Mapping location doesn't matter, so long as on a map loaded at the same time as the shuttle areas.
// Multiz shuttles currently not supported. Non-autodock shuttles currently not supported.

/obj/effect/overmap/visitable/ship/landable
	var/shuttle                                         // Name of associated shuttle. Must be autodock.
	var/obj/effect/shuttle_landmark/ship/landmark       // Record our open space landmark for easy reference.
	var/multiz = 0										// Index of multi-z levels, starts at 0
	var/status = SHIP_STATUS_LANDED
	icon_state = "shuttle_nosprite"

/obj/effect/overmap/visitable/ship/landable/Destroy()
	GLOB.shuttle_pre_move_event.unregister(SSshuttles.shuttles[shuttle], src)
	GLOB.shuttle_moved_event.unregister(SSshuttles.shuttles[shuttle], src)
	return ..()

/obj/effect/overmap/visitable/ship/landable/can_burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/burn()
	if(status != SHIP_STATUS_OVERMAP)
		return 0
	return ..()

/obj/effect/overmap/visitable/ship/landable/check_ownership(obj/object)
	var/datum/shuttle/shuttle_datum = SSshuttles.shuttles[shuttle]
	if(!shuttle_datum)
		return
	var/list/areas = shuttle_datum.find_childfree_areas()
	if(get_area(object) in areas)
		return 1

// We autobuild our z levels.
/obj/effect/overmap/visitable/ship/landable/find_z_levels()
	src.landmark = new(null, shuttle) // Create in nullspace since we lazy-create overmap z
	add_landmark(landmark, shuttle)

/obj/effect/overmap/visitable/ship/landable/proc/setup_overmap_location()
	if(LAZYLEN(map_z))
		return // We're already set up!
	for(var/i = 0 to multiz)
		world.increment_max_z()
		map_z += world.maxz

	var/turf/center_loc = locate(round(world.maxx/2), round(world.maxy/2), world.maxz)
	landmark.forceMove(center_loc)

	var/visitor_dir = fore_dir
	for(var/landmark_name in list("FORE", "PORT", "AFT", "STARBOARD"))
		var/turf/visitor_turf = get_ranged_target_turf(center_loc, visitor_dir, round(min(world.maxx/4, world.maxy/4)))
		var/obj/effect/shuttle_landmark/visiting_shuttle/visitor_landmark = new (visitor_turf, landmark, landmark_name)
		add_landmark(visitor_landmark)
		visitor_dir = turn(visitor_dir, 90)

	if(multiz)
		new /obj/effect/landmark/map_data(center_loc, (multiz + 1))
	register_z_levels()
	testing("Setup overmap location for \"[name]\" containing Z [english_list(map_z)]")

/obj/effect/overmap/visitable/ship/landable/get_areas()
	var/datum/shuttle/shuttle_datum = SSshuttles.shuttles[shuttle]
	if(!shuttle_datum)
		return list()
	return shuttle_datum.find_childfree_areas()

/obj/effect/overmap/visitable/ship/landable/populate_sector_objects()
	..()
	var/datum/shuttle/shuttle_datum = SSshuttles.shuttles[shuttle]
	if(istype(shuttle_datum,/datum/shuttle/autodock/overmap))
		var/datum/shuttle/autodock/overmap/oms = shuttle_datum
		oms.myship = src
	GLOB.shuttle_pre_move_event.register(shuttle_datum, src, .proc/pre_shuttle_jump)
	GLOB.shuttle_moved_event.register(shuttle_datum, src, .proc/on_shuttle_jump)
	on_landing(landmark, shuttle_datum.current_location) // We "land" at round start to properly place ourselves on the overmap.


//
// Center Landmark
//

/obj/effect/shuttle_landmark/ship
	name = "Open Space"
	landmark_tag = "ship"
	flags = SLANDMARK_FLAG_ZERO_G // *Not* AUTOSET, these must be world.turf and world.area for lazy loading to work.
	var/shuttle_name
	var/list/visitors // landmark -> visiting shuttle stationed there

/obj/effect/shuttle_landmark/ship/Initialize(mapload, shuttle_name)
	landmark_tag += "_[shuttle_name]"
	src.shuttle_name = shuttle_name
	. = ..()
	base_turf = world.turf

/obj/effect/shuttle_landmark/ship/Destroy()
	var/obj/effect/overmap/visitable/ship/landable/ship = get_overmap_sector(z)
	if(istype(ship) && ship.landmark == src)
		ship.landmark = null
	. = ..()

/obj/effect/shuttle_landmark/ship/is_valid(datum/shuttle/shuttle)
	return (isnull(loc) || ..()) // If it doesn't exist yet, its clear

/obj/effect/shuttle_landmark/ship/create_warning_effect(var/datum/shuttle/shuttle)
	if(isnull(loc))
		return
	..()

/obj/effect/shuttle_landmark/ship/cannot_depart(datum/shuttle/shuttle)
	if(LAZYLEN(visitors))
		return "Grappled by other shuttle; cannot manouver."

//
// Visitor Landmark
//

/obj/effect/shuttle_landmark/visiting_shuttle
	flags = SLANDMARK_FLAG_AUTOSET | SLANDMARK_FLAG_ZERO_G
	var/obj/effect/shuttle_landmark/ship/core_landmark

/obj/effect/shuttle_landmark/visiting_shuttle/Initialize(mapload, obj/effect/shuttle_landmark/ship/master, _name)
	core_landmark = master
	name = _name
	landmark_tag = master.shuttle_name + _name
	GLOB.destroyed_event.register(master, src, /datum/proc/qdel_self)
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/Destroy()
	GLOB.destroyed_event.unregister(core_landmark, src)
	LAZYREMOVE(core_landmark.visitors, src)
	core_landmark = null
	. = ..()

/obj/effect/shuttle_landmark/visiting_shuttle/is_valid(datum/shuttle/shuttle)
	. = ..()
	if(!.)
		return
	var/datum/shuttle/boss_shuttle = SSshuttles.shuttles[core_landmark.shuttle_name]
	if(boss_shuttle.current_location != core_landmark)
		return FALSE // Only available when our governing shuttle is in space.
	if(shuttle == boss_shuttle) // Boss shuttle only lands on main landmark
		return FALSE

/obj/effect/shuttle_landmark/visiting_shuttle/shuttle_arrived(datum/shuttle/shuttle)
	LAZYSET(core_landmark.visitors, src, shuttle)
	GLOB.shuttle_moved_event.register(shuttle, src, .proc/shuttle_left)

/obj/effect/shuttle_landmark/visiting_shuttle/proc/shuttle_left(datum/shuttle/shuttle, obj/effect/shuttle_landmark/old_landmark, obj/effect/shuttle_landmark/new_landmark)
	if(old_landmark == src)
		GLOB.shuttle_moved_event.unregister(shuttle, src)
		LAZYREMOVE(core_landmark.visitors, src)

//
// More ship procs
//

/obj/effect/overmap/visitable/ship/landable/proc/pre_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttles.shuttles[shuttle])
		return
	if(into == landmark)
		setup_overmap_location() // They're coming boys, better actually exist!
		GLOB.shuttle_pre_move_event.unregister(SSshuttles.shuttles[shuttle], src)

/obj/effect/overmap/visitable/ship/landable/proc/on_shuttle_jump(datum/shuttle/given_shuttle, obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(given_shuttle != SSshuttles.shuttles[shuttle])
		return
	var/datum/shuttle/autodock/auto = given_shuttle
	if(into == auto.landmark_transition)
		status = SHIP_STATUS_TRANSIT
		on_takeoff(from, into)
		return
	if(into == landmark)
		status = SHIP_STATUS_OVERMAP
		on_takeoff(from, into)
		return
	status = SHIP_STATUS_LANDED
	on_landing(from, into)

/obj/effect/overmap/visitable/ship/landable/proc/on_landing(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	var/obj/effect/overmap/visitable/target = get_overmap_sector(get_z(into))
	var/datum/shuttle/shuttle_datum = SSshuttles.shuttles[shuttle]
	if(into.landmark_tag == shuttle_datum.motherdock) // If our motherdock is a landable ship, it won't be found properly here so we need to find it manually.
		for(var/obj/effect/overmap/visitable/ship/landable/landable in SSshuttles.ships)
			if(landable.shuttle == shuttle_datum.mothershuttle)
				target = landable
				break
	if(!target || target == src)
		return
	forceMove(target)
	halt()

/obj/effect/overmap/visitable/ship/landable/proc/on_takeoff(obj/effect/shuttle_landmark/from, obj/effect/shuttle_landmark/into)
	if(!isturf(loc))
		forceMove(get_turf(loc))
		unhalt()

/obj/effect/overmap/visitable/ship/landable/get_landed_info()
	switch(status)
		if(SHIP_STATUS_LANDED)
			var/obj/effect/overmap/visitable/location = loc
			if(istype(loc, /obj/effect/overmap/visitable/sector))
				return "Landed on \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			if(istype(loc, /obj/effect/overmap/visitable/ship))
				return "Docked with \the [location.name]. Use secondary thrust to get clear before activating primary engines."
			return "Docked with an unknown object."
		if(SHIP_STATUS_TRANSIT)
			return "Maneuvering under secondary thrust."
		if(SHIP_STATUS_OVERMAP)
			return "In open space."