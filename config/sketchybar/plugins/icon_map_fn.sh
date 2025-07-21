function icon_map() {
  case "$1" in
  "Keynote")
    icon_result="󰐨"
    ;;
  "Figma")
    icon_result=""
    ;;
  "Alacritty" | "Hyper" | "iTerm2" | "kitty" | "Terminal" | "ghostty" | "WezTerm")
    icon_result=""
    ;;
  "App Store")
    icon_result=""
    ;;
  "CleanMyMac X")
    icon_result="󰇄"
    ;;
  "Discord" | "Discord Canary" | "Discord PTB")
    icon_result=""
    ;;
  "Telegram")
    icon_result=""
    ;;
  "1Password")
    icon_result="󰟵"
    ;;
  "Finder")
    icon_result="󰀶"
    ;;
  "Notes" | "Obsidian")
    icon_result=""
    ;;
  "Notion")
    icon_result=""
    ;;
  "Linear")
    icon_result="󰂶"
    ;;
  "Chromium" | "Google Chrome" | "Google Chrome Canary" | "Vivaldi")
    icon_result=""
    ;;
  "Firefox" | "Zen")
    icon_result=""
    ;;
  "Slack")
    icon_result=""
    ;;
  "Spotify")
    icon_result=""
    ;;
  "Default")
    icon_result=":default:"
    ;;
  "Pages" | "Pages 文稿")
    icon_result="󰈙"
    ;;
  "Canary Mail" | "HEY" | "Mail" | "Spark")
    icon_result=""
    ;;
  "Music")
    icon_result="󰝚"
    ;;
  "Calendar" | "Notion Calendar")
    icon_result=""
    ;;
  "Safari" | "Safari Technology Preview")
    icon_result=""
    ;;
  "Numbers")
    icon_result="󰧷"
    ;;
  "zoom.us" | "Facetime")
    icon_result=""
    ;;
  "Preview")
    icon_result="󰈦"
    ;;
  "Audacity")
    icon_result="󰗅"
    ;;
  "Cypress")
    icon_result=""
    ;;
  "Podcasts")
    icon_result=""
    ;;
  "OBS")
    icon_result="󰕵"
    ;;
  "OrbStack")
    icon_result=""
    ;;
  "Messages")
    icon_result="󰵅"
    ;;
  "Grammarly Editor")
    icon_result="󰗊"
    ;;
  "System Preferences" | "System Settings" | "系统设置")
    icon_result=""
    ;;
  "WhatsApp" | "WhatsApp Desktop" | "Whats App" | "WhatsApp (Geral)")
    icon_result=""
    ;;
  *)
    icon_result=":default:"
    ;;
  esac
}

icon_map "$1"

echo "$icon_result"
