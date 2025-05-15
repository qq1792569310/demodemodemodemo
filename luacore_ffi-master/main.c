#define _CRT_SECURE_NO_WARNINGS
#include <windows.h>
#include "MinHook.h"
#include "lua.h"
#include "lauxlib.h"

int luaopen_ffi(lua_State* L);

int frist = 0;
int (*old_lua_pcallk)(lua_State* L, int nargs, int nresults, int errfunc, int ctx, int k);
int my_lua_pcallk(lua_State* L, int nargs, int nresults, int errfunc, int ctx, int k) {
	if (frist == 0) {
		frist = 1;
		luaL_requiref(L, "ffi", luaopen_ffi, 0);
		lua_pop(L, 1);
	}
	return old_lua_pcallk(L, nargs, nresults, errfunc, ctx, k);
}

int luaopen_ffi2() {
	HMODULE luacore = GetModuleHandleW(L"luacore.dll");
	if (luacore) {
		void* lua_pcallk = GetProcAddress(luacore, "lua_pcallk");
		if (lua_pcallk) {
			MH_Initialize();
			MH_CreateHook(lua_pcallk, my_lua_pcallk, (LPVOID*)&old_lua_pcallk);
			MH_EnableHook(lua_pcallk);
			return 1;
		}
	}
	return 0;
}
