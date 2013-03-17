name "base"
description "This is my base workstation role"

run_list(
  "recipe[build-essential]",
  "recipe[git]",
  "recipe[users]"
)


