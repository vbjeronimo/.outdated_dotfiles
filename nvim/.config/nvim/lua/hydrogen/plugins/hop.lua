return {
  "phaazon/hop.nvim",
  branch = "v2",
  config = function()
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    local keymap = vim.keymap.set

    hop.setup({
        keys = 'etovxqpdygfblzhckisuran',
    })

    keymap('', 'f', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    end, { remap = true })
    keymap('', 'F', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    end, { remap = true })
    keymap('', 't', function()
        hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    end, { remap = true })
    keymap('', 'T', function()
        hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    end, { remap = true })

    keymap('', '<leader>/', function()
        hop.hint_patterns({ direction = directions.AFTER_CURSOR })
    end, { remap = true })
    keymap('', '<leader>?', function()
        hop.hint_patterns({ direction = directions.BEFORE_CURSOR })
    end, { remap = true })

    keymap('', 's', function()
        hop.hint_words()
    end, { remap = true })
    keymap('', 'S', function()
        hop.hint_char1()
    end, { remap = true })

    keymap('', 'g0', function()
        hop.hint_lines()
    end, { remap = true })
    keymap('', 'g_', function()
        hop.hint_lines_skip_whitespace()
    end, { remap = true })
  end
}
