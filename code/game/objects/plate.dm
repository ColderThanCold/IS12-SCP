//sharpness and stuff like that might need some changes

var/shard_number = 4

/obj/item/plate
	name = "plate"
	desc = "A nice way to secure your food from microscopic ants."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "plate"
	drop_sound = 'sound/items/plate_drop.ogg'
	table_pickup_sound = 'sound/items/plate_pickup.ogg'
	table_place_sound = 'sound/items/plate_place.ogg'
	w_class = ITEM_SIZE_SMALL


/obj/item/plate/throw_impact(atom/hit_atom)
	..()
	sharpness = 10
	force = 5
	if(istype(hit_atom,/turf/simulated/floor))
		playsound(src, "shatter", 70, 1)
		Destroy()
		for(var/iteration in 1 to shard_number)
			new/obj/item/plate_shard(hit_atom)
				randpixel = 10



//plate shards

/obj/item/plate_shard/New()
	..()
	icon_state = pick("plateshard1","plateshard2","plateshard3",)


/obj/item/plate_shard
	name = "plate shard"
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "plateshard1"
	hitsound = 'sound/weapons/bladeslice.ogg'
	w_class = ITEM_SIZE_TINY
	randpixel = 8
	force = 2
	throwforce = 5
	sharpness = 5



/obj/item/plate_shard/throw_impact(atom/hit_atom)
	..()
	if(istype(hit_atom,/mob/living))
		playsound(src, "sound/weapons/bladeslice.ogg", 70, 1)
