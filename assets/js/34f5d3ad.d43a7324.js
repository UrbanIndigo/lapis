"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[389],{59298:e=>{e.exports=JSON.parse('{"functions":[{"name":"setConfig","desc":"```lua\\nLapis.setConfig({\\n\\tretryAttempts = 10,\\n\\tshowRetryWarnings = false,\\n})\\n```\\n\\n```lua\\n-- The default config values:\\n{\\n\\tretryAttempts = 5,\\n\\tacquireLockAttempts = 20,\\n\\tacquireLockDelay = 1,\\n\\tshowRetryWarnings = true,\\n\\tdataStoreService = DataStoreService,\\n}\\n```","params":[{"name":"values","desc":"","lua_type":"ConfigValues"}],"returns":[],"function_type":"static","source":{"line":42,"path":"src/init.lua"}},{"name":"createCollection","desc":"Creates a [Collection].","params":[{"name":"name","desc":"","lua_type":"string"},{"name":"options","desc":"","lua_type":"CollectionOptions"}],"returns":[{"desc":"","lua_type":"Collection"}],"function_type":"static","source":{"line":61,"path":"src/init.lua"}}],"properties":[],"types":[{"name":"ConfigValues","desc":"","fields":[{"name":"retryAttempts","lua_type":"number?","desc":"Max save/close retry attempts"},{"name":"acquireLockAttempts","lua_type":"number?","desc":"Max lock acquire retry attempts"},{"name":"acquireLockDelay","lua_type":"number?","desc":"Seconds between lock acquire attempts"},{"name":"showRetryWarnings","lua_type":"boolean?","desc":"Show warning on retry"},{"name":"dataStoreService","lua_type":"(DataStoreService | table)?","desc":"Useful for mocking DataStoreService, especially in a local place"}],"source":{"line":20,"path":"src/init.lua"}},{"name":"CollectionOptions","desc":"","fields":[{"name":"validate","lua_type":"(any) -> (boolean, string?)","desc":"Takes a document\'s data and returns a success boolean and an error message if it fails."},{"name":"defaultData","lua_type":"any","desc":""},{"name":"migrations","lua_type":"{ (any) -> any }","desc":"Migrations take old data and return new data. Order is first to last."}],"source":{"line":53,"path":"src/init.lua"}}],"name":"Lapis","desc":"","source":{"line":9,"path":"src/init.lua"}}')}}]);