# Strip the pathname from a process name.
#
# This will try to keep any trailing numeric components,
# which are often used by the kernel to differentiate
# IRQ handlers and other kernel threads.
#
#   > "/usr/bin/example/0-extra" | strip-process-path
#   "example/0-extra"
export def strip-process-path [] {
    # Detect whether we're being called on a list,
    # and if so, process each item in the list.
    let input = $in
    if ($input | describe --no-collect) =~ "^list<" {
        return ($input | each {|it| $it | strip-process-path})
    }

    # Otherwise assume we're being called on a string.
    let components = ($input | split row "/")

    # Iterate backwards through the components, keeping
    # all of them until we reach the rightmost non-numeric
    # component of the path.
    mut keep = []
    for c in ($components | reverse) {
        $keep = ($keep | prepend $c)
        if $c =~ "^[^0-9]" {
            break
        }
    }

    # Join our components back together.
    $keep | str join "/"
}

# Print aggregate stats for all processes.
#
#     > ps-agg | sort-by -r cpu | where cpu > 0.0
#     #      name        cpu      mem      virtual  
#     ───────────────────────────────────────────────
#     0   nu            26.14    76.3 MB     2.7 GB 
#     1   slack          7.19     1.1 GB   333.2 GB 
#     2   Xorg           7.14   519.4 MB    27.3 GB 
#     3   pulseaudio     7.09    36.2 MB     4.6 GB 
#     4   gnome-shell    7.09   989.5 MB    10.4 GB 
export def main [
    --full-path (-l) # Include the full path to the process.
    --pids (-p)      # Include all PIDs.
] {
    # Build our full result.
    let result = (
        ps |
        # Strip trailing numbers and leading paths from process names.
        upsert name {|it|
            if $full_path { $it.name } else { $it.name | strip-process-path }
        } |
        # Group processes with the same name.
        group-by name |
        # Convert our { name: rows } map into [{ name: name, rows: rows }]. 
        transpose name rows |
        # Convert each row into a new row with aggregate stats.
        each {|it|
            {
                name: $it.name,
                cpu: ($it.rows | get cpu | math sum),
                mem: ($it.rows | get mem | math sum),
                virtual: ($it.rows | get virtual | math sum),
                processes: ($it.rows | length),
                pids: ($it.rows | get pid),
            }
        }
    )

    # Only return PIDs if someone asked for them.
    if $pids {
        $result
    } else {
        $result | reject pids
    }
}
