# Networker Services

Use this guide when a service needs client-server calls or server-pushed client state. The local reference implementation is `BuildService`.

## Local References

- Dependency: `Networker = "leifstout/networker@0.3.1"` in [../wally.toml](../wally.toml).
- Mounted package: `ReplicatedStorage.Packages.Networker`.
- Server example: [../src/Services/BuildService/Server.luau](../src/Services/BuildService/Server.luau).
- Client example: [../src/Services/BuildService/Client.luau](../src/Services/BuildService/Client.luau).
- Package source: `Packages/_Index/leifstout_networker@0.3.1/networker/src/`.

## Basic Pattern

Server:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local MyServiceServer = {}

function MyServiceServer.init(self: MyServiceServer)
	self.networker = Networker.server.new("MyService", self, {
		self.requestAction,
	})
end

function MyServiceServer.requestAction(self: MyServiceServer, player: Player, payload: any)
	-- Validate payload and enforce authority here.
	return true
end
```

Client:

```luau
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Networker = require(ReplicatedStorage.Packages.Networker)

local MyServiceClient = {}

function MyServiceClient.init(self: MyServiceClient)
	self.networker = Networker.client.new("MyService", self)
end

function MyServiceClient.sendAction(self: MyServiceClient, payload: any)
	self.networker:fire("requestAction", payload)
end
```

Server handlers exposed through `Networker.server.new` receive `player` from Roblox on the server. The client cannot choose that argument.

## API To Use

- Client to server fire-and-forget: `clientNetworker:fire("methodName", ...)`.
- Client to server request/response: `clientNetworker:fetch("methodName", ...)`.
- Server to selected clients: `serverNetworker:fire(playerOrPlayers, "methodName", ...)`.
- Server to all clients: `serverNetworker:fireAll("methodName", ...)`.
- Server to all except selected clients: `serverNetworker:fireAllExcept(playerOrPlayers, "methodName", ...)`.
- Server-pushed state: `serverNetworker:set(playerOrPlayers, key, value)`.
- Server-pushed state to all clients: `serverNetworker:setAll(key, value)`.
- Client state listener: `clientNetworker:getServerChangedSignal(key)`.

Use `:fire` when the client does not need the return value. Use `:fetch` when UI or gameplay must wait for a server result.

## Authority Rules

- Treat every client argument as untrusted.
- Validate permissions, distance, cooldowns, ownership, inventory state, and character state on the server.
- Rate limit server actions that can be spammed.
- Clean up per-player caches on `Players.PlayerRemoving`.
- Keep networking code thin when possible; move deterministic rules into testable modules or service helpers.

`BuildService` shows the basic pattern: the client sends a build request, the server checks cooldown, creates the object, and clears per-player cooldown state when the player leaves.

## Server-Pushed State

Networker state updates call `module[key] = value` on the client and then fire the signal returned by `getServerChangedSignal(key)`.

Recommended client pattern:

1. Create the client networker in `init`.
2. Seed local UI/gameplay cache from any fields already present on the client service.
3. Listen with `getServerChangedSignal(key)` for future updates.
4. Read hot-path UI or gameplay code from validated local cache, not raw transport fields.

Do not assume `getServerChangedSignal(key)` replays values sent before the listener existed. If several values must be coherent, send one server-authored snapshot table instead of several unrelated keys.

## Typing

If nominal package types are not resolved by Luau LSP, use local concrete aliases:

```luau
local Networker = require(ReplicatedStorage.Packages.Networker)

type NetworkerClient = typeof(Networker.client.new("MyService", {} :: any))
type NetworkerServer = typeof(Networker.server.new("MyService", {} :: any, {} :: { any }))
```

This keeps service fields typed without falling back to `any` for the whole service.

## Testing

Test deterministic service rules without remotes when possible.

- Runner: [../src/Modules/Test/Runner.luau](../src/Modules/Test/Runner.luau)
- Example spec: [../src/Modules/Test/Specs/BuildServiceS.spec.luau](../src/Modules/Test/Specs/BuildServiceS.spec.luau)

Networking behavior itself usually needs Studio or integration-level validation. Keep core validation logic small enough to test with TestEZ.
