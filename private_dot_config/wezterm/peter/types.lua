---@meta

-- Some of the types in https://github.com/justinsgithub/wezterm-types are missing or incorrect.
-- This LuaLS definition file papers over some of the issues (i.e. overrides the types) on an as-needed basis.
-- See https://luals.github.io/wiki/annotations/ for more.

---@class peter.Wezterm :Wezterm
---@field action peter.Action
---@field action_callback fun(callback: ActionCallback): KeyAssignment
---@field config_builder fun(): peter.Config
---@field mux peter.Mux
---@field on peter.On

---@class peter.Config :Config
---@field audible_bell peter.AudibleBell
---@field window_close_confirmation peter.WindowCloseConfirmation

---@alias peter.AudibleBell
---| "SystemBeep"
---| "Disabled"

---@alias peter.WindowCloseConfirmation
---| "AlwaysPrompt"
---| "NeverPrompt"

---@class peter.Action :Action
---@field TogglePaneZoomState "TogglePaneZoomState"

---@alias peter.On
---| EventAugmentCommandPalette
---| EventBell
---| peter.EventFormatTabTitle
---| EventFormatWindowTitle
---| peter.EventGuiStartup
---| EventNewTabButtonClick
---| EventOpenUri
---| EventUpdateRightStatus
---| peter.EventUpdateStatus
---| EventUserVarChanged
---| EventWindowConfigReloaded
---| EventWindowFocusChanged
---| EventWindowResized
---| EventCustom

---@alias peter.CallbackWindowPane fun(window: peter.Window, pane: Pane)

---@alias peter.CallbackFormatTabTitle fun(tab: peter.TabInformation, tabs: peter.TabInformation[], panes: peter.PaneInformation[], config: peter.Config, hover: boolean, max_width: number): FormatItem[]
---@alias peter.CallbackSpawnCommand fun(cmd: peter.SpawnCommand)
---@alias peter.CallbackUpdateStatus peter.CallbackWindowPane

---@alias peter.EventFormatTabTitle fun(event: "format-tab-title", callback: peter.CallbackFormatTabTitle)
---@alias peter.EventGuiStartup fun(event: "gui-startup", callback: peter.CallbackSpawnCommand)
---@alias peter.EventUpdateStatus fun(event: "update-status", callback: peter.CallbackUpdateStatus)

---@class peter.Mux: MuxMod
---@field spawn_window fun(...: any): tab: MuxTabObj, pane: Pane, window: MuxWindow Spawns a program into a new window, returning the MuxTab, Pane and MuxWindow objects associated with it. When no arguments are passed, the default program is spawned.

---@class peter.PaneInformation
---@field is_zoomed boolean
---@field pane_id number
---@field title string

---@class peter.SpawnCommand

---@class peter.TabInformation
---@field active_pane peter.PaneInformation
---@field is_active boolean
---@field panes peter.PaneInformation[]
---@field tab_id number
---@field tab_title string

---@class peter.Window :Window
---@field effective_config fun(self: peter.Window): peter.Config Returns a lua table representing the effective configuration for the Window. The table is in the same format as that used to specify the config in the wezterm.lua file, but represents the fully-populated state of the configuration, including any CLI or per-window configuration overrides.  Note: changing the config table will NOT change the effective window config; it is just a copy of that information.
