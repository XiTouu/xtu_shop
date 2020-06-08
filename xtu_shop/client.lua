ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

------------ Création du Menu / Sous Menu -----------

RMenu.Add('shop', 'main', RageUI.CreateMenu("Supérette", "Qu'est ce que vous voulez acheter ?"))
RMenu.Add('shop', 'boisson', RageUI.CreateSubMenu(RMenu:Get('shop', 'main'), "Boisson", "Une petite soif ? "))
RMenu.Add('shop', 'nourriture', RageUI.CreateSubMenu(RMenu:Get('shop', 'main'), "Nourriture", "Une petie faim ?"))

local nourritureItem = {
    {value = 'bread', label = 'Pain', price = '50'}
}

local boissonItem = {
    {value = 'water', label = 'Eau', price = '50'}
}

local index = {
    items = 1
}

local actualPrice = 0

Citizen.CreateThread(function()
    while true do
        RageUI.IsVisible(RMenu:Get('shop', 'main'), true, true, true, function()

            RageUI.Button("Boisson", "Choisi ta Boisson !", {RightLabel = "→→→"},true, function()
            end, RMenu:Get('shop', 'boisson'))

            RageUI.Button("Nourriture", "Choisi ta Nourriture !", {RightLabel = "→→→"},true, function()
            end, RMenu:Get('shop', 'nourriture'))
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('shop', 'boisson'), true, true, true, function()
            for k, v in pairs(boissonItem) do 
                RageUI.List(v.label ..' (Prix : ' .. v.price .. '$)', Numbers, index.items, nil, { }, true, function(Hovered, Active, Selected, Index)
                    index.items = Index

                    if Selected then
                        local item = v.value
                        local count = Numbers[Index]
                        local price = v.price * count

                        TriggerServerEvent('xtu_shop:giveItem', v, count)
                    end
                end)
           end
        end, function()
        end)

        RageUI.IsVisible(RMenu:Get('shop', 'nourriture'), true, true, true, function()
            for k, v in pairs(nourritureItem) do 
                RageUI.List(v.label ..' (Prix : ' .. v.price .. '$)', Numbers, index.items, nil, { }, true, function(Hovered, Active, Selected, Index)
                    index.items = Index

                    if Selected then
                        local item = v.value
                        local count = Numbers[Index]
                        local price = v.price * count

                        TriggerServerEvent('xtu_shop:giveItem', v, count)
                    end
                end)
           end
        end, function()
        end, 1)
    
        Citizen.Wait(0)
    end
end)


local max = 10 -- number of items that can be selected
Numbers = {}
  
Citizen.CreateThread(function()
    for i = 1, max do
        table.insert(Numbers, i)
    end
end)
   


    ---------------------------------------- Position du Menu --------------------------------------------

    local position = {
        {x = 374.22,   y = 327.76,  z = 103.566},
        {x = -3040.98, y = 585.26,  z = 7.908},
        {x = 547.92,   y = 2669.41, z = 42.156},
        {x = 1960.37,  y = 3742.12, z = 32.343},
        {x = 1729.75,  y = 6416.18, z = 35.037},
        {x = -48.39,   y = -1757.86, z = 29.421},
        {x = 1163.50,  y = -323.85,  z = 69.205},
        {x = -707.39,  y = -914.54,  z = 19.215},
        {x = 1698.13,  y = 4924.443,  z = 42.063}
    }

    local peds = {
        {x = 24.50 , y = -1345.55, z = 28.49, angle = 267.25},
        {x = -47.02 , y = -1758.93, z = 28.42, angle = 48.47},
        {x = 372.72 , y = 328.15, z = 102.56, angle = 251.21},
        {x = -3040.51 , y = 583.86, z = 6.90, angle = 15.007},
        {x = 549.52 , y = 2669.60, z = 41.15, angle = 88.64},
        {x = 1959.05 , y = 3741.34, z = 31.34, angle = 295.43},
        {x = 1728.53 , y = 6416.89, z = 34.03, angle = 236.02},
        {x = 1165.17 , y = -323.58, z = 68.20, angle = 100.80},
        {x = 1959.05 , y = 3741.34, z = 31.34, angle = 295.43},
        {x = -706.03 , y = -914.67, z = 18.21, angle = 88.82},
        {x = 1697.13 , y = 4923.36, z = 41.06, angle = 329.00},
    }
    
    
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
    
            for k in pairs(position) do
    
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)
    
                if dist <= 1.0 then

                   RageUI.Text({
                        message = "Appuyez sur [~b~E~w~] pour parler a ~b~Apu",
                        time_display = 1
                    })
                   -- ESX.ShowHelpNotification("Appuyez sur [~b~E~w~] pour acceder au ~b~Shop")
                    if IsControlJustPressed(1,51) then
                        RageUI.Visible(RMenu:Get('shop', 'main'), not RageUI.Visible(RMenu:Get('example', 'main')))
                    end
                end
            end
        end
    end)

        -- Blips

        Citizen.CreateThread(function()
            for _, info in pairs(position) do
                info.blip = AddBlipForCoord(info.x, info.y, info.z)
                SetBlipSprite(info.blip, 52)
                SetBlipDisplay(info.blip, 4)
                SetBlipScale(info.blip, 0.9)
                SetBlipColour(info.blip, 2)
                SetBlipAsShortRange(info.blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Superette")
                EndTextCommandSetBlipName(info.blip)
            end
        end)
    
        -- Ped
    
        Citizen.CreateThread(function()
            for k in pairs(peds) do
        
                    local hash = GetHashKey("mp_m_shopkeep_01")
                    while not HasModelLoaded(hash) do
                        RequestModel(hash)
                        Wait(20)
                    end
        
                    ped = CreatePed("PED_TYPE_CIVMALE", "mp_m_shopkeep_01", peds[k].x, peds[k].y, peds[k].z, peds[k].angle, false, true)
                    SetBlockingOfNonTemporaryEvents(ped, true)
                    SetEntityInvincible(ped, true)
                    FreezeEntityPosition(ped, true)
            end
        end)