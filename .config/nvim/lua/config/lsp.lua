-- Global diagnostic display configuration (Neovim 0.12)
vim.diagnostic.config({
  virtual_lines = true,
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = true,
    header = '',
    prefix = '',
  },
  jump = {
    float = true,
    wrap = true,
  },
})

-- Global diagnostic keymaps
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show syntax error / diagnostic float at cursor' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open buffer syntax errors in location list' })

-- Helper: resolve project root from markers, falling back to file directory for standalone files
local function root_with_fallback(markers)
  return function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(bufnr, markers)
      or (fname ~= '' and vim.fs.dirname(fname))
      or vim.fn.getcwd()
    on_dir(root)
  end
end

-- 1. clangd (C / C++ / Objective-C / CUDA)
local clangd_bin = '/home/f00632390/.local/llvm/bin/clangd'
if vim.fn.executable(clangd_bin) == 1 then
  vim.lsp.config('clangd', {
    cmd = { clangd_bin, '--header-insertion=never' },
    filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
    root_dir = root_with_fallback({ 'compile_commands.json', '.clangd', '.git' }),
    before_init = function(params, config)
      if config.root_dir then
        local build_cc = vim.fs.joinpath(config.root_dir, 'build', 'compile_commands.json')
        if vim.uv.fs_stat(build_cc) then
          params.initializationOptions = vim.tbl_deep_extend('force', params.initializationOptions or {}, {
            compilationDatabasePath = vim.fs.joinpath(config.root_dir, 'build'),
          })
        end
      end
    end,
  })
  vim.lsp.enable('clangd')
end

-- 2. BiShengIR / MLIR LSP Server (*.mlir)
local bisheng_lsp = '/home/f00632390/repos/AscendNPU-IR/build/bin/bishengir-lsp-server'
local mlir_lsp = '/home/f00632390/repos/AscendNPU-IR/build/bin/mlir-lsp-server'
local active_mlir_lsp = vim.fn.executable(bisheng_lsp) == 1 and bisheng_lsp or mlir_lsp
if vim.fn.executable(active_mlir_lsp) == 1 then
  vim.lsp.config('bishengir_lsp', {
    cmd = { active_mlir_lsp },
    filetypes = { 'mlir' },
    root_dir = root_with_fallback({ '.git' }),
  })
  vim.lsp.enable('bishengir_lsp')
end

-- 3. TableGen LSP Server (*.td)
local tblgen_lsp = '/home/f00632390/repos/AscendNPU-IR/build/bin/tblgen-lsp-server'
if vim.fn.executable(tblgen_lsp) == 1 then
  local default_db = '/home/f00632390/repos/AscendNPU-IR/build/tablegen_compile_commands.yml'
  local cmd = { tblgen_lsp }
  if vim.uv.fs_stat(default_db) then
    table.insert(cmd, '--tablegen-compilation-database=' .. default_db)
  end
  vim.lsp.config('tblgen_lsp', {
    cmd = cmd,
    filetypes = { 'tablegen' },
    root_dir = root_with_fallback({ 'tablegen_compile_commands.yml', '.git' }),
  })
  vim.lsp.enable('tblgen_lsp')
end

-- 4. MLIR PDLL LSP Server (*.pdll)
local pdll_lsp = '/home/f00632390/repos/AscendNPU-IR/build/bin/mlir-pdll-lsp-server'
if vim.fn.executable(pdll_lsp) == 1 then
  vim.lsp.config('pdll_lsp', {
    cmd = { pdll_lsp },
    filetypes = { 'pdll' },
    root_dir = root_with_fallback({ 'pdll_compile_commands.yml', '.git' }),
  })
  vim.lsp.enable('pdll_lsp')
end

-- Keymaps & completion on LspAttach (replaces YouCompleteMe bindings)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspAttach', { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    local bufnr = ev.buf
    local opts = { buffer = bufnr, silent = true }

    -- Enable native Neovim 0.12 LSP auto-completion
    if client and client:supports_method('textDocument/completion') then
      vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end

    -- <leader>g : GoToDefinitionElseDeclaration (matching YCM behavior)
    vim.keymap.set('n', '<leader>g', function()
      local params = vim.lsp.util.make_position_params(0, client and client.offset_encoding or 'utf-16')
      vim.lsp.buf_request(bufnr, 'textDocument/definition', params, function(err, result, ctx)
        if not err and result and not vim.tbl_isempty(result) then
          vim.lsp.handlers['textDocument/definition'](err, result, ctx)
        elseif client and client:supports_method('textDocument/declaration') then
          vim.lsp.buf.declaration()
        else
          vim.lsp.buf.definition()
        end
      end)
    end, vim.tbl_extend('force', opts, { desc = 'LSP GoToDefinitionElseDeclaration' }))

    -- <leader>i : Code Action / FixIt (matching :YcmCompleter FixIt)
    vim.keymap.set('n', '<leader>i', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP FixIt / Code Action' }))

    -- <leader>D : Hover documentation (matching <plug>(YCMHover))
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP Hover' }))
  end,
})
