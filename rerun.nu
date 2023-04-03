# Watch the output of a command. Similar to watch(1) but with a closure.
export def main [
    closure: closure                  # The closure run on each iteration.
    --interval (-n): duration = 2sec  # The interval between iterations.
] {
    loop {
        clear
        do $closure
        sleep $interval
    }
}
