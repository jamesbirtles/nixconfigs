local code = require('vscode')

vim.g.mapleader = " "

vim.keymap.set('n', '<leader>b', function() code.action('workbench.action.toggleSidebarVisibility') end, { desc = 'Toggle sidebar' })
vim.keymap.set('n', '<leader>t', function() code.action('workbench.action.createTerminalEditor') end, { desc = 'Create terminal' })
vim.keymap.set('n', '<leader>p', '<Nop>', { desc = 'Do nothing' })
vim.keymap.set('n', '<leader>pf', function() code.action('workbench.action.quickOpen') end, { desc = 'Go to file' })
vim.keymap.set('n', '<leader>ps', function() code.action('periscope.search') end, { desc = 'Search in files' })
vim.keymap.set('n', '<leader>pr', function() code.action('workbench.action.replaceInFiles') end, { desc = 'Replace in files' })
vim.keymap.set('n', '<leader>lg', function() code.action('lazygit-vscode.toggle') end, { desc = 'Open lazygit' })
vim.keymap.set('n', '<leader>y', function() code.action('editor.action.clipboardCopyAction') end, { desc = 'Copy to clipboard' })
vim.keymap.set('n', '<leader>v', function() code.action('editor.action.clipboardPasteAction') end, { desc = 'Paste from clipboard' })
vim.keymap.set('n', '<leader>w', function() code.action('workbench.action.files.save') end, { desc = 'Save file' })
vim.keymap.set('n', '<leader>W', function() code.action('workbench.action.files.saveAll') end, { desc = 'Save all files' })
vim.keymap.set('n', '<Esc>', '<cmd>:nohlsearch<CR>', { desc = 'Clear search' })

vim.keymap.set('n', 'ga', function() code.action('editor.action.quickFix') end, { desc = 'Quick fix full' })
vim.keymap.set('n', 'gn', function() code.action('editor.action.marker.next') end, { desc = 'Next problem' })
vim.keymap.set('n', 'gp', function() code.action('editor.action.marker.prev') end, { desc = 'Previous problem' })
vim.keymap.set('n', 'gr', function() code.action('editor.action.rename') end, { desc = 'Rename symbol' })

-- Highlight text that was just yanked
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  desc = 'Highlight text on yank'
})


