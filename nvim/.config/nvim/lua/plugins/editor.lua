local function hsl_to_hex(h, s, l)
  h = h % 360
  s = math.min(math.max(s, 0), 100)
  l = math.min(math.max(l, 0), 100)
  h, s, l = h / 360, s / 100, l / 100

  local function hue_to_rgb(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end

  local r, g, b
  if s == 0 then
    r, g, b = l, l, l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue_to_rgb(p, q, h + 1 / 3)
    g = hue_to_rgb(p, q, h)
    b = hue_to_rgb(p, q, h - 1 / 3)
  end

  return string.format("#%02x%02x%02x", r * 255, g * 255, b * 255)
end

local function hsl_color_group(_, match)
  local content = match:match("^hsl%((.*)%)$")
  if not content then
    return nil
  end

  content = content:gsub(",", " "):gsub("%s*/%s*[%d.]+%%?%s*$", "")
  local number = "([+-]?%d*%.?%d+)"
  local h, s, l = content:match("^%s*" .. number .. "%s+" .. number .. "%%?%s+" .. number .. "%%?%s*$")
  if not h then
    return nil
  end

  return MiniHipatterns.compute_hex_color_group(hsl_to_hex(tonumber(h), tonumber(s), tonumber(l)), "bg")
end

return {
  {
    "rmagatti/goto-preview",
    event = "BufEnter",
    config = true,
    keys = {
      { "gpd", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", desc = "Preview definition" },
      { "gpD", "<cmd>lua require('goto-preview').goto_preview_declaration()<CR>", desc = "Preview declaration" },
      { "gpi", "<cmd>lua require('goto-preview').goto_preview_implementation()<CR>", desc = "Preview implementation" },
      {
        "gpy",
        "<cmd>lua require('goto-preview').goto_preview_type_definition()<CR>",
        desc = "Preview type definition",
      },
      { "gpr", "<cmd>lua require('goto-preview').goto_preview_references()<CR>", desc = "Preview references" },
      { "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", desc = "Close preview windows" },
    },
  },
  {
    "nvim-mini/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%([^)]*%)",
          group = hsl_color_group,
        },
      },
    },
  },
  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<Leader>gb",
        browse = "<Leader>go",
      },
    },
  },
}
