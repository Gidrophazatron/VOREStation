// Yeah yeah, vague file name. Basically a misc folder for antag things that RnD can make.

/datum/design/item/binaryencrypt
	name = "Binary encryption key"
	desc = "Allows for deciphering the binary channel on-the-fly."
	id = "binaryencrypt"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 300, "glass" = 300)
	build_path = /obj/item/device/encryptionkey/binary
	sort_string = "VASAA"

/datum/design/item/chameleon
	name = "Holographic equipment kit"
	desc = "A kit of dangerous, high-tech equipment with changeable looks."
	id = "chameleon"
	req_tech = list(TECH_ILLEGAL = 2)
	materials = list(DEFAULT_WALL_MATERIAL = 500)
	build_path = /obj/item/weapon/storage/box/syndie_kit/chameleon
	sort_string = "VASBA"

/datum/design/item/weapon/esword
	name = "Portable Energy Blade"
	id = "chargesword"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_ILLEGAL = 4, TECH_ARCANE = 1)
	materials = list(MAT_PLASTEEL = 3500, "glass" = 1000, MAT_LEAD = 2250, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/weapon/melee/energy/sword/charge
	sort_string = "VASCA"

/datum/design/item/weapon/eaxe
	name = "Energy Axe"
	id = "chargeaxe"
	req_tech = list(TECH_COMBAT = 6, TECH_MAGNET = 5, TECH_ENGINEERING = 4, TECH_ILLEGAL = 4)
	materials = list(MAT_PLASTEEL = 3500, MAT_OSMIUM = 2000, MAT_LEAD = 2000, MAT_METALHYDROGEN = 500)
	build_path = /obj/item/weapon/melee/energy/axe/charge
	sort_string = "VASCB"


//RU-VORE Addition.

/datum/design/item/weapon/emag
	name = "Experimental sequensor"
	id = "emag"
	req_tech = list(TECH_MAGNET = 5, TECH_DATA = 5, TECH_ILLEGAL = 7, TECH_ARCANE = 1)//Note: Why Cargo just can hack board with multitool and buy a lot of antag shit. Why science can't?
	materials = list(DEFAULT_WALL_MATERIAL = 500, "glass" = 15000, "gold" = 16000, "diamond" = 26000)//This is kinda too OP to create this in a big industry-sizes.
	build_path = /obj/item/weapon/card/emag
	sort_string = "VASDA"
