-- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
return { settings = { workingDirectory = { mode = "auto" } } }
