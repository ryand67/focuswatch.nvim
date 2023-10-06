# focuswatch.nvim

simple editor stopwatch/timer for neovim

## Usage
`:Focuswatch timer_start` will open an input that allows you to specify how much time to start a timer for
`:Focuswatch timer_stop` will stop the current running timer

`:Focuswatch sw_start` will start a stopwatch
`:Focuswatch sw_stop` will stop the stopwatch

Sample setup:
```lua
vim.keymap.set("n", "<leader>fwb", ":Focuswatch sw_start<CR>")
vim.keymap.set("n", "<leader>fwe", ":Focuswatch sw_stop<CR>")
vim.keymap.set("n", "<leader>fwtb", ":Focuswatch timer_start<CR>")
vim.keymap.set("n", "<leader>fwte", ":Focuswatch timer_stop<CR>")
```

## TODO
* UI countdown follows cursor around which is preferable to printing in messages queue but still not perfect. Going to figure out how to make the virtual text countdown sticky.
