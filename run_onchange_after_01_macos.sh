#!/usr/bin/env bash

###############################################################################
# Notes                                                                       #
###############################################################################

# `defaults read` is good for seeing all currently set preferences
# `defaults find <STRING>` is good for searching for set preferences
# `defaults read <DOMAIN>` will give all preferences for a domain
# `defaults read <DOMAIN> <KEY>` will give specific preferences for a key
# `defaults read-type <DOMAIN> <KEY>` will give you the value type for a key (e.g. bool, int, etc.)


# Consider backing up the following:
# - NSGlobalDomain
# - com.apple.AppleMultitouchMouse
# - com.apple.driver.AppleBluetoothMultitouch.mouse
# - com.apple.AppleMultitouchTrackpad
# - com.apple.driver.AppleBluetoothMultitouch.trackpad
# - -currentHost com.apple.controlcenter

###############################################################################
# Let's go!                                                                   #
###############################################################################

# Ask for the administrator password upfront
cat <<- EOF
###############################################################################
### Configure macOS settings

EOF

read -p "Do you want to continue? (y/N) " answer

if [[ "$answer" == [yY] ]]; then
  echo "Writing macOS settings..."
else
  echo "Moving on..."
  exit 0
fi

sudo -v

# Keep-alive: update existing `sudo` time stamp until `.osx` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Set dark theme
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Turn off two finger swipe back & forward (pages, web history, etc.)
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool false
# Restore windows & documents when re-opening app:
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool true
# Click scrollbar to jump to spot that's clicked
defaults write NSGlobalDomain AppleScrollerPagingBehavior -int 1

# Disable "smart" capitalization, dashes, periods, quotes, and spell correct
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

###############################################################################
# MenuBar & Control Center                                                    #
###############################################################################

# Hide WiFi from menu bar
defaults -currentHost write com.apple.controlcenter WiFi -int 24
# Hide Bluetooth from menu bar
defaults -currentHost write com.apple.controlcenter Bluetooth -int 24
# Hide User Switcher from menu bar
defaults -currentHost write com.apple.controlcenter UserSwitcher -int 24
# Show Focus/DoNotDisturb when active
defaults -currentHost write com.apple.controlcenter DoNotDisturb -int 8
# Hide Spotlight from menu bar
defaults -currentHost write com.apple.Spotlight MenuItemHidden -bool true

# 24 hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true
defaults write com.apple.menuextra.clock Show24HourTime -bool true

###############################################################################
# Trackpad, mouse, keyboard, Bluetooth accessories, and input                 #
###############################################################################

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true

# Enable three finger drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2.5

# Turn on Force Click
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true
defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -int 1

# Force click threshold (0 = light, 1 = medium, 2 = firm)
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 0

# Use scroll gesture to zoom...
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true

# ...with the Ctrl (^) modifier key
defaults write com.apple.AppleMultitouchTrackpad HIDScrollZoomModifierMask -int 262144

# Zoom should use smoothing instead of nearest neighbor.
defaults write com.apple.universalaccess 'closeViewSmoothImages' -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 2

# navigate all menus, etc. with tab (blue outline macOS interface elements)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 2

# Pressing the fn/globe button does nothing ("1" to Change input source, "2" to open Emoji & Symbols, "3" to Start dictation)
defaults write com.apple.HIToolbox AppleFnUsageType -int 0

# (default) Pressing a function key will perform the special feature printed on that key.
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

###############################################################################
# Sounds                                                                      #
###############################################################################

# turn off interface sounds (e.g. screenshot)
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 0

# turn on feedback when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 1

# set feedback sound (the "error bleep")
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Purr.aiff"

###############################################################################
# Screen, Display, & Power                                                    #
###############################################################################

# Save screenshots to the desktop
defaults write com.apple.screencapture location -string "~/Library/CloudStorage/GoogleDrive-chris.j.lebron@gmail.com/My Drive/Cloud Desktop"

# Hide all desktop icons
defaults write com.apple.finder CreateDesktop -bool false

# Start screen saver when inactive for 5 minutes
defaults -currentHost write com.apple.screensaver idleTime 300

# Require password after screen saver begins or display is turned off after 1 minute
defaults -currentHost write com.apple.screensaver askForPasswordDelay -int 60
defaults -currentHost write com.apple.screensaver askForPassword -int 1

# Turn display off on battery when inactive for 10 minutes
sudo pmset -b displaysleep 10

# Turn display off on power adapter when inactive for 20 minutes
sudo pmset -c displaysleep 20

###############################################################################
# Finder                                                                      #
###############################################################################

# Enable spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Disable recent and suggested apps from dock
defaults write com.apple.dock "show-recents" -bool "false"

###############################################################################
# Rectangle.app                                                               #
###############################################################################

# Set up my preferred keyboard shortcuts
cp ./RectangleConfig.json '~/Library/Application Support/Rectangle/RectangleConfig.json'

###############################################################################
# Prompt to set manually                                                      #
###############################################################################

cat <<- EOF
  Complete!

  ###############################################################################
  ### Manual next steps

  Keyboard Backlight:
    System Settings -> Keyboard
    -> Adjust keyboard brightness in low light -> Enable
    -> Turn off keyboard backlight off after inactivity -> 5 seconds

  Keyboard Shortcuts:
    Screenshots:
      Disable: Save picture of screen as a file
      Disable: Copy picture of screen to clipboard
      Enable -> shift+cmd+4: Save picture of selected area as a file
      Enable -> shift+cmd+2: Copy picture of selected area to clipboard
    Spotlight:
      Enable -> opt+Space: Show Spotlight search
      Disable: Show Finder search window

  Display:
    System Settings -> Displays
      -> Automatically adjust brightness -> Disable
      -> Night Shift...
        -> Schedule -> Sunset to Sunrise
        -> Color Temp -> mid

  Battery:
    Low power mode -> never
    -> Options
      Slightly dim the display on battery -> disabled

  Finder -> View -> Show path bar
EOF

###############################################################################
# Kill affected applications                                                  #
###############################################################################

# for app in "Dock" "Finder" "Rectangle" "SystemUIServer" "Terminal"; do
# 	killall "${app}" > /dev/null 2>&1
# done
echo "Done. Restart your laptop for all changes to take effect."
