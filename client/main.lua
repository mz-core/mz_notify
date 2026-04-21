local RESOURCE_NAME = GetCurrentResourceName()

local function debugLog(msg)
    if Config.Debug then
        print(('[%s][client] %s'):format(RESOURCE_NAME, msg))
    end
end

local function normalizeType(notifyType)
    if type(notifyType) ~= 'string' then
        return 'info'
    end

    notifyType = notifyType:lower()

    if not Config.Types[notifyType] then
        return 'info'
    end

    return notifyType
end

local function normalizePosition(position)
    if type(position) ~= 'string' then
        return Config.DefaultPosition
    end

    if not Config.Positions[position] then
        return Config.DefaultPosition
    end

    return position
end

local function normalizeDuration(duration)
    duration = tonumber(duration)
    if not duration or duration < 1000 then
        return Config.DefaultDuration
    end

    return math.floor(duration)
end

local function normalizePayload(data)
    data = type(data) == 'table' and data or {}

    return {
        action = 'notify',
        payload = {
            type = normalizeType(data.type),
            title = tostring(data.title or Config.DefaultTitle),
            message = tostring(data.message or ''),
            duration = normalizeDuration(data.duration),
            position = normalizePosition(data.position),
            persistent = data.persistent == true,
            progress = data.progress ~= false,
            id = data.id and tostring(data.id) or nil,
            icon = data.icon and tostring(data.icon) or nil,
            maxVisible = Config.MaxVisible
        }
    }
end

local function fallbackPrint(payload)
    if not Config.EnableFallbackPrint then
        return
    end

    print(('[%s][%s] %s - %s'):format(
        RESOURCE_NAME,
        payload.type or 'info',
        payload.title or Config.DefaultTitle,
        payload.message or ''
    ))
end

local function showNotify(data)
    local nuiData = normalizePayload(data)
    SendNUIMessage(nuiData)
    fallbackPrint(nuiData.payload)
end

exports('Notify', function(data)
    showNotify(data)
end)

RegisterNetEvent('mz_notify:client:show', function(data)
    showNotify(data)
end)

RegisterCommand('mnotifylocal', function(_, args)
    local notifyType = args[1] or 'info'

    showNotify({
        type = notifyType,
        title = 'Teste local',
        message = ('Notify local do tipo "%s".'):format(notifyType),
        duration = 5000
    })
end, false)

CreateThread(function()
    debugLog('client carregado')
end)