local items = {}

RegisterServerEvent("item:getItems")
AddEventHandler("item:getItems", function()
    items = {}
	local player = GetPlayerIdentifiers(source)[1]
	local source = source
	local result = MySQL.Sync.fetchAll("SELECT quantity,libelle,item_id FROM user_inventory JOIN items ON `user_inventory`.`item_id` = `items`.`id` WHERE user_id = @username", { ['@username'] = player})
	for k, v in pairs(result) do
		items[tonumber(v.item_id)] = { quantity = v.quantity, libelle = v.libelle, itemid = v.item_id}
	end
    TriggerClientEvent("gui:getItems", source, items)
end)

RegisterServerEvent("item:setItem")
AddEventHandler("item:setItem", function(item, quantity)
	local player = GetPlayerIdentifiers(source)[1]
    MySQL.Sync.execute("INSERT INTO user_inventory (user_id, item_id, quantity) VALUES (@player, @item, @qty)", { ['@player'] = player, ['@item'] = item, ['@qty'] = quantity })
end)

RegisterServerEvent("item:updateQuantity")
AddEventHandler("item:updateQuantity", function(qty, id)
	local player = GetPlayerIdentifiers(source)[1]
    MySQL.Sync.execute("UPDATE user_inventory SET quantity = @qty WHERE user_id = @username AND item_id = @id", { ['@username'] = player, ['@qty'] = tonumber(qty), ['@id'] = tonumber(id) })
end)

RegisterServerEvent("item:reset")
AddEventHandler("item:reset", function()
	local player = GetPlayerIdentifiers(source)[1]
	MySQL.Sync.execute("UPDATE user_inventory SET quantity = 0 WHERE user_id = @username", { ['@username'] = player})
end)

------------------------------------------------------------------------------------------------------------------------
