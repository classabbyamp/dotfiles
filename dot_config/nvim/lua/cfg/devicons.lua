return function()
    require("nvim-web-devicons").setup({
        override_by_filename = {
            ["template"] = {
                icon = "",
                color = "#295340",
                cterm_color = "23",
                name = "Void",
            }
        }
    })
    require("nvim-web-devicons").filetypes["srcpkg"] = "void"
end
