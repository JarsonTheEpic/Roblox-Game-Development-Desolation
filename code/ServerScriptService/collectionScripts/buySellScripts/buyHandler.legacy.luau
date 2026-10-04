local buyEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.buyEvent
local serverStorage = game:WaitForChild("ServerStorage")
local tools = serverStorage.Tools
local plrTips = game:WaitForChild("ReplicatedStorage").plrTipsEvent

local buyPointInfos = {
	buyPointInfo1 = { -- Name, Price, Description, Model
		storeDesc = "What do you want? Don't let me \n catch ya stealing boi",
		reviews = {
			anonymous = {"Anonymous", "Why are there so many weapons? \n DANGEROUS"},
			paul = {"Paul", "This store is horrible 1 / 5"},
			eugene = {"Eugene", "This store's staff was very rude"},
			jason = {"Jason", "Too expensive"},
			houston = {"Houston", "Why does everyone dislike this \n store? its not that bad"},
			ilya = {"Ilya", "Bad store"},
			Bill = {"Bill", "Hi"}
		},
		items = {
			shiv = {"Shiv", 5, "Improvised knife"},
			kitchenKnife = {"Kitchen knife", 25, "Generic kitchen tool"}
		},
		firstItemName = "Shiv"
	},

	buyPointInfo2 = { -- Name, Price, Description, Model
		storeDesc = "Can I interest you in some very \n high quality beans",
		reviews = {
			anonymous = {"Anonymous", "mid store"},
			nathan = {"Nathan", "DO NOT BUY FROM \n THIS STORE I GOT VERY \n SICK FROM THEIR FOOD"},
			Karen = {"Karen", "This store was very bad \n I need to speak to their manager"},
		},
		items = {
			canOfBeans = {"Can of beans", 5, "A cool description idk"},
			shiv = {"Shiv", 15, "Improvised knife"},
			kitchenKnife = {"Kitchen knife", 20, "Generic kitchen tool"},
			bottleOfWater = {"Bottle of water", 3, "Its water what \n did you expect"}, -- Use the fifth index if 2 item names are the same and refer to the same tool
			fireaxe = {"Fireaxe", 150, "A axe used by \n firefighters, but you can \ use them to chop \n down people as well"}
		},
		firstItemName = "Can of beans"
	},

	passportOffice = { -- Name, Price, Description, Model
		storeDesc = "Watchu want?",
		reviews = {
			anonymous = {"Anonymous", "The attitude of the \n workers were very bad"},
		},
		items = {
			passport = {"Passport", 120, "You need this to \n enter the city", {{"isReal", true}}}, -- Tell the handler to set this stat to true
			bottleOfWater = {"Bottle of water", 10, "Water (Overpriced)"}
		},
		firstItemName = "Passport"
	},

	gunShop1 = {
		storeDesc = "Purchase weapons here!",
		reviews = {
			andrew = {"Andrew", "Too expensive"},
			maverick = {"Maverick", "Why so many restrictions \n for a gun?"},
			anonymous = {"Anonymous", "17/09/2076: Be ready."},
			gurt = {"Gurt", "yo"},
		},
		items = {
			M4A1 = {"M4A1", 1200, "A powerful, compact \n carbine rifle"},
			GCP45 = {"GCP45", 300, "A reliable pistol, with \n with higher than average \n recoil"},
			Scar = {"Scar-L", 1600, "An accurate, heavy \n killing machine"},
			GMP25 = {"GMP25", 800, "A reliable, relatively stable smg that is powerful against unarmored opponents"},
			utilitiesVest = {"Utilities vest", 500, "A lightweight vest \n that can protect \n against some smaller calibers"},
			ammoBox = {"a556x45 ammo", 120, "3 mags of 5.56 ammo", {{"a556x45mm", 90}}, "Ammo box"},
			ammoBox2 = {"a45Auto ammo", 50, "2 mags of 45Auto ammo", {{"a45Auto", 50}}, "Ammo box"},
			smokeGrenade = {"Smoke grenade", 100, "3 smoke grenades, \n creates a large \n smoke to obstruct \n vision", {{"amount", 3}}}
		},
		firstItemName = "M4A1"
	},

	illegalStore1 = {
		storeDesc = "Finish this business quick. \n Don't stay.",
		reviews = {
			anonymous1 = {"Anonymous", "Cheap weapons."},
			anonymous2 = {"Big J", "Nice guns."},
			anonymous3 = {"Anonymous", "Is leaving a review \n mandatory?"}
		},
		items = {
			Makarov = {"Makarov", 100, "Not very strong \n by any means, \n but it gets the job done."},
			CAP10 = {"CAP10", 300, "Insane firerate!"},
			AK47 = {"AK47", 1200, "Serious buyers only!"},
			ammoBox1 = {"a45Auto ammo", 30, "4 mags of 45Auto ammo", {{"a45Auto", 120}}, "Ammo box"},
			ammoBox2 = {"9x18mm ammo", 20, "5 mags of 9x18 ammo", {{"a9x18mm", 40}}, "Ammo box"},
			ammoBox3 = {"762x39mm ammo", 90, "3 mags of 45Auto ammo", {{"a762x39mm", 90}}, "Ammo box"},
			C4 = {"C4", 100, "A block of C4 explosive, extremely deadly", {{"amount", 1}}},
			lockpick = {"Lockpick", 30, "3 lockpicks, used to open things that you weren't meant to", {{"amount", 3}}}
		},
		firstItemName = "Makarov"
	},

	lercarkConvenience = {
		storeDesc = "Do you want a bag?",
		reviews = {
			adam = {"Adam", "Groceries are getting more \n and more expensive"},
			anonymous = {"Anonymous", "The employee's attitude is \n very bad"}
		},
		items = {
			canOfBeans = {"Can of beans", 15, "A hearty tin of beans"},
			kitchenKnife = {"Kitchen knife", 50, "Generic kitchen tool"},
			bottleOfWater = {"Bottle of water", 10, "Its water what \n did you expect"},
			bloxiade = {"Bloxiade", 20, "A famous energy drink \n high in caffeine, not \n very good for your heart"}
		},
		firstItemName = "Bottle of water"
	},
	
	generalStore = {
		storeDesc = "Please hurry up.",
		reviews = {
			adam = {"Adam", "Groceries are getting more \n and more expensive"},
			anonymous = {"Anonymous", "The employees here are so rude!"}
		},
		items = {
			canOfBeans = {"Can of beans", 15, "A hearty tin of beans"},
			kitchenKnife = {"Kitchen knife", 50, "Generic kitchen tool"},
			bottleOfWater = {"Bottle of water", 10, "Its water what \n did you expect"},
			bloxiade = {"Bloxiade", 20, "A famous energy drink \n high in caffeine, not \n very good for your heart"}
		},
		firstItemName = "Bottle of water"
	},
	
	pharmacy1 = {
		storeDesc = "Please don't take everything like the last guy... We are running out of stock fast",
		reviews = {
			ilya = {"Ilya", "Everything is out of stock"},
			adam = {"Adam", "Why is everyone hoarding medicine??"}
		},
		items = {
			bandage = {"Bandage", 50, "A small roll of bandages designed to stop bleeding, although it won't be effective against more deeper wounds"}
		},
		firstItemName = "Bandage"
	},
	
	dealer1 = {
		storeDesc = "What do you want?",
		reviews = {
			anonymous1 = {"Anonymous", "idk how to write a review"}
		},
		items = {
			Makarov = {"Makarov", 75, "A visibly damaged pistol, but it should work", {{"durability", 40}}},
			ammoBox2 = {"9x18mm ammo", 20, "40 9x18mm bullets, used by the Makarov", {{"a9x18mm", 40}}, "Ammo box"},
			lockpick = {"Lockpick", 20, "2 lockpicks, used to open things that you weren't meant to", {{"amount", 2}}}
		},
		firstItemName = "Makarov"
	},

	palmart1 = {
		storeDesc = "Hurry up please, I have no more will to work here...",
		reviews = {
			anonymous1 = {"Anonymous", "idk how to write a review"},
			adrian = {"Adrian", "Why is the cashier so passive aggressive? ONE STAR!"},
			zimmy = {"Zimmy", "So many things out of stock!"},
			Maverick = {"Maverick", "I miss it when Palmart actually had affordable prices..."},
			Zosia = {"Zosia", "The milk was EXPIRED!!!!"}
		},
		items = {
			canOfBeans = {"Can of beans", 15, "A hearty tin of beans"},
			kitchenKnife = {"Kitchen knife", 50, "Generic kitchen tool"},
			bottleOfWater = {"Bottle of water", 10, "Its water what \n did you expect"},
			bandage = {"Bandage", 75, "A small roll of bandages designed to stop bleeding, although it won't be effective against more deeper wounds"},
			bloxiade = {"Bloxiade", 20, "A famous energy drink \n high in caffeine, not \n very good for your heart"}
		},
		firstItemName = "Can of beans"
	},
}

buyEvent.OnServerEvent:Connect(function(plr, selectedItem, buyPoint)

	local point = buyPointInfos[buyPoint]
	
	local itemIndex = nil
	local price = nil
		
	for i, thing in pairs(buyPointInfos[buyPoint].items) do
		if thing[1] == selectedItem then
			price = thing[2]
			itemIndex = i
		end
	end
	
	if plr.leaderstats.Crons.Value >= price then -- Buy success
		
		local itemClone
		
		if buyPointInfos[buyPoint].items[itemIndex][5] then -- If the item bought is a tool with different name from product name
			itemClone = tools:FindFirstChild(buyPointInfos[buyPoint].items[itemIndex][5], true):Clone()
		else
			itemClone = tools:FindFirstChild(selectedItem, true):Clone()
		end
		
		if buyPointInfos[buyPoint].items[itemIndex][4] then
			for i, v in buyPointInfos[buyPoint].items[itemIndex][4] do
				if itemClone:FindFirstChild(v[1], true) then
					itemClone:FindFirstChild(v[1], true).Value = v[2]
				end
			end
		end
		
		plrTips:FireClient(plr, "You successfully bought ".. itemClone.Name.. " for ".. price.. " Crons", 3)
		
		itemClone.Parent = plr.Backpack
		plr.leaderstats.Crons.Value = plr.leaderstats.Crons.Value - price
	else
		plrTips:FireClient(plr, "You don't have enough money!", 3)
	end
	
end)
