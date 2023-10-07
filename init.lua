-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Install package manager
--    https://github.com/folke/lazy.nvim
--    `:help lazy.nvim.txt` for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

if vim.g.neovide then
  -- Put anything you want to happen only in Neovide here
  -- Ignore horizonta, scrolling ...
  -- vim.keymap.set({ 'i', 'n' }, '<ScrollWheelRight>', '<nop>')
  -- vim.keymap.set({ 'i', 'n' }, '<ScrollWheelLeft>', '<nop>')
end

-- vim.api.nvim_create_user_command('G', ':Fugitive', {})
-- NOTE: Here is where you install your plugins.
--  You can configure plugins using the `config` key.
--
--  You can also configure plugins after the setup call,
--    as they will be available in your neovim runtime.
require('lazy').setup({

  -- spec = {
  --   { 'LazyVim/LazyVim', import = 'lazyvim.plugins' },
  --   { import = 'lazyvim.plugins.extras.formatting.prettier' },
  --   --    { import = "plugins" },
  -- },
  -- NOTE: First, some plugins that don't require any configuration
  'mg979/vim-visual-multi',

  -- Icons for diffview ...
  'nvim-tree/nvim-web-devicons',

  -- Git related plugins
  'tpope/vim-fugitive',     -- `:help fugitive` call regular git CLI commands with `:Git`
  'sindrets/diffview.nvim', -- `:help diffview` get a nice interactive git diff view with `:Diffview...
  {
    'rbong/vim-flog',       -- `:help flog` get a nice git graph with `:Flog`
  },
  'tpope/vim-rhubarb',      -- `:help rhubarb` .... not really sure what this is used for yet

  -- Detect tabstop and shiftwidth automatically
  'tpope/vim-sleuth',

  -- NOTE: This is where your plugins related to LSP can be installed.
  --  The configuration is done below. Search for lspconfig to find it below.
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim',       tag = 'legacy', opts = {} },

      -- Additional lua configuration, makes nvim stuff amazing!
      'folke/neodev.nvim',
    },
  },

  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'L3MON4D3/LuaSnip',             -- Snippet Engine & its associated nvim-cmp source
      'saadparwaiz1/cmp_luasnip',     -- Snippet Engine & its associated nvim-cmp source

      'hrsh7th/cmp-nvim-lsp',         -- Adds LSP completion capabilities
      'rafamadriz/friendly-snippets', -- Adds a number of user-friendly snippets
    },
  },

  -- Useful plugin to show you pending keybinds.
  { 'folke/which-key.nvim', opts = {} },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',

    opts = {
      -- See `:help gitsigns.txt`
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '-' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      numhl = true,

      on_attach = function(bufnr)
        -- the git add coloring
        -- do
        --   local style = { fg = "#000000", bg = "#8fb573" }
        --   vim.api.nvim_set_hl(0, "GitSignsAdd", style)
        --   vim.api.nvim_set_hl(0, "GitSignsAddNr", style)
        -- end

        vim.keymap.set('n', '<leader>hp', require('gitsigns').preview_hunk, { buffer = bufnr, desc = 'Preview git hunk' })

        -- don't override the built-in and fugitive keymaps
        --
        local gs = package.loaded.gitsigns
        vim.keymap.set({ 'n', 'v' }, ']c', function()
          if vim.wo.diff then
            return ']c'
          end
          vim.schedule(function()
            gs.next_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to next hunk' })
        vim.keymap.set({ 'n', 'v' }, '[c', function()
          if vim.wo.diff then
            return '[c'
          end
          vim.schedule(function()
            gs.prev_hunk()
          end)
          return '<Ignore>'
        end, { expr = true, buffer = bufnr, desc = 'Jump to previous hunk' })
      end,
    },
  },

  {
    -- Theme inspired by Atom
    'navarasu/onedark.nvim',
    priority = 1000,
    config = function()
      require('onedark').setup {
        colors = {
          black = "#101012",
          bg0 = "#000000", -- "#232326" background of main buffer
          bg1 = "#2c2d31",
          bg2 = "#35363b",
          bg3 = "#37383d",
          bg_d = "#1b1c1e",
          bg_blue = "#68aee8",
          bg_yellow = "#e2c792",
          fg = "#a7aab0",
          purple = "#bb70d2",
          green = "#8fb573",
          orange = "#c49060",
          blue = "#57a5e5",
          yellow = "#dbb671",
          cyan = "#51a8b3",
          red = "#de5d68",
          grey = "#5a5b5e",
          light_grey = "#818387",
          dark_cyan = "#2b5d63",
          dark_red = "#833b3b",
          dark_yellow = "#7c5c20",
          dark_purple = "#79428a",
          diff_add = "#082008",    -- "#282b26",
          diff_delete = "#200808", -- "#2a2626",
          diff_change = "#1a2a37",
          diff_text = "#2c485f",
        },
        highlight = {

        }

      }
      require('onedark').load()
    end,
  },

  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    -- See `:help lualine.txt`
    opts = {
      options = {
        icons_enabled = false,
        theme = 'onedark',
        component_separators = '|',
        section_separators = '',
      },
    },
  },

  {
    -- Add indentation guides even on blank lines
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help indent_blankline.txt`
    main = 'ibl',
    config = function()
      vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" });
      vim.api.nvim_set_hl(0, "DarkGrey", { fg = "#303030" });
      vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" });
      require("ibl").setup {

        indent = { char = '│', highlight = "DarkGrey" }, --  highlight = 'RainbowRed'},
        scope = { highlight = "RainbowGreen" }
      }
    end,
    -- opts = {
    -- indent = { char = '│' , highlight = "RainbowRed"} --  highlight = 'RainbowRed'},
    -- },
  },

  -- "gc" to comment visual regions/lines
  -- help: comment-nvim
  {
    'numToStr/Comment.nvim',
    opts = {},
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<leader>cc',
          -- block = '<leader>bc',
        },

      })
    end
  },

  -- for linters ... yes it is archived, but ... https://www.reddit.com/r/neovim/comments/14z79qm/comment/jrwtk44/?utm_source=share&utm_medium=web2x&context=3
  {
    'jose-elias-alvarez/null-ls.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        debug = true,
        sources = {
          null_ls.builtins.diagnostics.eslint_d.with({
            -- args = { ".", "--ext", ".ts","-f", "json", "--stdin", "--stdin-filename", "$FILENAME" }

            -- args = { "--ext", ".ts", "-f", "json", "." } -- "--stdin", "--stdin-filename", "$FILENAME" }
          }),
        },
      })
    end
  }, -- TODO: add dependency on plenary ?

  -- Fuzzy Finder (files, lsp, etc)
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },

  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
  },

  -- NOTE: Next Step on Your Neovim Journey: Add/Configure additional "plugins" for kickstart
  --       These are some example plugins that I've included in the kickstart repository.
  --       Uncomment any of the lines below to enable them.
  -- require 'kickstart.plugins.autoformat',
  -- require 'kickstart.plugins.debug',

  -- NOTE: The import below can automatically add your own plugins, configuration, etc from `lua/custom/plugins/*.lua`
  --    You can use this folder to prevent any conflicts with this init.lua if you're interested in keeping
  --    up-to-date with whatever is in the kickstart repo.
  --    Uncomment the following line and add your plugins to `lua/custom/plugins/*.lua` to get going.
  --
  --    For additional information see: https://github.com/folke/lazy.nvim#-structuring-your-plugins
  -- { import = 'custom.plugins' },
}, {})

-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.o.wrap = false -- no wrapping, useful when viewing git diff, not however that the terminal itself might wrap
-- vim.o.hlsearch = false -- Set highlight on search
vim.o.mouse = 'a'  -- Enable mouse mode

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.breakindent = true               -- Enable break indent
vim.o.undofile = true                  -- Save undo history

vim.o.ignorecase = true                -- Case-insensitive searching UNLESS \C or capital in search
vim.o.smartcase = true                 -- Case-insensitive searching UNLESS \C or capital in search

vim.o.updatetime = 250                 -- Decrease update time
vim.o.timeoutlen = 300                 -- Decrease update time

vim.o.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
vim.o.termguicolors = true             -- NOT

vim.wo.signcolumn = 'yes'              -- Keep signcolumn on by default
vim.wo.number = true                   -- Make line numbers defaultE: You should make sure your terminal supports this

-- [[ Basic Keymaps ]]

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf (fuzzy finder) native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
do
  local pkg = require 'telescope.builtin'
  local set = vim.keymap.set

  local current_buf_fzf = function()
    pkg.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end

  local find_files = function()
    pkg.find_files { hidden = true }
  end

  set('n', '<leader>?', pkg.oldfiles, { desc = '[?] Find recently opened files' })
  set('n', '<leader><space>', pkg.buffers, { desc = '[ ] Find existing buffers' })
  set('n', '<leader>/', current_buf_fzf, { desc = '[/] Fuzzily search in current buffer' })
  set('n', '<leader>gf', pkg.git_files, { desc = 'Search [G]it [F]iles' })
  set('n', '<leader>sf', find_files, { desc = '[S]earch [F]iles' })
  set('n', '<leader>sh', pkg.help_tags, { desc = '[S]earch [H]elp' })
  set('n', '<leader>sw', pkg.grep_string, { desc = '[S]earch current [W]ord' })
  set('n', '<leader>sg', pkg.live_grep, { desc = '[S]earch by [G]rep' })
  set('n', '<leader>sd', pkg.diagnostics, { desc = '[S]earch [D]iagnostics' })
  set('n', '<leader>sr', pkg.resume, { desc = '[S]earch [R]esume' })
end

-- [[ Git diff views ]]
--
-- The behaviour we are going for here is the following:
-- <leader>gd should toggle individual Diffview "panels".
-- If no Diffview is currently open or actively being viewed
-- then a new diffview is opened.
-- If a Diffview is currently being viewed, then it is closed.
-- :h diffview
-- :h diffview.defaults
require('diffview').setup({
  view = {
    -- Configure the layout and behavior of different types of views.
    -- Available layouts:
    --  'diff1_plain'
    --    |'diff2_horizontal'
    --    |'diff2_vertical'
    --    |'diff3_horizontal'
    --    |'diff3_vertical'
    --    |'diff3_mixed'
    --    |'diff4_mixed'
    -- For more info, see |diffview-config-view.x.layout|.
    default = {
      -- Config for changed files, and staged files in diff views.
      -- layout = "diff2_vertical",
      layout = "diff2_horizontal",
      winbar_info = false, -- See |diffview-config-view.x.winbar_info|
    },
    merge_tool = {
      -- Config for conflicted files in diff views during a merge or rebase.
      layout = "diff3_horizontal",
      disable_diagnostics = true, -- Temporarily disable diagnostics for conflict buffers while in the view.
      winbar_info = true,         -- See |diffview-config-view.x.winbar_info|
    },
    file_history = {
      -- Config for changed files in file history views.
      layout = "diff2_horizontal",
      winbar_info = false, -- See |diffview-config-view.x.winbar_info|
    },
  },

})
do
  vim.keymap.set('n', '<leader>gd', function(args)
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
    local diffviewOpen = string.match(current_buffer_name, '^diffview.*')
    local dv = require 'diffview'
    if diffviewOpen then
      dv.close(args)
    else
      dv.open(args)
    end
  end, { desc = '[G]it [D]iff' })
end

-- [[ Git log as graph ... uses vim-flog, we did not find a way to call the api directly ... ]]
vim.keymap.set('n', '<leader>gl', ':Flog -date=relative<cr>', { desc = '[G]it [L]og' })
vim.keymap.set('n', '<leader>gs', ':Git<cr>', { desc = '[G]it [S]tatus' })

-- [[ Quickly open this file config file... ]]
vim.keymap.set('n', '<leader>l', ':e ~/.config/nvim/init.lua<cr>', { desc = '[L]ua config' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'tsx', 'javascript', 'typescript', 'vimdoc', 'vim',
    'prisma' },

  -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
  auto_install = false,

  highlight = { enable = true },
  indent = { enable = true },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<M-space>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

do
  -- [[ Trivial remappings not related to plugins ]]
  --
  --

  -- dont care about capitalization of the following builting commands, unfortunately not allowed to add trialing !
  for _, cmd in ipairs({ 'q', 'w', 'wq' }) do
    vim.api.nvim_create_user_command(string.upper(cmd), ':' .. cmd, {})
  end

  --  vim.api.nvim_create_user_command("Q", ':q', {})
  vim.keymap.set({ 'n' }, '<leader>qq', vim.diagnostic.setqflist, { desc = "is this lint diag" })


  local lsp_code_action = function()
    vim.lsp.buf.code_action()
    -- vim.notify("code action")
  end

  do
    -- These keymaps make the default vim search a bit more convenient
    --
    -- 1. we allow clicking into the buffer even if search is not "completed
    -- 2. we clear the highlighted instances matching the search when we start insert next

    -- this implements feature 1.
    vim.keymap.set({ 'c' }, '<LeftMouse>', function()
      return "<cr>"
    end, { expr = true })

    -- this implements feature 2.
    do
      for _, key in ipairs({ 'i', 'o', 's', '<Esc>' }) do
        vim.keymap.set({ 'n' }, key, function()
          vim.cmd('noh')
          return key
        end, { expr = true })
      end
    end

  end

  -- do
  -- -- interesting experiments with autocommands :)
  --   local ctr = 0
  --   -- for _, event in ipairs({ "CmdwinLeave", "CmdlineLeave", "InsertEnter", "CmdlineEnter", "CursorHold", "CursorHoldI", "CursorMoved", "FocusGained" }) do
  --   for _, event in ipairs({ "CursorHoldI", "FocusGained" }) do
  --     vim.api.nvim_create_autocmd({ event }, {
  --       callback = function(ev)
  --         vim.notify(tostring(ctr) .. ": event: " .. event)
  --         ctr = ctr + 1
  --       end
  --     })
  --   end
  -- end



  vim.keymap.set({ 'i', 'n' }, '<C-.>', lsp_code_action, { desc = 'Code action' })
  vim.keymap.set({ 'i' }, '<M-h>', '<Left>', { desc = 'Move left while inserting' })
  vim.keymap.set({ 'i' }, '<M-j>', '<Down>', { desc = 'Move left while inserting' })
  vim.keymap.set({ 'i' }, '<M-k>', '<Up>', { desc = 'Move left while inserting' })
  vim.keymap.set({ 'i' }, '<M-l>', '<Right>', { desc = 'Move left while inserting' })

  -- Force myself to stop using arrow keys ...
  -- local unmapped_keys = { '<Left>', '<Right>', '<Up>', '<Down>' }
  -- for _, name in ipairs(unmapped_keys) do
  --   vim.keymap.set({ 'n', 'v', 'i' }, name, '<Nop>', { desc = 'Just avoid using arrow keys' })
  -- end

  -- Relative line numbering ... lets try it out
  vim.wo.relativenumber = true
  -- Special git diff action when pressing "," while Flog buffer is active
  -- Shows git diff between what is currently active in working tree and the commit where the cursor is at in the tree
  vim.keymap.set('n', ',', function()
    local current_buffer = vim.api.nvim_get_current_buf()
    local current_buffer_name = vim.api.nvim_buf_get_name(current_buffer)
    -- see lua pattern matching documentation for explanation of the below non-regex pattern
    local patrn_flog = '/?flog%-%d+'
    local patrn_max_count = '%[max_count=%d+%]'
    local patrn_all = '%[all%]'

    -- NOTE the need for two patters because we are not able to match optionally on a subpatter in lua patterns
    local flog_buffer_active = string.match(current_buffer_name, patrn_flog .. ' ' .. patrn_max_count)

    local flog_buffer_active_all = string.match(current_buffer_name,
      patrn_flog .. ' ' .. patrn_all .. ' ' .. patrn_max_count)

    if not (flog_buffer_active or flog_buffer_active_all) then
      return
    end

    return '<Plug>(FlogStartCommand) DiffviewOpen<cr>'
  end, { expr = true })
end

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

-- [[ Configure LSP ]]
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local lsp_nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  lsp_nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  lsp_nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  lsp_nmap('<leader>rx', vim.diagnostic.goto_next, 'Diagnostic')

  lsp_nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  lsp_nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  lsp_nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')
  lsp_nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  lsp_nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  lsp_nmap('<leader>ps', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[P]roject [S]ymbols')

  -- See `:help K` for why this keymap
  lsp_nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  lsp_nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  lsp_nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  lsp_nmap('<leader>pa', vim.lsp.buf.add_workspace_folder, '[P]roject [A]dd Folder')
  lsp_nmap('<leader>pr', vim.lsp.buf.remove_workspace_folder, '[P]roject [R]emove Folder')
  lsp_nmap('<leader>pl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[P]roject [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- document existing key chains
require('which-key').register {
  ['<leader>c'] = { name = '[C]ode', _ = 'which_key_ignore' },
  ['<leader>d'] = { name = '[D]ocument', _ = 'which_key_ignore' },
  ['<leader>g'] = { name = '[G]it', _ = 'which_key_ignore' },
  ['<leader>h'] = { name = 'More git', _ = 'which_key_ignore' },
  ['<leader>r'] = { name = '[R]ename', _ = 'which_key_ignore' },
  ['<leader>s'] = { name = '[S]earch', _ = 'which_key_ignore' },
  ['<leader>p'] = { name = '[P]roject', _ = 'which_key_ignore' },
}

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
--
--  If you want to override the default filetypes that your language server will attach to you can
--  define the property 'filetypes' to the map in question.
local servers = {
  -- clangd = {},
  -- gopls = {},
  -- pyright = {},
  rust_analyzer = {},
  prismals = {},
  tsserver = {},
  -- html = { filetypes = { 'html', 'twig', 'hbs'} },

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end,
}

-- [[ Configure nvim-cmp  ... used for code completion ... ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    -- Ctrl + n
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Ctrl + p
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- Ctrl + d
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    -- Ctrl + f
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    -- ['<CR>'] = cmp.mapping.confirm {
    --   behavior = cmp.ConfirmBehavior.Replace,
    --   select = true,
    -- },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    -- Shift + Tab
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  },
}

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
