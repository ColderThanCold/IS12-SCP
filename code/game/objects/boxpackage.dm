var/closed = TRUE

/obj/item/storage/boxpackage
	name = "cardboard box"
	desc = "A regular cardboard box."
	icon = 'icons/obj/boxpackage.dmi'
	icon_state = "box-tape"

	w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BOX_STORAGE


/obj/item/storage/boxpackage/attack_self(mob/user)
	if(icon_state == "box-tape")
		playsound(src, 'sound/items/poster_ripped.ogg', 100)

		icon_state = "box-notape"
		closed = TRUE
		user.visible_message("<span class='bnotice'>[user] rips off the tape on the box!</pan>")



/obj/item/storage/boxpackage/attackby(obj/item/W, mob/user)
	if(icon_state == "box-notape")
		if(istype(W, /obj/item/tape_roll))
			playsound(src, 'sound/items/taperoll_sound.ogg', 100)
			if(do_after(user, 14))
				icon_state = "box-tape"
	return ..()


/obj/item/storage/boxpackage/open(mob/user)
	if(icon_state == "box-tape")
		hide_from(user)
	if(icon_state == "box-notape")
		hide_from(user)
	if(icon_state == "box-open")
		storage_ui.close_all()
		playsound(src.loc, src.use_sound, 50, 1, -5)
		prepare_ui()
		storage_ui.on_open(user)
		storage_ui.show_to(user)

/obj/item/storage/boxpackage/can_be_inserted(obj/item/W, mob/user, stop_messages)
	if(icon_state == "box-tape")
		if(!stop_messages)
			to_chat(user, "<span class='notice'>\The [src] is taped, you're going to have to rip it off.</span>")
		return 0
	if(icon_state == "box-notape")
		if(!stop_messages)
			to_chat(user, "<span class='notice'>\The [src] is closed.</span>")
		return 0
	if(icon_state == "box-open")
		return 1
/obj/item/storage/boxpackage/RightClick(mob/user)
	if(icon_state == "box-tape")
		return
	opened(user)

/obj/item/storage/boxpackage/proc/opened(mob/user)
	if(user.incapacitated(INCAPACITATION_STUNNED|INCAPACITATION_RESTRAINED|INCAPACITATION_KNOCKOUT))
		return
	if(src != user.get_active_hand())
		return

	if(icon_state = "box-notape")
		closed = !closed
		if(!closed)
			icon_state = "box-open"
			open(user)
		else
			if(close(user))
				icon_state = "box-notape"