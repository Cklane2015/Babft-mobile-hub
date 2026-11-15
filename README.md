# BABFT Mobile Hub – Roblox Studio utility starter pack

These Lua files are starter utilities for a Roblox experience you own or are authorized to edit.
They do **not** inject into, modify, or automate the official Build A Boat For Treasure game.

## Setup
1. Open Roblox Studio and your own experience.
2. In Explorer, open `StarterPlayer > StarterPlayerScripts`.
3. Create a `LocalScript` named `MobileHub.client.lua` and paste the contents of `MobileHub.client.lua`.
4. Add the other LocalScripts in the same folder if you want their client-side examples.
5. For persistent saves, use the server-side `BuildData.server.lua` example in `ServerScriptService`. Enable Studio access to API services only for a test experience you control.

The build counter looks for a folder named `PlayerBuilds` in Workspace. Change that name if your own game uses a different folder.

## Included
- MobileHub.client.lua – automatically creates a touch-friendly hub and tabs
- AFKTracker.client.lua – session timer only; it does not generate rewards or keep a game session alive
- BlockCounter.client.lua – counts BaseParts in Workspace.PlayerBuilds
- ColorPicker.client.lua – reusable theme palette helper
- Notifications.client.lua – notification helper
- BuildData.server.lua – example server-side save/load pattern for your own game's build data

These are examples and may need adapting to your own game's object structure and permissions.
