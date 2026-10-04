local mps = game:GetService("MarketplaceService")
local players = game:GetService("Players")

local products = {}


-- Crons 1
products[3524554243] = function(receipt, plr)
	
	plr.leaderstats.Crons.Value += 500
	
end


local passes = {}




local function processReceipt(info)
	
	local userID = info.PlayerId
	local productID = info.ProductId
	
	local plr = players:GetPlayerByUserId(userID)
	if not plr then
		warn("Unable to get player, function will be called back")
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end
	
	-- Processes the receipt, and executes the function of the product
	local execute = products[productID]
	local success, err = pcall(execute, info, plr)
	if success then
		return Enum.ProductPurchaseDecision.PurchaseGranted
	else
		warn("Failed to process receipt:", info, err)
		return 
	end

end


-- Sets the callback for product purchases
mps.ProcessReceipt = processReceipt


