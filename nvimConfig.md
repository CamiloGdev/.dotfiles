# Configuraciones para Neovim

## Tener en cuenta

- Como poner el error lens en neovim.
- Como poner el spell en neovim, tanto en ingles como español.
- Que herramienta para gestión de git usar.
- Que herramienta para visualización gráfica de git usar.
- No inicializar ninguna configuración de para vscode-neovim cuando se trabaje directamente en neovim.
- No inicializar ninguna configuración de para neovim cuando se trabaje directamente en vscode-neovim.

## Plugins

### Los que usa ThePrimeagen

- Administrador de plugins: `packer.nvim`, pero luego lo cambio a `lazy.nvim`.
- Buscador difuso (Fuzzy Finder), para saltar entre archivos: `telescope.nvim`.

```lua
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {}) -- Solo busca los archivos que están en el repositorio de git, evita por ejemplo los archivos de node_modules.
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({
        search = vim.fn.input('Grep > '),
    })
end) -- Busca una cadena de texto en todos los archivos del proyecto, pero podemos escribirla en el input comando de vim.
```

- Tema de colores: `rose-pine/nvim`.
- El usa la carpeta after para cargar configuraciones después de que se cargue la configuración inicial, allí pone configuraciones como la de telescope o la `colors.lua` para transparencias y configuraciones especiales de color y tema, evaluar si es necesario con el uso de `lazy.nvim`.
- El realiza una configuración en `colors.lua` para que la transparencia de las ventanas sea configurable y funcione correctamente.

```lua
function ColorMyPencils(color)
    color = color or "rose-pine"
    vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

ColorMyPencils()
```

- Configuración correcta del resaltado de sintaxis en neovim: `nvim-treesitter`, verificar si es necesario con el uso de `lazy.nvim`.

- `Harpoon`, plugin del mismo ThePrimeagen, para moverse entre archivos de forma rápida, evaluar si es bueno usarlo o no.
- `mbbill/undotree`, plugin para ver el historial de cambios de un archivo, poder ver los cambios y regresar a un punto anterior en el tiempo.
- `tpope/vim-fugitive`, plugin para trabajar con git desde vim, evaluar si es bueno usarlo o no, compararlo con otros plugins de git.
- `VonHeikemen/lsp-zero.nvim`, plugin para configurar LSP de forma sencilla, ThePrimeagen lo usa con una configuración personalizada, este plugin también incorpora configuraciones para tener sugerencias de auto completado, resaltado de sintaxis, etc, ThePrimeagen tambien realiza remapeos que facilitan el uso de LSP, como porejemplo, remapear la tecla `gd` para ir a la definición de una función, `gr` para ir a las referencias de una función, `K` para ver la documentación de una función, etc, pero los remapeos solo se ocurren en los buffers que tienen un LSP asociado, es decir que si voy a un buffer que no tiene un LSP asociado, no se activan los remapeos y dicho buffer se comporta como un buffer normal, evaluar si es bueno usarlo o no, compararlo con otros plugins de LSP.
- También en otro video mas reciente realiza la configuración del LSP para lazy.nvim con `williamboman/mason.nvim`, evaluar si es bueno usarlo o no, compararlo con otros plugins de LSP.
- genera un archivo de configuración `set.lus` para las configuraciones generales de vim, como por ejemplo, el numero de espacios para la sangria, los números de linea, etc..., mirar el repo de configuración de ThePrimeagen para ver que configuraciones tiene.
- Revisar los remaps de ThePrimeagen para ver si hay alguno que me interese.
- Dejar los portapapeles de vim y del sistema separados, y mejor usar los comandos de copiado y pegado personalizados para que si se quiere se pasen los datos de un portapapeles a otro.

### Los que usa Gentleman Programming
