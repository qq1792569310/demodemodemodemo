local console = require('jass.console')
local runtime = require('jass.runtime')
console.enable = true
print = console.write

runtime.sleep = false
runtime.handle_level = 2
runtime.error_handle = function(msg)
    print(tostring(msg) .. "\n" .. debug.traceback())
end

package.path = package.path .. ";"
    .. "?\\init.lua;"
    .. "scripts\\?.lua;"
    .. "scripts\\?\\init.lua;"

local jass = require('jass.common')
local trg = jass.CreateTrigger()
jass.TriggerRegisterPlayerChatEvent(trg, jass.Player(0), "", true)
jass.TriggerAddAction(trg, function()
    local ffi = require('ffi')
    print('ffi', ffi)

    ffi.cdef [[
        // 基本类型
        typedef void* HANDLE;
        typedef const char* LPCSTR;
        typedef int BOOL;

        // Kernel32.dll 函数
        HANDLE GetModuleHandleA(LPCSTR lpModuleName);
        HANDLE GetProcAddress(HANDLE hModule, LPCSTR lpProcName);

        int MessageBoxA(void* hWnd, const char* lpText, const char* lpCaption, unsigned int uType);
    ]]

    local Game = ffi.C.GetModuleHandleA('Game.dll')
    local GameMain = ffi.C.GetProcAddress(Game, 'GameMain')
    print('Game', Game)
    print('GameMain', GameMain)
    ffi.C.MessageBoxA(0, ('Game = %s\nGameMain = %s\n'):format(Game, GameMain), 'Hello', 0)
end)
