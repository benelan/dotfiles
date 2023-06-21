---@diagnostic disable: undefined-global
return {
  s(
    { trig = "pr", name = "print var", dscr = "Print a variable" },
    fmt("fmt.Println({})", {
      i(1, "value"),
    })
  ),
}
