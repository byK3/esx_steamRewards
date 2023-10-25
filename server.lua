local claimedRewards = {}

RegisterCommand(Config.command, function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local steamName = GetPlayerName(source)

    if Config.dailyReward then
        local xIdentifier = xPlayer.identifier
        MySQL.Async.fetchAll('SELECT last_claimed FROM k3_steamRewards WHERE identifier = @identifier', {
            ['@identifier'] = xIdentifier
        }, function(result)
            local lastClaimed = result[1] and result[1].last_claimed or nil

            if lastClaimed and os.date('%d.%m.%Y') <= lastClaimed then
                Notify(xPlayer.source, Config.lang["already_claimed"])
            else
                if string.match(steamName, Config.serverName) then
                    giveReward(xPlayer.source)
                    MySQL.Async.execute('REPLACE INTO k3_steamRewards (identifier, last_claimed) VALUES (@identifier, @today)', {
                        ['@identifier'] = xIdentifier,
                        ['@today'] = os.date('%d.%m.%Y')
                    })
                    Notify(xPlayer.source, Config.lang["claimed"])
                else
                    Notify(xPlayer.source, Config.lang["wrong_name"])
                end
            end
        end)
    else
        if not claimedRewards[xPlayer.identifier] then
            if string.match(steamName, Config.serverName) then
                giveReward(xPlayer.source)
                claimedRewards[xPlayer.identifier] = true
            else
                Notify(xPlayer.source, Config.lang["wrong_name"])
            end
        else
            Notify(xPlayer.source, Config.lang["already_claimed"])
        end
    end
end)

function giveReward(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    if Config.reward.type == "money" then
        xPlayer.addMoney(Config.reward.value) 
    elseif Config.reward.type == "item" then
        xPlayer.addInventoryItem(Config.reward.value, Config.reward.count)
    elseif Config.reward.type == "weapon" then
        xPlayer.addWeapon(Config.reward.value, Config.reward.count)
    end
    Notify (xPlayer.source, string.format(Config.lang["claimed"]))

    if Config.discordLogs then
        sendToDiscord("CLAIMED REWARD", "Player **" .. xPlayer.name .. "** claimed the reward **" .. Config.reward.value ..  "**") -- first string is the title, second string is the message
    end
end


function sendToDiscord(name, message)
    local embed = {
        {
            ["color"] = 65280, -- RED = 16711680 --- GREEN = 65280 --- BLUE = 2061822
            ["title"] = "**" .. name .. "**",
            ["description"] = message,
            ["footer"] = {
                ["text"] = "K3 Steam Rewards System",
            },
        }
    }

    PerformHttpRequest(Config.discordWebhook, function(err, text, headers) end, 'POST', json.encode({embeds = embed}), { ['Content-Type'] = 'application/json' })
end
