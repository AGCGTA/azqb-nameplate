local QBCore = exports['qb-core']:GetCoreObject()
local hidePlayers = {}
local players = {}

QBCore.Commands.Add("nameplate", Lang:t("commands.nameplate_description"), {}, false, function(source)
    local player = QBCore.Functions.GetPlayer(source)
    if hidePlayers[player.PlayerData.citizenid] ~= nil then
        hidePlayers[player.PlayerData.citizenid] = nil
        TriggerClientEvent('azqb-nameplate:client:show', source, true)
    else
        hidePlayers[player.PlayerData.citizenid] = true
        TriggerClientEvent('azqb-nameplate:client:show', source, false)
    end

    TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, players)
end)

RegisterNetEvent("QBCore:Server:OnPlayerUnload", function(source)
    local player = QBCore.Functions.GetPlayer(source)
    hidePlayers[player.PlayerData.citizenid] = nil
end)

CreateThread(function()
    while true do
        local tempPlayers = {}
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local ped = QBCore.Functions.GetPlayer(v)
            tempPlayers[#tempPlayers + 1] = {
                id = v,
                cid = ped.PlayerData.citizenid,
                name = ped.PlayerData.charinfo.firstname .. ' ' .. ped.PlayerData.charinfo.lastname,
            }
        end

        table.sort(tempPlayers, function(a, b)
            return a.id < b.id
        end)
        players = tempPlayers
        TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, players)
        Wait(1500)
    end
end)