local mode_map = {
  ['NORMAL'] = 'N',
  ['O-PENDING'] = 'N?',
  ['INSERT'] = 'I',
  ['VISUAL'] = 'V',
  ['V-BLOCK'] = 'V-B',
  ['V-LINE'] = 'V-L',
  ['V-REPLACE'] = 'V-R',
  ['REPLACE'] = 'R',
  ['COMMAND'] = '!',
  ['SHELL'] = 'SH',
  ['TERMINAL'] = 'T',
  ['EX'] = 'X',
  ['S-BLOCK'] = 'S-B',
  ['S-LINE'] = 'S-L',
  ['SELECT'] = 'S',
  ['CONFIRM'] = 'Y?',
  ['MORE'] = 'M',
}

local function loc()
    local cur = vim.fn.line('.')
    local col = vim.fn.virtcol('.')
    local total = vim.fn.line('$')
    local pct = 0
    if cur ~= 1 then
        pct = math.floor(cur / total * 100)
    end
    return string.format('%d:%d %d%%%%', cur, col, pct)
end

return {
    options = {
        component_separators = '',
        section_separators = '',
    },
    sections = {
        lualine_a = { {'mode', fmt = function(s) return mode_map[s] or s end} },
        lualine_b = { 'diagnostics' },
        lualine_c = { {'filename', path = 1} },
        lualine_x = {
            {'filetype', icons_enabled = false},
            {'fileformat', icons_enabled = false, fmt = function(s) return s == 'unix' and '' or s end },
            {'encoding', fmt = function(s) return s == 'utf-8' and '' or s end },
        },
        lualine_y = { 'diff' },
        lualine_z = { loc },
    },
    extensions = { 'man', 'nvim-tree', }
}
