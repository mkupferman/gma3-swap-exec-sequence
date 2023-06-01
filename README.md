# gma3-swap-exec-sequence

GrandMA3 Swap Exec's Sequence

## What is this?

This Lua plugin for GrandMA3 enables quick toggling of the sequence object assigned to an executor.
It also allows you to optionally preserve the running state and fader position,
applying it to the swapped-in sequence.

## Why?

I use this because I have two sequences that essentially do the inverse function of each other,
and I like to control it with the same playback fader. When the inverse function is needed, I have a
button mapped to a macro which swaps the sequence that's assigned to the playback.

# Usage

The plugin accepts a JSON string containing the arguments passed to it.

        call plugin <number|'name'> '{<json args}>}'

Required JSON arguments:

1. `exec` - _integer_: Playback executor number
2. `seq1` - _integer_ or _string_: First of two sequences to swap between (name or number)
3. `seq2` - _integer_ or _string_: Second of two sequences to swap between (name or number)

Optional JSON arguments:

1. `page` - _integer_: Executor playback page (defaults to _1_)
2. `preserve` - _boolean_: Preserve running state and fader position.

    If _true_ (the default), the state (on or off) of the executor as well as the
    executor fader position stored before swapping. After assigning the other sequence,
    the old sequence will be set _off_ and the swapped-in sequence will be set to _on_
    (only) if the old sequence was running.

    If _false_, the sequences will just be swapped via
    an _assign_ command.

## Examples

Two sequences (named "s1" and "s2") will be swapped into the playback on
Page 1, Executor 106, preserving the prior sequence's running state and fader value:

    call plugin "swapexecsequence" '{"exec": 106, "seq1": "s1", "seq2": "s2"}'

Two sequences (101 and 102) will be swapped into the playback on
Page 2, Executor 101. No action will be taken to turn sequences on/off or to set the fader values.

    call plugin "swapexecsequence" '{"page": 2, "exec": 101, "seq1": 101, "seq2": 102, "preserve": false}'

## Notes

Before calling the plugin, ensure the playback executor is set to one of the two sequences to be swapped.
The plugin is not designed to elegantly handle the case where it is not.
