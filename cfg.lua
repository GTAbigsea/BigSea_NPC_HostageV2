Cfg = {} or Cfg

Cfg.Framework = 'esx' -- qbcore, esx or custom

Cfg.CustomNotify = false

Cfg.Percentage = 20

Cfg.Language = 'zh'

Cfg.KillKey = 38 -- E
Cfg.KneelKey = 194 -- BACKSPACFE

Cfg.CustomMenu = false

Cfg.MaxHostages = 5 -- 最大可拥有的人质数量
Cfg.DistanceToEscape = 30.0 -- 人质需要距离玩家多远才能逃跑

function GetCoreObject()
    --return YOUR_OWN_CORE_EXPORT
end

function openMenu(entity)
    lib.registerContext({
        id = 'hostageped',
        title = '有什么可以帮您的？',
        options = {
            {
                title = '释放',
                icon = 'fa-solid fa-person-running',
                onSelect = function()
                    release(entity)
                end
            },
            {
                title = '跟随我',
                icon = 'fa-solid fa-person-walking-arrow-right',
                onSelect = function()
                    follow(entity)
                end
            },
            {
                title = '待在这里',
                icon = 'fa-solid fa-person-praying',
                onSelect = function()
                    kneel(entity)
                end
            },
            {
                title = '拿住他的脖子',
                icon = 'fa-solid fa-gun',
                onSelect = function()
                    threaten(entity)
                end
            },
        }
    })
    -- 让这些功能生效
    -- release(entity)
    -- follow(entity)
    -- kneel(entity)
    -- threaten(entity)
    lib.showContext('hostageped')
end

function ShowHelpNotification(key, msg, entity)
    -- 如果你想使用自定义通知，就在这里添加你的代码
end

function HideHelpNotification()
    if Cfg.Framework == "qbcore" then 
        return exports['qb-core']:HideText()
    end
    -- 如果你想使用自定义通知，就在这里添加你的代码
end

-- @param msg 字符串
function ShowNotification(msg)
    if not Cfg.CustomNotify then
        if Cfg.Framework == "qbcore" then
            Framework.Functions.Notify(msg, "primary")
        elseif Cfg.Framework == "esx" then
            Framework.ShowNotification(msg)
        end
    else
        -- 如果你想使用自定义通知，就在这里添加你的代码
    end
end

function sendPoliceAlert(coords)
    TriggerServerEvent("SendAlert:police", {
        coords = coords,
        title = "绑架尝试",
        description = "一名持枪者正试图绑架某人，请帮忙！！",
        job = "police"
    })
end

function CanKillNPC()
    -- 你的代码来检查玩家是否可以杀死 NPC
    return true
end

Cfg.Translations = {
    ['es'] = {
        ['someter'] = '~y~E~w~ Someter',
        ['Matar'] = {
            ['kill'] = 'Matar', -- 仅当你使用 BigSea_notify 时
            ['kneel'] = 'Volver a arrodillar', -- 仅当你使用 BigSea_notify 时
            ['fullText'] = '[E] Matar | [Backspace] Volver a arrodillar',
        },
        ['ignored'] = 'El civil ha ignorado tu amenaza',
        ['hostage_options'] = 'Opciones de rehén',
        ['release_hostage'] = 'Liberar rehén',
        ['release_hostage_desc'] = 'Deja al rehén libre',
        ['follow_hostage'] = 'Sigueme',
        ['follow_hostage_desc'] = 'Ordena al rehén que te siga',
        ['kneel_hostage'] = 'Arrodillate',
        ['kneel_hostage_desc'] = 'Ordena al rehén que se arrodille',
        ['threat_hostage'] = 'Amenzar',
        ['threat_hostage_desc'] = 'Amenaza al rehén con un arma en el cuello',
        ['max_hostages'] = 'No puedes tener más rehenes',
    },
    ['en'] = {
        ['someter'] = '~y~E~w~ Subdue',
        ['Matar'] = {
            ['kill'] = 'Kill',-- 仅当你使用 BigSea_notify 时
            ['kneel'] = 'Return to kneeling',-- 仅当你使用 BigSea_notify 时
            ['fullText'] = '[E] Kill  | [Backspace] Return to kneeling',
        },
        ['ignored'] = 'The civilian ignored your threat',
        ['hostage_options'] = 'Hostage options',
        ['release_hostage'] = 'Release hostage',
        ['release_hostage_desc'] = 'Set the hostage free',
        ['follow_hostage'] = 'Follow me',
        ['follow_hostage_desc'] = 'Order the hostage to follow you',
        ['kneel_hostage'] = 'Kneel',
        ['kneel_hostage_desc'] = 'Order the hostage to kneel',
        ['threat_hostage'] = 'Threaten',
        ['threat_hostage_desc'] = 'Threaten the hostage with a weapon at the neck',
        ['max_hostages'] = 'You can\'t have more hostages',
    },
    ['it'] = {
        ['someter'] = '~y~E~w~ Sottomettere',
        ['Matar'] = {
            ['kill'] = 'Uccidi', -- 仅当你使用 BigSea_notify 时
            ['kneel'] = 'Torna a far inginocchiare', -- 仅当你使用 BigSea_notify 时
            ['fullText'] = '[E] Uccidi | [Backspace] Torna a far inginocchiare',
        },
        ['ignored'] = 'Il civile ha ignorato la tua minaccia',
        ['hostage_options'] = 'Opzioni ostaggio',
        ['release_hostage'] = 'Liberare ostaggio',
        ['release_hostage_desc'] = "Lascia libero l'ostaggio",
        ['follow_hostage'] = 'Segui ostaggio',
        ['follow_hostage_desc'] = "Ordina all'ostaggio di seguirti",
        ['kneel_hostage'] = 'Fai inginocchiare ostaggio',
        ['kneel_hostage_desc'] = "Ordina all'ostaggio di inginocchiarsi",
        ['threat_hostage'] = 'Minaccia ostaggio',
        ['threat_hostage_desc'] = "Minaccia l'ostaggio con un'arma al collo",
        ['max_hostages'] = 'Non puoi avere più ostaggi',
    },
    ['zh'] = {
        ['someter'] = '~y~E~w~ 控制',
        ['Matar'] = {
            ['kill'] = '杀死', -- 仅当你使用 BigSea_notify 时
            ['kneel'] = '恢复跪姿', -- 仅当你使用 BigSea_notify 时
            ['fullText'] = '[E] 杀死  | [Backspace] 恢复跪姿',
        },
        ['ignored'] = '平民无视了你的威胁',
        ['hostage_options'] = '人质选项',
        ['release_hostage'] = '释放人质',
        ['release_hostage_desc'] = '让人质自由',
        ['follow_hostage'] = '跟随我',
        ['follow_hostage_desc'] = '命令人质跟随你',
        ['kneel_hostage'] = '跪下',
        ['kneel_hostage_desc'] = '命令人质跪下',
        ['threat_hostage'] = '威胁',
        ['threat_hostage_desc'] = '用武器威胁人质的脖子',
        ['max_hostages'] = '你不能再拥有更多人质',
    },
}

Cfg.Translations = Cfg.Translations[Cfg.Language] -- 不要触碰这行
