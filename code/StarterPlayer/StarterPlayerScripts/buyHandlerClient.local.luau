local buyEvent = game:WaitForChild("ReplicatedStorage").gameplayEvents.buyEvent
local replicatedStorage = game:WaitForChild("ReplicatedStorage")
local buyPointModels = replicatedStorage.buyPointModels
local replicatedStorage = game:WaitForChild("ReplicatedStorage")

repeat task.wait() until game.Players.LocalPlayer

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

-- To add a new buypoint:
-- Add the items in BOTH the buyHandlerClient and buyHandler scripts
-- Add the model of the buypoint in the buyPointModels folder
-- Add new tool models in the toolModels folder if it doesn't already exists


local openBuyScreen = game:WaitForChild("ReplicatedStorage").gameplayEvents.openBuyScreen

local collectionService = game:GetService("CollectionService")

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")

local itemClone = plr.PlayerGui.buyScreen.Frame.buyFolder.buyFrame.item:Clone()


openBuyScreen.OnClientEvent:Connect(function(buyPointInfo) -- buyPointInfo1, buyPointInfo2
	
	local buyScreen = plr.PlayerGui.buyScreen
	local reviewClone = buyScreen.Frame.descriptionFolder.reviewsFrame.review:Clone()

	buyScreen.Frame.descriptionFolder.reviewsFrame:ClearAllChildren() -- Deletes previous reviews
	if buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("buyPointInfo1") then
		buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("buyPointInfo1"):Destroy()
	end
	if buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("buyPointInfo2") then
		buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("buyPointInfo2"):Destroy()
	end
	if buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("passportOffice") then
		buyScreen.Frame.descriptionFolder.shopFrame:FindFirstChild("passportOffice"):Destroy()
	end
	
	buyScreen.Frame.buyFolder.buyFrame:ClearAllChildren()
	
	buyScreen.Frame.buyFolder.itemFrame.purchaseButton.buyPointInfo.Value = buyPointInfo
	local VPFClone = replicatedStorage.buyPointModels:FindFirstChild(buyPointInfo):Clone()
	VPFClone.Parent = buyScreen.Frame.descriptionFolder.shopFrame

	--buyScreen.Frame.descriptionFolder.shopFrame.ViewportFrame.WorldModel:ClearAllChildren()
	
	--local buyPointModelClone = buyPointModels.buyPointModel:Clone()
	--buyPointModelClone.Parent = buyScreen.Frame.descriptionFolder.shopFrame.ViewportFrame.WorldModel 
	--buyPointModelClone.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	--buyPointModelClone:SetPrimaryPartCFrame(CFrame.new(Vector3.new(0, 0, -9.5), Vector3.new(0, 0, 0)))
	
	buyScreen.Frame.descriptionFolder.shopFrame.shopDescription.Text = buyPointInfos[buyPointInfo].storeDesc
	
	buyScreen.Frame.descriptionFolder.reviewsFrame:ClearAllChildren()
	
	local counter = 0
	
	for i, review in pairs(buyPointInfos[buyPointInfo].reviews) do -- Generate the reviews
		local newReview = reviewClone:Clone()
		newReview.Parent = buyScreen.Frame.descriptionFolder.reviewsFrame
		newReview.personName.Text = review[1]
		newReview.description.Text = review[2]
		newReview.Position = UDim2.new(0, 0, counter * 0.1, 0)
		
		newReview.Visible = true
		counter += 1
	end
	
	--local itemClone = buyScreen.Frame.buyFolder.buyFrame.item:Clone()
	buyScreen.Frame.buyFolder.buyFrame:ClearAllChildren()

	counter = 0

	for i, item in pairs(buyPointInfos[buyPointInfo].items) do -- Generate the shop items
		local newItem = itemClone:Clone()
		newItem.Parent = buyScreen.Frame.buyFolder.buyFrame
		newItem.Text = item[1]
		newItem.itemName.Value = item[1]
		newItem.Name = item[1]
		newItem.price.Value = item[2]
		newItem.description.Value = item[3]
		newItem.Position = UDim2.new(0, 0, counter * 0.1, 0)

		newItem.Visible = true
		counter += 1
	end
	
	local buyFolder = buyScreen.Frame.buyFolder
	
	local items = buyPointInfos[buyPointInfo].items
	
	local buyInfo = buyPointInfos[buyPointInfo]
	local firstSelected = buyInfo.firstItemName
	
	
	buyScreen.Frame.selectedItem.Value = firstSelected
	buyScreen.Frame.buyFolder.itemFrame.ViewportFrame.WorldModel:ClearAllChildren()
	local item = replicatedStorage:WaitForChild("toolModels"):FindFirstChild(firstSelected, true):Clone()
	item.Parent = buyScreen.Frame.buyFolder.itemFrame.ViewportFrame.WorldModel
	buyScreen.Frame.buyFolder.itemFrame.purchaseButton.Text = `Buy a {firstSelected} for {buyFolder.buyFrame:FindFirstChild(firstSelected).price.Value} Crons`
	buyScreen.Frame.buyFolder.itemFrame.itemDescription.Text = buyFolder.buyFrame:FindFirstChild(firstSelected).description.Value
	
	for i, button in pairs(buyScreen.Frame.buyFolder.buyFrame:GetChildren()) do -- When button clicked on
		
		if button:IsA("TextButton") == false and button:IsA("ImageButton") == false then return end
			
		button.Activated:Connect(function()
			buyScreen.Frame.selectedItem.Value = button.itemName.Value
			buyScreen.Frame.buyFolder.itemFrame.ViewportFrame.WorldModel:ClearAllChildren()
			local item = replicatedStorage:WaitForChild("toolModels"):FindFirstChild(button.itemName.Value, true):Clone()
			item.Parent = buyScreen.Frame.buyFolder.itemFrame.ViewportFrame.WorldModel
			buyScreen.Frame.buyFolder.itemFrame.purchaseButton.Text = `Buy a {button.itemName.Value} for {button.price.Value} Crons`
			buyScreen.Frame.buyFolder.itemFrame.itemDescription.Text = button.description.Value
			--buyScreen.Frame.descriptionFolder.shopFrame.buyButton.Visible = true
		end)
	end
	
	buyScreen.Frame.Visible = true
	
end)
