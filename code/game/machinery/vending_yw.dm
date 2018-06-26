/obj/machinery/vending/food/prison //Fluff vendor for the lewd houseboat.
	name = "Prison Nutriment Vendor"
	desc = "Do you think Joan cooks? Of course not. Lazy squirrel!"
	icon_state = "boozeomat"
	icon_deny = "boozeomat-deny"
	products = list(/obj/item/weapon/tray = 6,
					/obj/item/weapon/material/kitchen/utensil/fork = 6,
					/obj/item/weapon/material/knife/plastic = 6,
					/obj/item/weapon/material/kitchen/utensil/spoon = 6,
					/obj/item/weapon/reagent_containers/food/snacks/bugball = 10,
					/obj/item/weapon/reagent_containers/food/snacks/candy_corn = 30,
					/obj/item/weapon/reagent_containers/food/snacks/tofu = 10,
					/obj/item/weapon/reagent_containers/food/snacks/wishsoup = 10,
					/obj/item/weapon/reagent_containers/food/snacks/candy/proteinbar = 2,
					/obj/item/weapon/reagent_containers/food/snacks/liquidfood = 10,
					)
	contraband = list(/obj/item/weapon/reagent_containers/food/snacks/tofupie = 3)
	vend_delay = 15