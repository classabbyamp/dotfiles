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
        lualine_z = { {'progress', padding = { left = 1, right = 0 } }, 'location' },
    },
    extensions = { 'nvim-tree', }
}
