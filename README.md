# Personal nushell commands

This repository contains a variety of personal [Nushell](https://www.nushell.sh/) commands.

In practice, Nushell turns out to be pleasant enough that I actually wind up writing more reusable commands that I did with traditional shells.

## What is Nushell?

Nushell is a cross-platform shell that works on structured data. Specifically:

- Unlike traditional Unix shells, which work on plain streams of text or binary data, Nushell works on structured data, including lists, tables, numbers, strings, and much more.
- Unlike Powershell, Nushell (normally) works on "plain" data, not on [objects with methods](https://petri.com/powershell-objects/).
- Unlike tools like [`jq`](https://stedolan.github.io/jq/), Nushell is a full shell, not just a tool for manipulating JSON. It also supports CSV, Toml, sqlite3 and other formats.
- Unlike writing automation in Python or Ruby, Nushell _feels_ like a shell. And you can gradually build up iteractive commands, and then turn them into scripts.

Finally, nushell is actually a pretty reasonable functional programming language.

## Using these scripts

You can load everything as follows:

```nu
source "nushell-commands/index.nu"
```

You can use `code $nu.config-path` to open Nushell's configuration file, and add that line at the end.
