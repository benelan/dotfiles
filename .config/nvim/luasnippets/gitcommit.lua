---@diagnostic disable: undefined-global
local regular = {}
local auto = {
  s({ trig = "ccl", name = "Cleanup commit" }, {
    t "chore: cleanup",
  }),
  s({ trig = "sk", name = "Skip CI" }, {
    t "[skip ci]",
  }),
}

return regular, auto
