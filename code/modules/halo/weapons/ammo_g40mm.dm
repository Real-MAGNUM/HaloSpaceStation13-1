
//40mm grenade
/obj/item/ammo_casing/g40mm
	name = "40mm grenade (Practice)"
	desc = "A 40mm grenade shell. This one appears to be a Practice round."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "40mm_shell"
	spent_icon = "40mm_shell-spent"
	caliber = "g40mm"
	projectile_type = /obj/item/projectile/bullet/g40mm
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	matter = list(DEFAULT_WALL_MATERIAL = 500)

/obj/item/ammo_casing/g40mm/he
	name = "40mm grenade (HE)"
	desc = "A 40mm grenade shell. This one appears to be a High Explosive round. Warning!: Arming range 2."
	icon_state = "40mm_shell_HE"
	projectile_type = /obj/item/projectile/bullet/g40mm/he

/obj/item/ammo_casing/g40mm/frag
	name = "40mm grenade (Fragmentation)"
	desc = "A 40mm grenade shell. This one appears to be a Fragmentation round. Warning!: Arming range 2."
	icon_state = "40mm_shell_frag"
	projectile_type = /obj/item/projectile/bullet/g40mm/frag

/obj/item/ammo_casing/g40mm/smoke
	name = "40mm grenade (Smoke)"
	desc = "A 40mm grenade shell. This one appears to be a Smoke round."
	icon_state = "40mm_shell_smoke"
	projectile_type = /obj/item/projectile/bullet/g40mm/smoke

/obj/item/ammo_casing/g40mm/illumination
	name = "40mm grenade (Illumination)"
	desc = "A 40mm grenade shell. This one appears to be an Illumination round."
	icon_state = "40mm_shell_illumination"
	projectile_type = /obj/item/projectile/bullet/g40mm/illumination

/obj/item/projectile/bullet/g40mm
	name = "shell"
	fire_sound = 'code/modules/halo/sounds/Grenade 1.ogg'
	damage = 60 //it's less dangerous than a shotgun slug with its low AP, but 40mm grenades do obliterate unarmoured flesh
	armor_penetration = 5
	step_delay = 0.9
	var/arming_range = 0

/obj/item/projectile/bullet/g40mm/on_impact(var/atom/target)
	if(arming_range && get_dist(starting,loc) <= arming_range)
		return 0
	return 1

/obj/item/projectile/bullet/g40mm/he
	damage = 20 //explosive is lower mass than a chunk of practice ammo
	armor_penetration = 0 //likewise no room for AP in a regular old bomb
	shield_damage = 100 //less than half minor shields but the explosion will put it pretty low
	check_armour = "bomb"
	arming_range = 2

/obj/item/projectile/bullet/g40mm/he/on_impact(var/atom/target)
	. = ..()
	if (.)
		explosion(get_turf(target), -1, 0, 2, 3, 1) //adminlog for testing purposes
		qdel(src)

/obj/item/projectile/bullet/g40mm/frag
	damage = 5 //this thing will be releasing a load of shrapnel anyway so damage should be appropriately low
	armor_penetration = 0
	arming_range = 2

/obj/item/projectile/bullet/g40mm/frag/on_impact(var/atom/target)
	. = ..()
	if (.)
		playsound(src.loc, 'sound/effects/explosion1.ogg', 30, 1, -3)
		src.fragmentate(get_turf(loc), 50, 7, list(/obj/item/projectile/bullet/pellet/fragment = 1)) //Loc not target, we don't explode *in* them we explode *on* them
		qdel(src)

/obj/item/projectile/bullet/g40mm/smoke
	damage = 30
	armor_penetration = 5
	arming_range = 1

/obj/item/projectile/bullet/g40mm/smoke/on_impact(var/atom/target)
	var/datum/effect/effect/system/smoke_spread/bad/smoke
	smoke = new  /datum/effect/effect/system/smoke_spread/bad()
	smoke.attach(src)
	playsound(src.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
	smoke.set_up(10, 0, usr.loc)
	spawn(0)
	smoke.start()
	sleep(1)
	smoke.start()
	..()

/obj/item/projectile/bullet/g40mm/illumination
	damage = 30
	armor_penetration = 5

//this is empty for now
/obj/item/projectile/bullet/g40mm/illumination/on_impact(var/atom/target)
	. = ..()
