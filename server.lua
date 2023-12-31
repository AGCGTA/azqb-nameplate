local QBCore = exports['qb-core']:GetCoreObject()
local hidePlayers = {}
local players = {}

QBCore.Commands.Add("nameplate", Lang:t("commands.nameplate_description"), {}, false, function(source)
    if hidePlayers[source] ~= nil then
        hidePlayers[source] = nil
        TriggerClientEvent('azqb-nameplate:client:show', source, true)
    else
        hidePlayers[source] = true
        TriggerClientEvent('azqb-nameplate:client:show', source, false)
    end

    TriggerClientEvent('azqb-nameplate:client:sync', -1, hidePlayers, players)
end)

RegisterNetEvent("QBCore:Server:OnPlayerUnload", function(source)
    hidePlayers[source] = nil
end)

CreateThread(function()
    while true do
        local tempPlayers = {}
        for _, v in pairs(QBCore.Functions.GetPlayers()) do
            local ped = QBCore.Functions.GetPlayer(v)
            tempPlayers[#tempPlayers + 1] = {
                id = v,
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