---@diagnostic disable: undefined-global
local auto = {}
local regular = {
  s({ trig = "ch", name = "Cleanup commit" }, {
    t("chore: cleanup"),
  }),
  s({ trig = "sk", name = "Skip CI" }, {
    t("[skip ci]"),
  }),
}

return regular, auto
