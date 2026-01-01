# Where should we write the GIF?
Output demo.gif

# Set up a 960x540 terminal with 24px font.
Set Shell bash
Set FontSize 20
Set Width 960
Set Height 540
Set Padding 0

# Type a command in the terminal.
Hide

Type 'NVIM_DEMO_CONFIG="$(pwd)/demo.lua"'
Enter
Type 'nvim() { command nvim -u "$NVIM_DEMO_CONFIG"; }'
Enter
Type 'clear'
Enter

Show

Sleep 500ms

Type "nvim"
Sleep 500ms
Enter
Sleep 500ms

Type ":FloatmemoOpen"
Sleep 500ms
Enter
Sleep 500ms

Type "iHello"
Sleep 500ms
Escape
Sleep 500ms

Type ":FloatmemoClose"
Sleep 500ms
Enter
Sleep 500ms

Type ":q"
Sleep 500ms
Enter
Sleep 500ms

Type "cd .."
Sleep 500ms
Enter
Sleep 500ms

Type "nvim"
Sleep 500ms
Enter
Sleep 500ms

Type ":FloatmemoToggle"
Sleep 500ms
Enter
Sleep 500ms

Type "A World!"
Sleep 500ms
Escape
Sleep 500ms

Type ":FloatmemoToggle"
Sleep 500ms
Enter
Sleep 500ms

Type ":q"
Sleep 500ms
Enter
Sleep 500ms

Sleep 500ms

