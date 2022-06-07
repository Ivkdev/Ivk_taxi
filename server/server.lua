PerformHttpRequest("https://raw.githubusercontent.com/FiveM-Scripts/ivk_taxi/master/__resource.lua", function(errorCode, result, headers)
    local version = GetResourceMetadata(GetCurrentResourceName(), 'resource_version', 0)

    if string.find(tostring(result), version) == nil then
        print("\n\r[fs_taxi] The version on this server is not up to date. Please update now.\n\r")
    end
end, "GET", "", "")

RegisterServerEvent('ivk_taxi:payCab')
AddEventHandler('ivk_taxi:payCab', function(meters)
	local src = source
	
	local totalPrice = meters / 40.0
	local price = math.floor(totalPrice)
	
	if optional.use_essentialmode then
		TriggerEvent('es:getPlayerFromId', src, function(user)
			if user.getMoney() >= tonumber(price) then
				user.removeMoney(tonumber(price))
				TriggerClientEvent('ivk_taxi:payment-status', src, true)
			else
				TriggerClientEvent('ivk_taxi:payment-status', src, false)
			end
		end)
	elseif optional.use_venomous then
		TriggerEvent('vf_base:FindPlayer', src, function(user)
			if user.cash >= tonumber(price) then
				TriggerEvent('vf_base:ClearCash', src, tonumber(price))
				TriggerClientEvent('ivk_taxi:payment-status', src, true)				
			else
				TriggerClientEvent('ivk_taxi:payment-status', src, false)
			end
		end)
	else
		TriggerClientEvent('ivk_taxi:payment-status', src, true)	
	end
end)

RegisterNetEvent("ivk_taxi:playvideo")
AddEventHandler(
    "ivk_taxi:playvideo",
    function(video)
        SendNUIMessage(
            {
                transactionType = "playvideo",
                transactionFile = video,
                transactionVolume = 0.3
            }
        )
      
    end
)