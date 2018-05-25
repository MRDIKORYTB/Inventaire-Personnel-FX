--
-- Created by IntelliJ IDEA.
-- User: Djyss
-- Date: 09/05/2017
-- Time: 09:55
-- To change this template use File | Settings | File Templates.
--




local options = {
    x = 0.1,
    y = 0.2,
    width = 0.2,
    height = 0.04,
    scale = 0.4,
    font = 0,
    menu_title = "Inventaire Personnel",
    menu_subtitle = "Categories",
    color_r = 30,
    color_g = 144,
    color_b = 255,
}


--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- register events, only needs to be done once
RegisterNetEvent("item:reset")
RegisterNetEvent("item:getItems")
RegisterNetEvent("item:updateQuantity")
RegisterNetEvent("item:setItem")
RegisterNetEvent("item:sell")
RegisterNetEvent("gui:getItems")
RegisterNetEvent("player:receiveItem")
RegisterNetEvent("player:looseItem")
RegisterNetEvent("player:sellItem")

ITEMS = {}
local playerdead = false
local maxCapacity = 64

-- handles when a player spawns either from joining or after death
AddEventHandler("playerSpawned", function()
    TriggerServerEvent("item:getItems")
    -- reset player dead flag
    playerdead = false
end)

AddEventHandler("gui:getItems", function(THEITEMS)
    ITEMS = {}
    ITEMS = THEITEMS
end)

AddEventHandler("player:receiveItem", function(item, quantity)
    if (inventoryGetPods() + quantity <= maxCapacity) then
        item = tonumber(item)
        if (ITEMS[item] == nil) then
            inventoryNew(item, quantity)
        else
            inventoryAdd({ item, quantity })
        end
    end
end)

AddEventHandler("player:looseItem", function(item, quantity)
    item = tonumber(item)
    if (ITEMS[item].quantity >= quantity) then
        inventoryDelete({ item, quantity })
    end
end)

AddEventHandler("player:sellItem", function(item, price)
    item = tonumber(item)
    if (ITEMS[item].quantity > 0) then
        inventorySell({ item, price })
    end
end)

-- Menu de l'inventaire
function inventoryMenu()
    ped = GetPlayerPed(-1);
    options.menu_subtitle = "Items  "
    options.rightText = (inventoryGetPods() or 0) .. "/" .. maxCapacity
    ClearMenu()
    for ind, value in pairs(ITEMS) do
        if (value.quantity > 0) then
            Menu.addButton(tostring(value.quantity) .. " " ..tostring(value.libelle), "inventoryItemMenu", ind)
        end
    end
end

function inventoryItemMenu(itemId)
    ClearMenu()
    options.menu_subtitle = "Details "
    Menu.addButton("Utiliser", "use", itemId)
    Menu.addButton("Ouvrir", "lire", itemId) 
    Menu.addButton("Supprimer", "inventoryDelete", {itemId , 1})    
end

function use(item)
	TriggerServerEvent("item:updateQuantity", 1, item)
    if (ITEMS[item].quantity - 1 >= 0) then
        if ITEMS[item].type == 3 then
            rien(itemId)
        elseif ITEMS[item].type == 4 then
        	smoke(itemId)
        	TriggerEvent("player:looseItem", item, 1)  
        elseif ITEMS[item].type == 0 then
        	rien(itemId)
        elseif ITEMS[item].type == 2 then
            TriggerEvent("food:eat", ITEMS[item])
            TriggerEvent("player:looseItem", item, 1)   
        elseif ITEMS[item].type == 1 then
            TriggerEvent("food:drink", ITEMS[item])
            TriggerEvent("player:looseItem", item, 1) 
        else 
			Toxicated()
       	    Citizen.Wait(7000)
        	ClearPedTasks(GetPlayerPed(-1))
       	    Reality()	
      	end
    end
end


function smoke(item)
    local pid = PlayerPedId()
    RequestAnimDict("amb@world_human_leaning@male@wall@back@smoking@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_leaning@male@wall@back@smoking@idle_a")) do Citizen.Wait(0) end
    TaskPlayAnim(pid, 'amb@world_human_leaning@male@wall@back@smoking@idle_a', 'idle_a', 50.0, -50.0, -2, 0, 0, false, false, false)
    TriggerEvent("player:consumeItem", "smoke", 20)
end

function drink(item)
    local pid = PlayerPedId()
    RequestAnimDict("amb@world_human_drinking@coffee@male@idle_a")
    while (not HasAnimDictLoaded("amb@world_human_drinking@coffee@male@idle_a")) do Citizen.Wait(0) end
    TaskPlayAnim(pid, 'amb@world_human_drinking@coffee@male@idle_a', 'idle_a', 1.0, -1.0, 2000, 0, 1, true, true, true)
    TriggerEvent("player:consumeItem", "drink", 10)
end

function rien(item)
    TriggerEvent("project:notify", "~h~~s~Erreur : ~h~~r~Cet objet n'est pas utilisable")
    ClearMenu()
    inventoryMenu()
end

function lire(item)
	Menu.hidden = not Menu.hidden
    if ITEMS[item].type == 3 then
            test(itemId)
        elseif ITEMS[item].type == 2 then
            rien(itemId)       
        elseif ITEMS[item].type == 1 then
            rien(itemId)       
        else 
  		Toxicated()
        Citizen.Wait(7000)
        ClearPedTasks(GetPlayerPed(-1))
       	Reality()
    end
end

function test(item)
    TriggerEvent('phone:toggleMp3')
end

function inventorySell(arg)
    local itemId = tonumber(arg[1])
    local price = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - 1
    TriggerServerEvent("item:sell", itemId, item.quantity, price)
    inventoryMenu()
end

function inventoryDelete(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity - qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    inventoryMenu()
end

function inventoryAdd(arg)
    local itemId = tonumber(arg[1])
    local qty = arg[2]
    local item = ITEMS[itemId]
    item.quantity = item.quantity + qty
    TriggerServerEvent("item:updateQuantity", item.quantity, itemId)
    InventoryMenu()
end

function inventoryNew(item, quantity)
    TriggerServerEvent("item:setItem", item, quantity)
    TriggerServerEvent("item:getItems")
end

function inventoryGetQuantity(itemId)
    return ITEMS[tonumber(itemId)].quantity
end

function inventoryGetPods()
    local pods = 0
    for _, v in pairs(ITEMS) do
        pods = pods + v.quantity
    end
    return pods
end

function notFull()
    if (inventoryGetPods() < maxCapacity) then return true end
end

function PlayerIsDead()
    -- do not run if already ran
    if playerdead then
        return
    end
    TriggerServerEvent("item:reset")
end

function getPlayers()
    local playerList = {}
    for i = 0, 32 do
        local player = GetPlayerFromServerId(i)
        if NetworkIsPlayerActive(player) then
            table.insert(playerList, player)
        end
    end
    return playerList
end

function getNearPlayer()
    local players = getPlayers()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local pos2
    local distance
    local minDistance = 3
    local playerNear
    for _, player in pairs(players) do
        pos2 = GetEntityCoords(GetPlayerPed(player))
        distance = GetDistanceBetweenCoords(pos["x"], pos["y"], pos["z"], pos2["x"], pos2["y"], pos2["z"], true)
        if (pos ~= pos2 and distance < minDistance) then
            playerNear = player
            minDistance = distance
        end
    end
    if (minDistance < 3) then
        return playerNear
    end
end

------------------------------------------------------------------------------------------------------------------------
wearingHat = true
wearingGlasses = true
wearingPercing = true
wearingMask = true
-- Menu Accessoires
function accessoriesMenu()
    options.menu_subtitle = "Accessoires"
    ClearMenu()
    Menu.addButton("Porter ou Retirer chapeaux", "accessoriesWearHatChecker")
    Menu.addButton("Porter ou Retirer lunette", "accessoriesWearGlassesChecker")
    Menu.addButton("Porter ou Retirer percing", "accessoriesWearPercingChecker")
    Menu.addButton("Porter ou Retirer cagoule/mask", "accessoriesWearMaskChecker")
    Menu.addButton("Retour","PersonnalMenu",nil)
end

RegisterNetEvent("pm:accessoriesWearHat")
AddEventHandler("pm:accessoriesWearHat", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 0, item.helmet,item.helmet_txt, 0)
end)
function accessoriesWearHatChecker()
    if wearingHat then
        wearingHat = false
        ClearPedProp(GetPlayerPed(-1),0)
    else
        wearingHat = true
        TriggerServerEvent("pm:wearHat")
    end

end

RegisterNetEvent("pm:accessoriesWearPercing")
AddEventHandler("pm:accessoriesWearPercing", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 2, item.percing,item.percing_txt, 0)
end)
function accessoriesWearPercingChecker()
    if wearingGlasses then
        wearingGlasses = false
        ClearPedProp(GetPlayerPed(-1),2)
    else
        wearingGlasses = true
        TriggerServerEvent("pm:wearPercing")
    end

end

RegisterNetEvent("pm:accessoriesWearGlasses")
AddEventHandler("pm:accessoriesWearGlasses", function(item)
    SetPedPropIndex(GetPlayerPed(-1), 1, item.glasses,item.glasses_txt, 0)
end)
function accessoriesWearGlassesChecker()
    if wearingPercing then
        wearingPercing = false
        ClearPedProp(GetPlayerPed(-1),1)
    else
        wearingPercing = true
        TriggerServerEvent("pm:wearGlasses")
    end

end

RegisterNetEvent("pm:accessoriesWearMask")
AddEventHandler("pm:accessoriesWearMask", function(item)
    SetPedComponentVariation(GetPlayerPed(-1), 1, item.mask,item.mask_txt, 0)
end)
function accessoriesWearMaskChecker()
    if wearingMask then
        wearingMask = false
        SetPedComponentVariation(GetPlayerPed(-1), 1, 0, 0)
    else
        wearingMask = true
        TriggerServerEvent("pm:wearMask")
    end

end

------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
		if(not IsPedInAnyVehicle(GetPlayerPed(-1), false))then
        if IsControlJustPressed(1, 289) then
            inventoryMenu() -- Menu to draw
            Menu.hidden = not Menu.hidden -- Hide/Show the menu
        end
        Menu.renderGUI(options) -- Draw menu on each tick if Menu.hidden = false
        if IsEntityDead(PlayerPedId()) then
            PlayerIsDead()
            -- prevent the death check from overloading the server
            playerdead = true
			else
			end
        end
    end
end)

------------------------------------------------------------------------------------------------------------------------
