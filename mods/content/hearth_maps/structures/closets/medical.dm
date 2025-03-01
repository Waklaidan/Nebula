/*
 * Endeavour Medical
 */
/decl/closet_appearance/secure_closet/endeavour/medical
	extra_decals = list(
		"stripe_vertical_mid_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/endeavour/medical/physician
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_BABY_BLUE
	)

/decl/closet_appearance/secure_closet/endeavour/medical/cmo
	extra_decals = list(
		"stripe_vertical_left_full" = COLOR_BABY_BLUE,
		"stripe_vertical_mid_full" = COLOR_CLOSET_GOLD,
		"stripe_vertical_right_full" = COLOR_BABY_BLUE,
		"medical" = COLOR_CLOSET_GOLD
	)

/obj/structure/closet/secure_closet/counselor
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/medical

/obj/structure/closet/secure_closet/CMO_endeavour
	name = "chief medical officer's locker"
	req_access = list(access_cmo)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/medical/cmo

/obj/structure/closet/secure_closet/CMO_endeavour/WillContain()
	return list(
		/obj/item/clothing/suit/bio_suit/cmo,
		/obj/item/clothing/head/bio_hood/cmo,
		/obj/item/clothing/shoes,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmo,
		/obj/item/clothing/suit/storage/toggle/labcoat/cmoalt,
		/obj/item/radio/headset/heads/cmo,
		/obj/item/radio/headset/heads/cmo/alt,
		/obj/item/flash,
		/obj/item/gun/projectile/pistol/secure,
		/obj/item/megaphone,
		/obj/item/chems/hypospray/vial,
		/obj/item/storage/fancy/vials,
		/obj/item/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/clothing/suit/armor/pcarrier/medium,
		/obj/item/clothing/head/helmet/command,
		/obj/item/holowarrant,
		/obj/item/storage/firstaid/adv,
		/obj/item/storage/box/armband/med,
		/obj/item/storage/belt/general,
		/obj/item/knife/folding/swiss/officer,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/med, /obj/item/storage/backpack/messenger/med)),
		RANDOM_SCRUBS
	)

/obj/structure/closet/secure_closet/medical_endeavoursenior
	name = "physician's locker"
	req_access = list(access_senmed)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/medical/physician

/obj/structure/closet/secure_closet/medical_endeavoursenior/WillContain()
	return list(
		/obj/item/clothing/under/sterile,
		/obj/item/clothing/suit/storage/toggle/labcoat,
		/obj/item/clothing/suit/surgicalapron,
		/obj/item/clothing/shoes,
		/obj/item/radio/headset/headset_med,
		/obj/item/radio/headset/headset_med/alt,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical,
		/obj/item/clothing/mask/surgical,
		/obj/item/scanner/health,
		/obj/item/clothing/accessory/stethoscope,
		/obj/item/flashlight/pen,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/flash,
		/obj/item/megaphone,
		/obj/item/storage/firstaid/adv,
		/obj/item/knife/folding/swiss/medic,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/med, /obj/item/storage/backpack/messenger/med)),
		RANDOM_SCRUBS = 2
	)

/obj/structure/closet/secure_closet/medical_endeavour
	name = "medical technician's locker"
	req_access = list(access_medical_equip)
	closet_appearance = /decl/closet_appearance/secure_closet/endeavour/medical

/obj/structure/closet/secure_closet/medical_endeavour/WillContain()
	return list(
		/obj/item/clothing/under/sterile,
		/obj/item/clothing/accessory/storage/vest/white,
		/obj/item/clothing/suit/storage/toggle/fr_jacket,
		/obj/item/clothing/shoes,
		/obj/item/radio/headset/headset_med,
		/obj/item/radio/headset/headset_corpsman/alt,
		/obj/item/taperoll/medical,
		/obj/item/storage/belt/medical/emt,
		/obj/item/clothing/mask/gas/half,
		/obj/item/tank/emergency/oxygen/engi,
		/obj/item/storage/box/autoinjectors,
		/obj/item/scanner/health,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/storage/firstaid/adv,
		/obj/item/clothing/suit/storage/medical_chest_rig,
		/obj/item/clothing/head/hardhat/ems,
		/obj/item/knife/folding/swiss/medic,
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/medic, /obj/item/storage/backpack/satchel/med)),
		new /datum/atom_creator/weighted(list(/obj/item/storage/backpack/dufflebag/med, /obj/item/storage/backpack/messenger/med))
	)

/obj/structure/closet/wardrobe/medic_endeavour
	name = "medical wardrobe"
	closet_appearance = /decl/closet_appearance/wardrobe/white

/obj/structure/closet/wardrobe/medic_endeavour/WillContain()
	return list(
		/obj/item/clothing/under/sterile = 2,
		RANDOM_SCRUBS = 4,
		/obj/item/clothing/suit/surgicalapron = 2,
		/obj/item/clothing/shoes = 2,
		/obj/item/clothing/mask/surgical = 2
	)
