---@alias BorderConfig 'double'|'none'|'rounded'|'shadow'|'single'|'solid'|'default'|nui_popup_border_options
---@alias SectionName "left"|"mid"|"right"

---@class Integrations
---@field snacks? boolean
---@field telescope? boolean
---@field fzf_lua? boolean

---@class WindowSectionConfig
---@field border? BorderConfig
---@field size? string
---@field preview? "always"|"leaf"|"never"
---@field buf_options? table<string, any>
---@field win_options? table<string, any>

---@class WindowConfig
---@field border? BorderConfig
---@field size? number|string|nui_layout_option_size
---@field position? string
---@field scrolloff? number
---@field sections? { left?: WindowSectionConfig, mid?: WindowSectionConfig, right?: WindowSectionConfig }

---@class NodeMarkersIcons
---@field leaf? string
---@field leaf_selected? string
---@field branch? string

---@class NodeMarkersConfig
---@field enabled? boolean
---@field icons? NodeMarkersIcons

---@class LspConfig
---@field auto_attach? boolean
---@field preference? string[]

---@class KeyMapping
---@field callback fun(display: table)
---@field description string

---@class SourceBufferConfig
---@field follow_node? boolean
---@field highlight? boolean
---@field reorient? "smart"|"top"|"mid"|"none"
---@field scrolloff? number

---@class Navbuddy.config
---@field window? WindowConfig
---@field node_markers? NodeMarkersConfig
---@field icons? table<number, string>
---@field use_default_mappings? boolean
---@field mappings? table<string, KeyMapping>
---@field lsp? LspConfig
---@field source_buffer? SourceBufferConfig
---@field custom_hl_group? string
---@field integrations? Integrations Which integrations to enable

---@class Navbuddy.openOpts
---@field root? boolean
---@field bufnr? number

---@class RangePosition
---@field character integer
---@field line integer

---@class Range
---@field start RangePosition
---@field end RangePosition

---@class Navbuddy.symbolNode
---@field is_root? boolean
---@field index integer
---@field memory? integer
---@field kind integer
---@field name string
---@field name_range Range
---@field prev? Navbuddy.symbolNode
---@field next? Navbuddy.symbolNode
---@field scope Range
---@field children? Navbuddy.symbolNode[]|nil
---@field parent? Navbuddy.symbolNode|nil

---@alias Navbuddy.ActionCallback fun(display: Navbuddy.display)
