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


/obj/item/plate_shard/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			to_chat(M, "<span class='danger'>You step on \the [src]!</span>")
			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
						return
					affecting.take_damage(5, 0)
					H.updatehealth()
					if(affecting.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return


//shattered plate bits

/obj/effect/decal/cleanable/shatteredplate
	name = "small plate shards"
	desc = "Looks like we won't be having dinner."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "shattered_plate"

//TO DO: make it so if you have no shoes on and go in walk mode you don't step on the little bits

/obj/effect/decal/cleanable/shatteredplate/Crossed(AM as mob|obj)
	..()
	if(isliving(AM))
		var/mob/M = AM

		if(M.buckled) //wheelchairs, office chairs, rollerbeds
			return

		playsound(src.loc, 'sound/effects/glass_step.ogg', 50, 1)
		if(ishuman(M))
			var/mob/living/carbon/human/H = M

			if(H.species.siemens_coefficient<0.5 || (H.species.species_flags & (SPECIES_FLAG_NO_EMBED|SPECIES_FLAG_NO_MINOR_CUT))) //Thick skin.
				return

			if( H.shoes || ( H.wear_suit && (H.wear_suit.body_parts_covered & FEET) ) )
				return

			to_chat(M, "<span class='danger'>You step on \the [src]!</span>")
			var/list/check = list(BP_L_FOOT, BP_R_FOOT)
			while(check.len)
				var/picked = pick(check)
				var/obj/item/organ/external/affecting = H.get_organ(picked)
				if(affecting)
					if(affecting.robotic >= ORGAN_ROBOT)
						return
					affecting.take_damage(5, 0)
					H.updatehealth()
					if(affecting.can_feel_pain())
						H.Weaken(3)
					return
				check -= picked
			return
