
///////////////////////////////////////////////Condiments
//Notes by Darem: The condiments food-subtype is for stuff you don't actually eat but you use to modify existing food. They all
//	leave empty containers when used up and can be filled/re-filled with other items. Formatting for first section is identical
//	to mixed-drinks code. If you want an object that starts pre-loaded, you need to make it in addition to the other code.

//Food items that aren't eaten normally and leave an empty container behind.
/obj/item/chems/condiment
	name = "Condiment Container"
	desc = "Just your average condiment container."
	icon = 'icons/obj/food.dmi'
	icon_state = "emptycondiment"
	atom_flags = ATOM_FLAG_OPEN_CONTAINER
	possible_transfer_amounts = @"[1,5,10]"
	center_of_mass = @"{'x':16,'y':6}"
	randpixel = 6
	volume = 50
	var/list/starting_reagents
	var/static/list/special_bottles = list(
		/decl/material/liquid/nutriment/ketchup = /obj/item/chems/condiment/ketchup,
		/decl/material/liquid/nutriment/barbecue = /obj/item/chems/condiment/barbecue,
		/decl/material/liquid/capsaicin = /obj/item/chems/condiment/capsaicin,
		/decl/material/liquid/enzyme = /obj/item/chems/condiment/enzyme,
		/decl/material/liquid/nutriment/soysauce = /obj/item/chems/condiment/soysauce,
		/decl/material/liquid/frostoil = /obj/item/chems/condiment/frostoil,
		/decl/material/solid/sodiumchloride = /obj/item/chems/condiment/small/saltshaker,
		/decl/material/solid/blackpepper = /obj/item/chems/condiment/small/peppermill,
		/decl/material/liquid/nutriment/cornoil = /obj/item/chems/condiment/cornoil,
		/decl/material/liquid/nutriment/sugar = /obj/item/chems/condiment/sugar,
		/decl/material/liquid/nutriment/mayo = /obj/item/chems/condiment/mayo,
		/decl/material/liquid/nutriment/vinegar = /obj/item/chems/condiment/vinegar
		)

/obj/item/chems/condiment/attackby(var/obj/item/W, var/mob/user)
	if(istype(W, /obj/item/pen) || istype(W, /obj/item/flashlight/pen))
		var/tmp_label = sanitize_safe(input(user, "Enter a label for [name]", "Label", label_text), MAX_NAME_LEN)
		if(tmp_label == label_text)
			return
		if(length(tmp_label) > 10)
			to_chat(user, "<span class='notice'>The label can be at most 10 characters long.</span>")
		else
			if(length(tmp_label))
				to_chat(user, "<span class='notice'>You set the label to \"[tmp_label]\".</span>")
				label_text = tmp_label
				name = addtext(name," ([label_text])")
			else
				to_chat(user, "<span class='notice'>You remove the label.</span>")
				label_text = null
				on_reagent_change()
		return



/obj/item/chems/condiment/attack_self(var/mob/user)
	return

/obj/item/chems/condiment/attack(var/mob/M, var/mob/user, var/def_zone)
	if(standard_feed_mob(user, M))
		return

/obj/item/chems/condiment/afterattack(var/obj/target, var/mob/user, var/proximity)
	if(!proximity)
		return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return

	if(istype(target, /obj/item/chems/food)) // These are not opencontainers but we can transfer to them
		if(!reagents || !reagents.total_volume)
			to_chat(user, "<span class='notice'>There is no condiment left in \the [src].</span>")
			return

		if(!REAGENTS_FREE_SPACE(target.reagents))
			to_chat(user, "<span class='notice'>You can't add more condiment to \the [target].</span>")
			return

		var/trans = reagents.trans_to_obj(target, amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>You add [trans] units of the condiment to \the [target].</span>")
	else
		..()

/obj/item/chems/condiment/feed_sound(var/mob/user)
	playsound(user.loc, 'sound/items/drink.ogg', rand(10, 50), 1)

/obj/item/chems/condiment/self_feed_message(var/mob/user)
	to_chat(user, "<span class='notice'>You swallow some of contents of \the [src].</span>")

/obj/item/chems/condiment/Initialize()
	. = ..()
	for(var/R in starting_reagents)
		reagents.add_reagent(R, starting_reagents[R])

/obj/item/chems/condiment/on_reagent_change()
	var/reagent = reagents.primary_reagent
	if(reagent in special_bottles)
		var/obj/item/chems/condiment/special_bottle = special_bottles[reagent]
		name = initial(special_bottle.name)
		desc = initial(special_bottle.desc)
		icon = initial(special_bottle.icon)
		icon_state = initial(special_bottle.icon_state)
		center_of_mass = initial(special_bottle.center_of_mass)
	else
		name = initial(name)
		desc = initial(desc)
		icon = initial(icon)
		center_of_mass = initial(center_of_mass)
		if(LAZYLEN(reagents.reagent_volumes))
			icon_state = "mixedcondiments"
		else
			icon_state = "emptycondiment"
	if(label_text)
		name = addtext(name," ([label_text])")

/obj/item/chems/condiment/enzyme
	name = "universal enzyme"
	desc = "Used in cooking various dishes."
	icon_state = "enzyme"
	starting_reagents = list(/decl/material/liquid/enzyme = 50)

/obj/item/chems/condiment/barbecue
	name = "barbecue sauce"
	desc = "Barbecue sauce, it's labeled 'sweet and spicy'"
	icon_state = "barbecue"
	starting_reagents = list(/decl/material/liquid/nutriment/barbecue = 50)

/obj/item/chems/condiment/sugar
	name = "sugar"
	desc = "Cavities in a bottle."
	starting_reagents = list(/decl/material/liquid/nutriment/sugar = 50)

/obj/item/chems/condiment/ketchup
	name = "ketchup"
	desc = "Tomato, but more liquid, stronger, better."
	icon_state = "ketchup"
	starting_reagents = list(/decl/material/liquid/nutriment/ketchup = 50)

/obj/item/chems/condiment/cornoil
	name = "corn oil"
	desc = "A delicious oil used in cooking. Made from corn."
	icon_state = "oliveoil"
	starting_reagents = list(/decl/material/liquid/nutriment/cornoil = 50)

/obj/item/chems/condiment/vinegar
	name = "vinegar"
	icon_state = "vinegar"
	desc = "As acidic as it gets in the kitchen."
	starting_reagents = list(/decl/material/liquid/nutriment/vinegar = 50)

/obj/item/chems/condiment/mayo
	name = "mayonnaise"
	icon_state = "mayo"
	desc = "Mayonnaise, used for centuries to make things edible."
	starting_reagents = list(/decl/material/liquid/nutriment/mayo = 50)

/obj/item/chems/condiment/frostoil
	name = "coldsauce"
	desc = "Leaves the tongue numb in its passage."
	icon_state = "coldsauce"
	starting_reagents = list(/decl/material/liquid/frostoil = 50)

/obj/item/chems/condiment/capsaicin
	name = "hotsauce"
	desc = "You can almost TASTE the stomach ulcers now!"
	icon_state = "hotsauce"
	starting_reagents = list(/decl/material/liquid/capsaicin = 50)

/obj/item/chems/condiment/small
	possible_transfer_amounts = @"[1,20]"
	amount_per_transfer_from_this = 1
	volume = 20

/obj/item/chems/condiment/small/on_reagent_change()
	return

/obj/item/chems/condiment/small/saltshaker
	name = "salt shaker"
	desc = "Salt. From space oceans, presumably."
	icon_state = "saltshakersmall"
	center_of_mass = @"{'x':16,'y':9}"
	starting_reagents = list(/decl/material/solid/sodiumchloride = 20)

/obj/item/chems/condiment/small/peppermill
	name = "pepper mill"
	desc = "Often used to flavor food or make people sneeze."
	icon_state = "peppermillsmall"
	center_of_mass = @"{'x':16,'y':8}"
	starting_reagents = list(/decl/material/solid/blackpepper = 20)

/obj/item/chems/condiment/small/sugar
	name = "sugar"
	desc = "Sweetness in a bottle"
	icon_state = "sugarsmall"
	center_of_mass = @"{'x':17,'y':9}"
	starting_reagents = list(/decl/material/liquid/nutriment/sugar = 20)

//MRE condiments and drinks.

/obj/item/chems/condiment/small/packet
	icon_state = "packet_small"
	w_class = ITEM_SIZE_TINY
	possible_transfer_amounts = @"[1,5,10]"
	amount_per_transfer_from_this = 1
	volume = 10

/obj/item/chems/condiment/small/packet/salt
	name = "salt packet"
	desc = "Contains 5u of table salt."
	icon_state = "packet_small_white"
	starting_reagents = list(/decl/material/solid/sodiumchloride = 5)

/obj/item/chems/condiment/small/packet/pepper
	name = "pepper packet"
	desc = "Contains 5u of black pepper."
	icon_state = "packet_small_black"
	starting_reagents = list(/decl/material/solid/blackpepper = 5)

/obj/item/chems/condiment/small/packet/sugar
	name = "sugar packet"
	desc = "Contains 5u of refined sugar."
	icon_state = "packet_small_white"
	starting_reagents = list(/decl/material/liquid/nutriment/sugar = 5)

/obj/item/chems/condiment/small/packet/jelly
	name = "jelly packet"
	desc = "Contains 10u of cherry jelly. Best used for spreading on crackers."
	starting_reagents = list(/decl/material/liquid/nutriment/cherryjelly = 10)
	icon_state = "packet_medium"

/obj/item/chems/condiment/small/packet/honey
	name = "honey packet"
	desc = "Contains 10u of honey."
	starting_reagents = list(/decl/material/liquid/nutriment/sugar = 10)
	icon_state = "packet_medium"

/obj/item/chems/condiment/small/packet/capsaicin
	name = "hot sauce packet"
	desc = "Contains 5u of hot sauce. Enjoy in moderation."
	icon_state = "packet_small_red"
	starting_reagents = list(/decl/material/liquid/capsaicin = 5)

/obj/item/chems/condiment/small/packet/ketchup
	name = "ketchup packet"
	desc = "Contains 5u of ketchup."
	icon_state = "packet_small_red"
	starting_reagents = list(/decl/material/liquid/nutriment/ketchup = 5)

/obj/item/chems/condiment/small/packet/mayo
	name = "mayonnaise packet"
	desc = "Contains 5u of mayonnaise."
	icon_state = "packet_small_white"
	starting_reagents = list(/decl/material/liquid/nutriment/mayo = 5)

/obj/item/chems/condiment/small/packet/soy
	name = "soy sauce packet"
	desc = "Contains 5u of soy sauce."
	icon_state = "packet_small_black"
	starting_reagents = list(/decl/material/liquid/nutriment/soysauce = 5)

/obj/item/chems/condiment/small/packet/coffee
	name = "instant coffee powder packet"
	desc = "Contains 5u of instant coffee powder. Mix with 25u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/coffee/instant = 5)

/obj/item/chems/condiment/small/packet/tea
	name = "instant tea powder packet"
	desc = "Contains 5u of instant black tea powder. Mix with 25u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/tea/instant = 5)

/obj/item/chems/condiment/small/packet/cocoa
	name = "cocoa powder packet"
	desc = "Contains 5u of cocoa powder. Mix with 25u of water and heat."
	starting_reagents = list(/decl/material/liquid/nutriment/coco = 5)

/obj/item/chems/condiment/small/packet/grape
	name = "grape juice powder packet"
	desc = "Contains 5u of powdered grape juice. Mix with 15u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/instantjuice/grape = 5)

/obj/item/chems/condiment/small/packet/orange
	name = "orange juice powder packet"
	desc = "Contains 5u of powdered orange juice. Mix with 15u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/instantjuice/orange = 5)

/obj/item/chems/condiment/small/packet/watermelon
	name = "watermelon juice powder packet"
	desc = "Contains 5u of powdered watermelon juice. Mix with 15u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/instantjuice/watermelon = 5)

/obj/item/chems/condiment/small/packet/apple
	name = "apple juice powder packet"
	desc = "Contains 5u of powdered apple juice. Mix with 15u of water."
	starting_reagents = list(/decl/material/liquid/nutriment/instantjuice/apple = 5)

/obj/item/chems/condiment/small/packet/protein
	name = "protein powder packet"
	desc = "Contains 10u of powdered protein. Mix with 20u of water."
	icon_state = "packet_medium"
	starting_reagents = list(/decl/material/liquid/nutriment/protein = 10)

/obj/item/chems/condiment/small/packet/crayon
	name = "crayon powder packet"
	desc = "Contains 10u of powdered crayon. Mix with 30u of water."
	starting_reagents = list(/decl/material/liquid/pigment = 10)
/obj/item/chems/condiment/small/packet/crayon/red
	starting_reagents = list(/decl/material/liquid/pigment/red = 10)
/obj/item/chems/condiment/small/packet/crayon/orange
	starting_reagents = list(/decl/material/liquid/pigment/orange = 10)
/obj/item/chems/condiment/small/packet/crayon/yellow
	starting_reagents = list(/decl/material/liquid/pigment/yellow = 10)
/obj/item/chems/condiment/small/packet/crayon/green
	starting_reagents = list(/decl/material/liquid/pigment/green = 10)
/obj/item/chems/condiment/small/packet/crayon/blue
	starting_reagents = list(/decl/material/liquid/pigment/blue = 10)
/obj/item/chems/condiment/small/packet/crayon/purple
	starting_reagents = list(/decl/material/liquid/pigment/purple = 10)
/obj/item/chems/condiment/small/packet/crayon/grey
	starting_reagents = list(/decl/material/liquid/pigment/grey = 10)
/obj/item/chems/condiment/small/packet/crayon/brown
	starting_reagents = list(/decl/material/liquid/pigment/brown = 10)

//End of MRE stuff.

/obj/item/chems/condiment/flour
	name = "flour sack"
	desc = "A big bag of flour. Good for baking!"
	icon = 'icons/obj/food.dmi'
	icon_state = "flour"
	item_state = "flour"
	randpixel = 10
	starting_reagents = list(/decl/material/liquid/nutriment/flour = 50)

/obj/item/chems/condiment/flour/on_reagent_change()
	return

/obj/item/chems/condiment/salt
	name = "big bag of salt"
	desc = "A nonsensically large bag of salt. Carefully refined from countless shifts."
	icon = 'icons/obj/food.dmi'
	icon_state = "salt"
	item_state = "flour"
	randpixel = 10
	volume = 500
	w_class = ITEM_SIZE_LARGE
	starting_reagents = list(/decl/material/solid/sodiumchloride = 500)

/obj/item/chems/condiment/salt/on_reagent_change()
	return

/obj/item/chems/condiment/mint
	name = "mint essential oil"
	desc = "A small bottle of the essential oil of some kind of mint plant."
	icon = 'icons/obj/food.dmi'
	icon_state = "coldsauce"
	starting_reagents = list(/decl/material/liquid/drink/syrup/mint = 15)

/obj/item/chems/condiment/mint/on_reagent_change()
	return

/obj/item/chems/condiment/soysauce
	name = "soy sauce"
	desc = "A dark, salty, savoury flavoring."
	icon_state = "soysauce"
	amount_per_transfer_from_this = 1
	volume = 20
	starting_reagents = list(/decl/material/liquid/nutriment/soysauce = 20)
