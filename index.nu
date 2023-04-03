# Include this from config.nu using `source "src/nushell/index.nu"`.

# Import modules and all the exported commands they define.
#
# Generate this using:
#
#   ls *.nu | get name | where $it != "index.nu" | sort | each {|it| print $"use \"($it)\" *" }
use "ps-agg.nu" *
use "rerun.nu" *
