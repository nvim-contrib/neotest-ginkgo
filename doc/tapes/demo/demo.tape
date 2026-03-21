# GIF — Neotest Ginkgo test tree

Output demo.webp

Set Shell "zsh"
Set FontSize 18
Set Width 1200
Set Height 700
Set Theme "Catppuccin Mocha"
Set FontFamily "JetBrainsMono Nerd Font"
Set Framerate 15
Set CursorBlink false
Set Padding 20
Set TypingSpeed 75ms

Hide
Type "clear"
Enter
Sleep 500ms
Show

Type "nvim calculator/nested_test.go"
Enter
Sleep 3s

# Open test summary with <leader>T<CR>
Space
Sleep 300ms
Type "T"
Enter
Sleep 2s

# Run all tests in file with <leader>Tf
Space
Sleep 300ms
Type "Tf"
Sleep 6s

# Pause to show the test tree with results
Sleep 3s

Type ":qa!"
Enter
