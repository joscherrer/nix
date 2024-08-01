return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")

        -- REQUIRED
        harpoon:setup()
        -- REQUIRED

        vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon: Append" })
        vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
            { desc = "Harpoon: Toggle Quick Menu" })

        vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end, { desc = "Harpoon: Open file 1" })
        vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end, { desc = "Harpoon: Open file 2" })
        vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end, { desc = "Harpoon: Open file 3" })
        vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end, { desc = "Harpoon: Open file 4" })

        -- Toggle previous & next buffers stored within Harpoon list
        vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end, { desc = "Harpoon: Previous" })
        vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end, { desc = "Harpoon: Next" })
    end
}
