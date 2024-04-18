fx_version "cerulean"
author 'BigSea 雷公制作'
lua54 'yes'
game "gta5"

client_scripts {
    '@ox_lib/init.lua', -- 如果你想使用 ox_lib 接口，请取消注释
    'client/npc_hostage.lua',
    'cfg.lua',
}

escrow_ignore {
    'cfg.lua',
}

dependency '/assetpacks'
dependency '/assetpacks'