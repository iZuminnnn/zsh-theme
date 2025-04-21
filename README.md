# Zsh Custome Theme

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)  
[![Zsh Version](https://img.shields.io/badge/Zsh-5.0%2B-brightgreen)](https://www.zsh.org/)  
**A dynamic, humorous, and feature-rich Zsh configuration that combines productivity with playful developer trolling.**

---

## 📖 Overview

**Zsh Troll Prompt** is a custom Zsh configuration designed to enhance your terminal experience with a mix of utility and entertainment. It delivers real-time system insights (e.g., weather, Git status, CPU usage) while playfully "trolling" you with witty Vietnamese developer-centric quotes. Perfect for coders who want a bit of fun alongside their workflow!

---

## ✨ Key Features

- **Humorous Troll Quotes**: Randomized, colorful developer quips like _"Đã debug gì chưa hay đổ lỗi cho intern người đẹp?"_.
- **Real-Time Weather**: Fetches weather updates for Hanoi (customizable) with emoji-enhanced output.
- **Smart Prompt**: Displays username, hostname, Git branch, virtual environment, and command execution time.
- **CPU Monitoring**: Alerts with funny messages when CPU usage exceeds 70%.
- **Time-Based Trolling**: Context-aware messages based on the time of day.
- **Cross-Platform Support**: Compatible with macOS, Linux, and Windows (via WSL/MSYS/Cygwin).

---

## 🛠️ Requirements

| Component    | Requirement           | Notes                           |
| ------------ | --------------------- | ------------------------------- |
| Shell        | Zsh 5.0+              | Install via package manager     |
| Network      | Internet connection   | For weather updates via wttr.in |
| Optional     | zsh-autosuggestions   | For command suggestion          |
| Supported OS | macOS, Linux, Windows | Windows requires WSL/Cygwin     |

---

## 🚀 Installation

1. **Clone or Copy the Configuration**  
   Add the script to your `~/.zshrc`:

   ```bash
   curl -o ~/.zshrc https://raw.githubusercontent.com/iZuminnnn/zsh-theme/main/.zshrc
   ```

2. **Install Zsh Autosuggestions (Optional)**
   Enable command suggestions:

   ```bash
   git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
   ```

3. **Apply the Configuration**
   Reload your shell:

   ```bash
   source ~/.zshrc
   ```

4. **Customize (Optional)**

   - Edit `weather_icon` to change the location (e.g., replace hanoi with your city).
   - Modify `troll_quotes` to add your own humorous lines.

5. **📸 Preview**

   ```bash
   Đã commit gì chưa hay để git blame người đẹp?
   Thời tiết hôm nay: ☀️ Sunny, perfect for some outdoor debugging! 25°C
   🌞 user@machine ~/code (🐍 myenv) (🌿 main)
    ➜
   ```

6. **How It Works**

   - Troll Quotes: Triggered on shell startup or `clear`, with ANSI-colored randomness.
   - Weather Updates: Cached every 5 minutes from `wttr.in`, paired with emojis and witty remarks.
   - Prompt Details: Includes time-of-day icons, Git status with dirty/clean indicators, and virtual env info.
   - CPU Alerts: Monitors usage across platforms, trolling you when it spikes.
   - Command Feedback: Context-sensitive trolling for common commands like `git commit` or `npm`.

7. **🧩 Customization**

   - Location: Update `curl -s "wttr.in?format=%C+%t&location=hanoi"` in `weather_icon`.
   - Quotes: Extend the `troll_quotes` array with your own lines.
   - Colors: Adjust `troll_colors` for different ANSI color codes.

8. **🐛 Troubleshooting**

   - Weather not loading? Ensure an active internet connection and check `curl` availability.
   - CPU monitoring issues? Some Windows setups may require additional tools (e.g., `wmic` or `PowerShell`).
   - Missing suggestions? Verify `zsh-autosuggestions` is installed and sourced.

9. **🤝 Contributing**
   - We welcome contributions! To get started:
     1. Fork this repository.
     2. Create a feature branch (git checkout -b feature/amazing-troll).
     3. Commit your changes (git commit -m "Add new troll quote").
     4. Push to the branch (git push origin feature/amazing-troll).
     5. Open a Pull Request.
10. ** Set zsh auto run when open terminal:
    - Open bashrc file
       ```bash
      nano ~/.bashrc
      ```
    - Add it
      ```bash
      if [ -t 1 ]; then
        exec zsh
      fi
      ```
---

## 📜 License

- This project is licensed under the MIT License.

## 🙌 Acknowledgments

- Inspired by the Vietnamese developer community's love for humor and code.
- Powered by wttr.in for weather data.
- Built with ❤️ by iZuminnnn.

_Code smarter, laugh harder!_
