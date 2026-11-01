-- Base config shared by the user session and the greetd greeter
-- (hosts/common/greetd.nix). Keep it to what matters on both: monitor
-- layout, keyboard/input and cursor/GPU env - nothing session-specific.
require("base.env")
require("base.input")
require("base.monitors")
