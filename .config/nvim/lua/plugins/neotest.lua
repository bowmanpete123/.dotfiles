return {
  "nvim-neotest/neotest",
  dependencies = {
    "mrcjkb/rustaceanvim",
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/neotest-python",
    "andythigpen/nvim-coverage",
  },
  event = "VeryLazy",
  config = function()
    ---------------------------------"
    -- Test Runners
    ---------------------------------"
    local utils = require("config.utils")
    local nmap = utils.norm_keyset
    local lk = require("config.keymaps").lk
    local palette = require("config.theme").palette
    local python_path = utils.get_python_path()
    -- Config
    ----------
    require("neotest").setup({
      -- Adapters
      adapters = {
        require("neotest-python")({
          dap = { justMyCode = false },
          runner = "pytest",
          python = python_path,
          pytest_discover_instances = true,
          args = { "-vv" },
        }),
        (function()
          local adapter = require("rustaceanvim.neotest")
          if type(adapter) == "function" then
            adapter = adapter()
          end
          local original_results = adapter.results
          adapter.results = function(spec, strategy_result)
            local results = original_results(spec, strategy_result)
            if strategy_result.code ~= 0 then
              local output_content = require("neotest.lib").files.read(strategy_result.output)
              local tree = spec.context.tree

              -- 1. Parse Passing tests first
              require("rustaceanvim.neotest.parser").populate_pass_positions(results, spec.context, output_content)

              -- 2. Parse Ignored/Skipped tests
              local lines = vim.split(output_content, "\n")
              for _, line in ipairs(lines) do
                local ignored_test = line:match("test%s(%S+)%s...%signored") or line:match("SKIP%s.*%s(%S+)$")
                if ignored_test then
                  local pos_id = require("rustaceanvim.neotest.trans").get_position_id(spec.context.file, ignored_test)
                  results[pos_id] = { status = "skipped" }
                end
              end

              -- 3. Everything else in a failing run that isn't Passed or Ignored MUST be a Failure
              for _, node in tree:iter_nodes() do
                if node:data().type == "test" then
                  local id = node:data().id
                  if not results[id] then
                    results[id] = { status = "failed" }
                  end
                end
              end
            end
            return results
          end
          return adapter
        end)(),
      },
      status = {
        enabled = true,
        virtual_text = true,
        signs = false,
      },
      -- UI
      floating = {
        border = "rounded",
        max_height = 0.9,
        max_width = 0.9,
        options = { wrap = true },
      },
    })
    ----------

    -- Mappings
    ----------
    -- Mappings
    nmap(lk.exec_test.key .. "x", "lua require('neotest').run.run(vim.fn.expand('%'))", "Test Current Buffer")
    nmap(lk.exec_test.key .. "a", "lua require('neotest').run.run(vim.fn.getcwd())", "Test Current Project")
    nmap(
      lk.exec_test.key .. "o",
      "lua require('neotest').output.open({ enter = true, auto_close = true })",
      "Test Output"
    )
    nmap(lk.exec_test.key .. "s", "lua require('neotest').summary.toggle()", "Test Output (All Tests)")
    nmap(lk.exec_test.key .. "q", "lua require('neotest').run.stop()", "Quit Test Run")
    nmap(lk.exec_test.key .. "w", "lua require('neotest').watch.toggle(vim.fn.expand('%'))", "Toggle Test Refreshing")
    nmap(lk.exec_test.key .. "W", "lua require('neotest').watch.toggle(vim.fn.getcwd())", "Toggle Test Refreshing")
    nmap(lk.exec_test.key .. "c", "lua require('neotest').run.run()", "Run Nearest Test")
    nmap(lk.exec_test.key .. "r", "lua require('neotest').run.run_last()", "Repeat Last Test Run")
    nmap(
      lk.exec_test.key .. "b",
      "lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})",
      "Debug Closest Test"
    )
    ----------
    ---------------------------------"
    -- Code Coverage
    ---------------------------------"
    require("coverage").setup({
      commands = true, -- create commands
      highlights = {
        -- customize highlight groups created by the plugin
        covered = { fg = palette.bright_green }, -- supports style, fg, bg, sp (see :h highlight-gui)
        uncovered = { fg = palette.bright_red },
      },
      signs = {
        -- use your own highlight groups or text markers
        covered = { hl = "CoverageCovered", text = "▎" },
        uncovered = { hl = "CoverageUncovered", text = "▎" },
      },
      summary = {
        -- customize the summary pop-up
        min_coverage = 80.0, -- minimum coverage threshold (used for highlighting)
      },
      lang = {
        -- customize language specific settings
      },
    })

    -- Mappings
    ----------
    nmap(lk.exec_test_coverage.key .. "r", "Coverage", "Run Coverage Report")
    nmap(lk.exec_test_coverage.key .. "s", "CoverageSummary", "Show Coverage Report")
    nmap(lk.exec_test_coverage.key .. "t", "CoverageToggle", "Toggle Coverage Signs")
    ----------
  end,
}
