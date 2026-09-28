# Contributing to Hyprland Setup

First off, thank you for considering contributing to **Hyprland Setup**! 🎉 It's people like you that make open-source software such an amazing environment to build upon.

Please take a moment to review this document before submitting your contributions.

---

## 🛠️ How Can I Contribute?

### 1. Reporting Bugs

If you encounter an issue or bug while using the script or configurations, please open a bug report:

- Check existing [Issues](https://github.com/ByTrist4n/hyprland-setup/issues) to ensure it hasn't already been reported.
- Include your system specifications (Arch Linux / CachyOS version, Hyprland version).
- Provide terminal logs or error output when running `setup.sh`.

### 2. Suggesting Enhancements

Have an idea for a new feature, Quickshell widget, or keybinding?

- Open a discussion in [GitHub Discussions](https://github.com/ByTrist4n/hyprland-setup/discussions) or create a Feature Request issue.
- Describe the feature clearly and explain why it would benefit the project.

### 3. Pull Requests (PRs)

We welcome PRs for bug fixes, code improvements, documentation updates, and new features!

To contribute code:

1. **Fork** the repository.
2. Clone your fork and initialize developer dependencies:
   ```bash
   git clone [https://github.com/YOUR-USERNAME/hyprland-setup.git](https://github.com/YOUR-USERNAME/hyprland-setup.git)
   cd hyprland-setup
   npm install
   ```
3. Create a new branch for your feature or bugfix:
   ```bash
   git checkout -b feature/my-new-feature
   ```
4. Make your changes. Code formatting will automatically run on commit via **Husky** and **lint-staged**.
5. Test the installer script in a clean environment or VM if possible.
6. Push to your branch and submit a Pull Request against the `main` branch.

---

## 📜 Development & Code Style Guidelines

We use **Husky**, **Prettier**, **StyLua**, and **qmlformat** to enforce consistent code style across the repository automatically.

### Automatic Pre-commit Formatting

Once you run `npm install`, git hooks are active. On every `git commit`, `lint-staged` will automatically format:

- **Shell scripts (`.sh`), JSON, Markdown, YAML**: Formatted with `prettier`.
- **Lua configs (`.lua`)**: Formatted with `stylua`.
- **Quickshell / QML components (`.qml`)**: Formatted with `qmlformat`.

You can also run the formatting manually across the entire workspace at any time:

```bash
npm run format
```
