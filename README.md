# jsonnet-tools.nvim
This is a simple plugin to make working with jsonnet easier. Designed to be used with [grustonnet](https://github.com/koskev/grustonnet-ls)

## Components

### Preview
Allows for a live preview of the jsonnet code

### Debugger
Adds a default configuraion for jsonnet debugging. Jpaths, extvars, and excode is pulled from the language server

## Installation

lazy.nvim
```lua
{
	"koskev/jsonnet-tools.nvim",
	ependencies = { 'mfussenegger/nvim-dap' },
	opts = {},
},
```

