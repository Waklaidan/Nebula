/*
 * Endeavour Supply
 */
/decl/closet_appearance/secure_closet/endeavour/cargo
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/endeavour/cargo/worker
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_BEASTY_BROWN
	)

/decl/closet_appearance/secure_closet/endeavour/cargo/deck_officer
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_left_full" = COLOR_BEASTY_BROWN,
		"stripe_vertical_right_full" = COLOR_BEASTY_BROWN,
		"cargo_upper" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/decktech
	name = "deck technician's locker"
	req_access = list(access_cargo)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/cargo/worker

/obj/structure/closet/secure_closet/decktech/WillContain()
	return list(
		/obj/item/radio/headset/headset_cargo,
		/obj/item/radio/headset/headset_cargo/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/webbing_large,
		/obj/item/storage/belt/utility/atmostech,
		/obj/item/hand_labeler,
		/obj/item/clipboard,
		/obj/item/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/marshalling_wand,
		/obj/item/marshalling_wand,
		/obj/item/storage/belt/general,
		/obj/item/stamp/cargo,
		/obj/item/stamp/denied,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack = 75, /obj/item/storage/backpack/satchel/grey = 25)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/messenger = 75, /obj/item/storage/backpack/dufflebag = 25))
	)

/obj/structure/closet/secure_closet/deckofficer
	name = "deck chief's locker"
	req_access = list(access_qm)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/cargo/deck_officer

/obj/structure/closet/secure_closet/deckofficer/WillContain()
	return list(
		/obj/item/radio/headset/headset_deckofficer,
		/obj/item/radio/headset/headset_deckofficer/alt,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/glasses/meson,
		/obj/item/clothing/glasses/sunglasses,
		/obj/item/clothing/suit/storage/hazardvest,
		/obj/item/clothing/accessory/storage/vest,
		/obj/item/storage/belt/utility/full,
		/obj/item/hand_labeler,
		/obj/item/clipboard,
		/obj/item/folder/yellow,
		/obj/item/stack/package_wrap/twenty_five,
		/obj/item/flash,
		/obj/item/megaphone,
		/obj/item/holowarrant,
		/obj/item/clothing/suit/armor/pcarrier/light,
		/obj/item/gun/projectile/pistol/secure,
		/obj/item/binoculars,
		/obj/item/storage/belt/general,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack = 75, /obj/item/storage/backpack/satchel/grey = 25)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/messenger = 75, /obj/item/storage/backpack/dufflebag = 25))
	)

/obj/structure/closet/secure_closet/prospector
	name = "prospector's locker"
	req_access = list(access_mining)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/cargo

/obj/structure/closet/secure_closet/prospector/WillContain()
	return list(
		/obj/item/clothing/accessory/storage/vest,
		/obj/item/clothing/mask/gas/half,
		/obj/item/clothing/gloves/thick,
		/obj/item/clothing/shoes/workboots,
		/obj/item/radio/headset/headset_mining,
		/obj/item/radio/headset/headset_mining/alt,
		/obj/item/flashlight/lantern,
		/obj/item/shovel,
		/obj/item/pickaxe,
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/storage/ore,
		/obj/item/scanner/mining,
		/obj/item/gps,
		/obj/item/radio,
		/obj/item/clothing/glasses/material,
		/obj/item/clothing/glasses/meson,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/industrial, /obj/item/storage/backpack/satchel/eng, /obj/item/storage/backpack/messenger/engi)),
		/obj/item/storage/backpack/dufflebag/eng
	)
