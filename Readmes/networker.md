# Networker quick guide (BuildService example)

This guide explains what **Networker** is for and how to use it in this project, using [`BuildServiceServer`](../src/Services/BuildService/Server.luau) and [`BuildServiceClient`](../src/Services/BuildService/Client.luau) as a reference.

## What Networker is for

**Networker** is a package that simplifies **Client ⇄ Server** communication in Roblox. It wraps the usual `RemoteEvent`/`RemoteFunction` plumbing and provides a compact API to:

- expose server “actions” (e.g. `attemptBuild`) callable from the client
- automatically provide the calling `Player` to server handlers (typical pattern: `serverMethod(self, player, ...)`)
- centralize networking per service (one “channel” per service, e.g. `"BuildService"`)

In this repo it is used by:

- Server side: [`BuildServiceServer`](../src/Services/BuildService/Server.luau)
- Client side: [`BuildServiceClient`](../src/Services/BuildService/Client.luau)

## Where it lives / installation

- Wally dependency: see [`wally.toml`](../wally.toml) (`Networker = "leifstout/networker@0.3.0"`).
- Mounted under `ReplicatedStorage.Packages` via Rojo: see [`default.project.json`](../default.project.json).
- Required in Luau like:

  - Server: `local Networker = require(ReplicatedStorage.Packages.Networker)`
  - Client: `local Networker = require(ReplicatedStorage.Packages.Networker)`

## Recommended pattern in this template (Services)

The template structure (and the `genRojoTree` generation) typically maps services like this:

- `src/Services/<ServiceName>/Server.luau` → **ServerScriptService**
- `src/Services/<ServiceName>/Client.luau` → **ReplicatedStorage**

See: [`tools/genRojoTree.js`](../tools/genRojoTree.js)

---

## Full example: BuildService

### 1) Server: register an action called `attemptBuild`

In [`BuildServiceServer`](../src/Services/BuildService/Server.luau), initialization registers the exposed methods:

- `Networker.server.new("BuildService", self, { self.attemptBuild })`

This creates a service channel named `"BuildService"` and tells Networker that the client can call the `attemptBuild` action.

On the server, the handler signature is:

- `attemptBuild(self, player: Player, cf: CFrame)`

`player` is provided by the server runtime (so the client cannot choose who is calling).

Reference: [`BuildServiceServer.attemptBuild`](../src/Services/BuildService/Server.luau)

### 2) Client: call the action with `:fire`

In [`BuildServiceClient`](../src/Services/BuildService/Client.luau):

- `self.networker = Networker.client.new("BuildService", self)`
- then, when the user clicks:
  - `self.networker:fire("attemptBuild", cf)`

Reference: [`BuildServiceClient.build`](../src/Services/BuildService/Client.luau)

In this project the usage is **fire-and-forget**: the client sends a request and the server decides whether to accept or deny it (cooldown). The server returns `true/false` from `attemptBuild`, but the current client code does not consume that value.

If you need UI feedback, design an explicit response path (server → client event), or use a request/response API if Networker supports it in your version.

### 3) Server-authoritative logic + rate limiting (best practice)

BuildService implements a server-side cooldown:

- Cache: `lastBuildTimeByKey[player] = os.clock()`
- Check: [`BuildServiceServer.isInCooldown`](../src/Services/BuildService/Server.luau)

This matters because the client is not trusted: even if the client spams `:fire`, the server will ignore requests.

The service also cleans up the cache when players leave:

- `Players.PlayerRemoving:Connect(...)`

Reference: [`BuildServiceServer.init`](../src/Services/BuildService/Server.luau)

---

## Quick recipe: create a new service with Networker

1. Create `src/Services/MyService/Server.luau`
2. Create `src/Services/MyService/Client.luau`
3. On the server, register methods with `Networker.server.new("MyService", self, { self.someAction })`
4. On the client, create the client instance with `Networker.client.new("MyService", self)` and call `:fire("someAction", ...)`

Tip: keep action names as verbs (`attemptBuild`, `requestFoo`, `setBar`) and always validate inputs on the server.

---

## Testing (recommended in this template)

This repo already includes TestEZ and a runner. BuildService logic can be tested without networking:

- Runner: [`src/Modules/Test/Runner.luau`](../src/Modules/Test/Runner.luau)
- Example spec: [`src/Modules/Test/Specs/BuildServiceS.spec.luau`](../src/Modules/Test/Specs/BuildServiceS.spec.luau)

Testing server logic directly (without remotes) is good for deterministic tests and clean separation between transport and core logic.

---

## Common pitfalls / practical advice

- Never trust the client: validate `cf` (distance, permissions, character state, etc.).
- Rate limit on the server (as shown in BuildService).
- Clean up per-player caches on `PlayerRemoving`.
- Consider separating “network handler” from core logic as the service grows.

---

## Resources

- Mounted package: `ReplicatedStorage.Packages.Networker` (via Rojo; see [`default.project.json`](../default.project.json))
- Dependency list: [`wally.toml`](../wally.toml)
- Upstream repository: https://github.com/leifstout/networker

