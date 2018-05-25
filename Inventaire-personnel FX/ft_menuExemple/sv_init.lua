require "resources/essentialmode/lib/MySQL"
MySQL:open("127.0.0.1", "gta5_gamemode_essential", "root", "1202")


RegisterServerEvent("poles")
AddEventHandler("poles", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 35) then
		TriggerClientEvent("pole", source)
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Pole Emploi ~h~~y~a été ajoutez à votre GPS")
		else
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Pole Emploi ~h~~y~a été ajoutez à votre GPS")
		end
	end)
end)

RegisterServerEvent("concepoints")
AddEventHandler("concepoints", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 35) then
		TriggerClientEvent("concepoint", source)
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Concessionnaire ~h~~y~a été ajoutez à votre GPS")
		else
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Concessionnaire ~h~~y~a été ajoutez à votre GPS")
		end
	end)
end)

RegisterServerEvent("hopis")
AddEventHandler("hopis", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 35) then
		TriggerClientEvent("hopi", source)
		TriggerClientEvent("project:notify", source, "~h~~y~Le point de ~h~~b~Hopital ~h~~y~a été ajoutez à votre GPS")
		else
		TriggerClientEvent("project:notify", source, "~h~~y~Le point de ~h~~b~Hopital ~h~~y~a été ajoutez à votre GPS")
		end
	end)
end)

RegisterServerEvent("comicos")
AddEventHandler("comicos", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 35) then
		TriggerClientEvent("comico", source)
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Commissariat ~h~~y~a été ajoutez à votre GPS")
		else
		TriggerClientEvent("project:notify", source, "~h~~y~Le point du ~h~~b~Commissariat ~h~~y~a été ajoutez à votre GPS")
		end
	end)
end)

RegisterServerEvent("suprs")
AddEventHandler("suprs", function()
	TriggerEvent("es:getPlayerFromId", source, function(target)
	    if (tonumber(target.money) >= 35) then
		TriggerClientEvent("supr", source)
		TriggerClientEvent("project:notify", source, "~h~~r~Le point sur le GPS a été supprimé")
		else
		TriggerClientEvent("project:notify", source, "~h~~r~Le point sur le GPS a été supprimé")
		end
	end)
end)

RegisterServerEvent("project:savelastpos")
AddEventHandler("project:savelastpos", function( LastPosX , LastPosY , LastPosZ , LastPosH )
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Formatage des données en JSON pour intégration dans MySQL.
		local LastPos = "{" .. LastPosX .. ", " .. LastPosY .. ",  " .. LastPosZ .. ", " .. LastPosH .. "}"
		--Exécution de la requêtes SQL.
		local executed_query = MySQL:executeQuery("UPDATE users SET `lastpos`='@lastpos' WHERE identifier = '@username'", {['@username'] = player, ['@lastpos'] = LastPos})
		--Affichage d'un message confirmant la sauvegarde de la position du joueurs.
		TriggerClientEvent("project:notify", source, "~h~~b~Position Sauvegardée")
	end)
end)


--Récupération de la position depuis MySQL
RegisterServerEvent("project:SpawnPlayer")
AddEventHandler("project:SpawnPlayer", function()
	TriggerEvent('es:getPlayerFromId', source, function(user)
		--Récupération du SteamID.
		local player = user.identifier
		--Exécution de la requêtes SQL.
		local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@username'", {['@username'] = player})
		--Récupération des données générée par la requête.
		local result = MySQL:getResults(executed_query, {'lastpos'}, "identifier")
		-- Vérification de la présence d'un résultat avant de lancer le traitement.
		if(result)then
			for k,v in ipairs(result)do
				if v.lastpos ~= "" then
				-- Décodage des données récupérées
				local ToSpawnPos = json.decode(v.lastpos)
				-- Intégration des données dans les variables dédiées
				local PosX = ToSpawnPos[1]
				local PosY = ToSpawnPos[2]
				local PosZ = ToSpawnPos[3]
				local PosH = ToSpawnPos[4]
				-- On envoie la derniere position vers le client pour le spawn
				TriggerClientEvent("project:spawnlaspos", source, PosX, PosY, PosZ)
				end
			end
		end
	end)
end)

-----------------------------------------------------------------------------------------------------------

function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end

function checkIfPhoneNumberAllreadyAssigned(phone_number)

    local executed_query = MySQL:executeQuery("SELECT phone_number FROM users WHERE phone_number = '@number'", { ['@number'] = phone_number })
    local result = MySQL:getResults(executed_query, { 'phone_number' })

    if (result[1] ~= nil) then
        return true
    end
    return false
end

function getPhoneRandomNumber()
    return math.random(10000000,99999999)
end

------------------------------------------------- CHECK/SET PHONE NUMBER -----------------------------------------------
------------------------------------------------------------------------------------------------------------------------

function checkNumber(number)
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE phone_number = '@number' LIMIT 1", { ['@number'] = number })
    local result = MySQL:getResults(executed_query, { 'identifier','nom'})
    if result then
        for _, v in ipairs(result) do
            return v
        end

    else
        return false
    end
end

AddEventHandler('es:playerLoaded',function(source)

    local executed_query = MySQL:executeQuery("SELECT phone_number FROM users WHERE identifier = '@username'", { ['@username'] = getPlayerID(source) })
    local result = MySQL:getResults(executed_query, { 'phone_number' })
    if (result[1].phone_number == "0") then
        local phone_number = getPhoneRandomNumber()
        phone_number = "06"..tostring(phone_number)
        if not checkIfPhoneNumberAllreadyAssigned(phone_number) then
            MySQL:executeQuery(  "UPDATE users SET phone_number='@number' WHERE identifier = '@identifier'",
                { ['@number'] = phone_number, ['@identifier'] = getPlayerID(source) })
            TriggerEvent("es:getPlayerFromId", source, function(user)

                TriggerClientEvent('phone:getPhoneNumberOnLoaded',source, phone_number)
            end)
        end
    else
        TriggerEvent("es:getPlayerFromId", source, function(user)
            TriggerClientEvent('phone:getPhoneNumberOnLoaded', source, user.phoneNumber)
        end)
    end
end)


RegisterServerEvent('phone:getSteamId')
AddEventHandler('phone:getSteamId', function()
    TriggerClientEvent('phone:setSteamId', source, getPlayerID(source))
end)

RegisterServerEvent("phone:addNewNumero")
AddEventHandler("phone:addNewNumero", function(number)
    local player = getPlayerID(source)
    local contact =  checkNumber(number)
    if not contact then
        TriggerClientEvent("phone:notifs", source, "~h~~r~Aucun contact trouvé")
    else
        if player == contact.identifier then
            TriggerClientEvent("phone:notifs", source, "~h~~g~Numéro ajouté" )
            CancelEvent()
        end
        local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist WHERE owner_id = '@username' AND contact_id = '@id' ", { ['@username'] = player, ['@id'] = contact.identifier })
        local result = MySQL:getResults(executed_query, { 'contact_id' })


        if(result[1] == nil) then
            MySQL:executeQuery("INSERT INTO user_phonelist (`owner_id`, `contact_id`) VALUES ('@owner', '@contact')",
                { ['@owner'] = player, ['@contact'] = contact.identifier })
            TriggerClientEvent("phone:notifs", source, "~h~~g~Numéro ajouté" )
            updateRepertory({source = source, player = player })
        else
            TriggerClientEvent("phone:notifs", source, " ~h~~y~".. contact.name .. "~h~~r~ existe déjà dans votre répertoire" )
        end
    end
end)

RegisterServerEvent("phone:checkContactServer")
AddEventHandler("phone:checkContactServer", function(identifier)
    local executed_query = MySQL:executeQuery("SELECT * FROM users WHERE identifier = '@id'", { ['@id'] = identifier.identifier })
    local result = MySQL:getResults(executed_query, { 'identifier', 'phone_number', 'prenom', 'nom' })

    if result[1] ~= nil then
        for _, v in ipairs(result) do
            TriggerClientEvent("phone:notifs", source, "~h~~s~" .. v.phone_number)
        end
    end
end)

function updateRepertory(player)
    numberslist = {}
    source = player.source
    local player = player.player
    local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist JOIN users ON `user_phonelist`.`contact_id` = `users`.`identifier` WHERE owner_id = '@username' ORDER BY nom ASC", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier','nom', 'contact_id'}, "contact_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { name= v.nom, identifier = v.identifier }
            table.insert(numberslist, v.identifier, t)
        end
    end
    TriggerClientEvent("phone:repertoryGetNumberListFromServer", source, numberslist)
end

local numberslist = {}
RegisterServerEvent("phone:repertoryGetNumberList")
AddEventHandler("phone:repertoryGetNumberList", function()
    numberslist = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_phonelist JOIN users ON `user_phonelist`.`contact_id` = `users`.`identifier` WHERE owner_id = '@username' ORDER BY nom ASC", { ['@username'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier','nom', 'prenom', 'contact_id'}, "contact_id")
    if (result) then
        for _, v in ipairs(result) do
            t = { name= v.nom..' '..v.prenom, identifier = v.identifier }
            table.insert(numberslist, v.identifier, t)
        end
    end
    TriggerClientEvent("phone:repertoryGetNumberListFromServer", source, numberslist)
end)

RegisterServerEvent('phone:deleteContact')
AddEventHandler('phone:deleteContact', function(contact)
    MySQL:executeQuery("DELETE FROM user_phonelist WHERE `owner_id` = '@owner' AND `contact_id`='@contact'", { ['@owner'] = getPlayerID(source), ['@contact'] = contact })
    TriggerClientEvent('phone:notifs', source, "~h~~g~Contact supprimé !" )
end)


----------------------------------------------- MESSAGERIE EVENTS ------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent("phone:sendNewMsg")
AddEventHandler("phone:sendNewMsg", function(msg)
    local sender = nil
    msg = {
        owner_id = getPlayerID(source),
        receiver = msg.receiver,
        msg = msg.msg
    }
    MySQL:executeQuery("INSERT INTO user_message (`owner_id`, `receiver_id`, `msg`, `has_read`) VALUES ('@owner', '@receiver', '@msg', '@read')",
        { ['@owner'] = msg.owner_id, ['@receiver'] = msg.receiver, ['@msg'] = msg.msg, ['@read'] = 0 })
    TriggerClientEvent("phone:notifs", source, "~h~~g~Message envoyé" )
    TriggerEvent('es:getPlayerFromId', source, function(sender)
         local SENDER = sender
         TriggerEvent("es:getPlayers", function(users)
             for k , user in pairs(users) do
                 if user.identifier == msg.receiver and k ~= source then
                     TriggerClientEvent("phone:notifsNewMsg", k, "~h~~s~Nouveau message de ~h~~y~" .. v.nom ..' '.. v.prenom)
                 end
             end
         end)
    end)

end)

local messagelist = {}
RegisterServerEvent("phone:messageryGetOldMsg")
AddEventHandler("phone:messageryGetOldMsg", function()
    -- TriggerClientEvent("phone:displayMsg", source)
    messagelist = {}
    local player = getPlayerID(source)
    local executed_query = MySQL:executeQuery("SELECT * FROM user_message JOIN users ON `user_message`.`owner_id` = `users`.`identifier` WHERE receiver_id = '@user' AND receiver_deleted='0' ORDER BY date DESC", { ['@user'] = player })
    local result = MySQL:getResults(executed_query, { 'identifier', 'nom', 'msg', 'date', 'has_read', 'owner_id','receiver_id', 'prenom'})
    local counter = 0
    if (result) then
        local USERS = {}
        for _, val in ipairs(result) do
            message = {
                msg = val.msg,
                name = val.nom .. ' ' .. val.prenom,
                identifier = val.identifier,
                date = tostring(val.date),
                has_read = val.has_read,
                owner_id = val.owner_id,
                receiver_id = val.receiver_id
            }
            messagelist[_] = message
            if val.has_read == 0 then
                counter = counter +1
            end
        end
        TriggerClientEvent("phone:nbMsgUnreaded", source, ''..counter..'')
    end
    TriggerClientEvent("phone:messageryGetOldMsgFromServer", source, messagelist)
end)


RegisterServerEvent("phone:setMsgReaded")
AddEventHandler("phone:setMsgReaded", function(msg)
    MySQL:executeQuery("UPDATE user_message SET `has_read` = 1 WHERE `receiver_id` = '@receiver' AND `msg` = '@msg' AND `has_read` = '@read' ", { ['@receiver'] = getPlayerID(source), ['@msg'] = msg.msg, ['@read'] = msg.has_read })
end)

RegisterServerEvent('phone:deleteMsg')
AddEventHandler('phone:deleteMsg', function(msg)
    MySQL:executeQuery("DELETE FROM user_message WHERE  owner_id='@owner' AND receiver_id='@receiver' AND msg='@msg' AND has_read=1 AND receiver_deleted=0 LIMIT 1", { ['@owner'] = msg.owner, ['@receiver'] = msg.receiver, ['@msg'] =  msg.msg })
    TriggerClientEvent('phone:notifs', source, "~h~~g~ Message supprimé !" )
end)


RegisterServerEvent('phone:deleteAllMsg')
AddEventHandler('phone:deleteAllMsg', function()
    MySQL:executeQuery("DELETE FROM user_message WHERE receiver_id='@receiver'", { ['@receiver'] = getPlayerID(source) })
    TriggerClientEvent('phone:notifs', source, "~h~~g~ Messagerie vidée!" )
end)
----------------------------------------------- RESET MEMORY EVENTS ----------------------------------------------------
------------------------------------------------------------------------------------------------------------------------

RegisterServerEvent('phone:resetPhone')
AddEventHandler('phone:resetPhone', function()
    MySQL:executeQuery("DELETE FROM user_phonelist WHERE `owner_id` = '@id'", { ['@id'] = getPlayerID(source)})
    MySQL:executeQuery("DELETE FROM user_message WHERE `receiver_id` = '@receiver'", { ['@receiver'] = getPlayerID(source)})
    TriggerClientEvent('phone:notifs', source, "~h~~g~Téléphone remis à zéro !")
    TriggerClientEvent("phone:repertoryGetNumberList", source)
    TriggerClientEvent("phone:messageryGetOldMsg", source)

end)


function TransformerTimeStamp(Value)
    if type(Value) == "userdata" then
        local netType = tostring(Value.GetType())

        if netType == "System.DateTime" then
            return Value.ToUniversalTime().Subtract(clr.System.DateTime(1970, 1, 1)).TotalSeconds
        end

        if netType == "System.Double" then
            return tonumber(tostring(Value))
        end

        if netType == "System.Decimal" then
            return tonumber(tostring(Value))
        end

        if netType == "System.Int32" or netType == "System.UInt32" then
            return tonumber(tostring(Value))
        end

        if netType == "System.Int64" or netType == "System.UInt64" then
            return tonumber(tostring(Value))
        end

        if netType == "System.Boolean" then
            return toboolean(tostring(Value))
        end

        return tostring(Value)
    end
    return Value
end
function MyConvertFieldValue(MysqlDataReader, index)
    if MysqlDataReader.IsDBNull(index) then
        return nil
    end

    -- Some date time cannot be parsed like 0000-01-01
    local status, data = pcall(MysqlDataReader.GetValue, index)

    if status then
        return TransformerTimeStamp(data)
    end

    return nil
end

function MyConvertResultToTable(MySqlDataReader)
    local result = {}

    while MySqlDataReader:Read() do
        local line = {}

        for i=0,MySqlDataReader.FieldCount-1 do
            line[MySqlDataReader.GetName(i)] = MyConvertFieldValue(MySqlDataReader, i);
        end

        result[#result+1] = line;
    end

    MySqlDataReader.Close()
    MySqlDataReader.Dispose()

    return result;
end

function MySQLQueryTimeStamp(query, params)
    local Command = MySQL.Utils.CreateCommand(query, params)
    return MySQL.Sync.wrapQuery(Command.ExecuteReader, Command.Connection, Command.CommandText, MyConvertResultToTable)
end

--------------------------------------------------------------------------------------------------------------------------
