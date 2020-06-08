ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterNetEvent('xtu_shop:giveItem')
AddEventHandler('xtu_shop:giveItem', function(item, count)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()

    if playerMoney >= item.price * count then
        xPlayer.addInventoryItem(item.value, count)
        xPlayer.removeMoney(item.price * count)

        TriggerClientEvent("esx:showAdvancedNotification", source,'Apu', '~g~Achat',"Vous venez d'acheter ~b~".. count .. ' ' .. item.label .. ' ~s~pour ~g~' .. item.price * count .. '$', 'CHAR_LAZLOW2', 1)
    else
        TriggerClientEvent("esx:showAdvancedNotification",source, 'Apu', '~r~Erreur', "Vous n'avez pas asser d'argent pour ~g~".. item.label .. '~s~ il vous manque ~g~' .. item.price * count - playerMoney .. '$', 'CHAR_LAZLOW2', 1)
    end

end)