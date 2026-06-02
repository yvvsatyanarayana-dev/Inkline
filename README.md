# Inkline

Inkline is a desktop sketching and diagram app built with Electron.
It supports drawing, exporting, saving boards, and packaging installers for Windows, Linux, and macOS.

## Features

- Smart canvas for diagrams, notes, and visuals
- Tools: rectangle, diamond, ellipse, arrow, line, pen, smart pen, text, image, eraser
- Save and load boards as JSON
- Export canvas to PNG
- Native desktop app packaging with icon support
- Update checking from GitHub releases

## Installing dependencies

```bash
npm install
```

## Running locally

```bash
npm start
```

## Packaging installers

### Windows

```bash
npm run dist:win
```

This creates a Windows NSIS installer under the `dist/` folder.

### Linux

```bash
npm run dist:linux
```

This creates a Linux AppImage file.

### macOS

```bash
npm run dist:mac
```

Use a Mac host to build the macOS `.dmg` package.

## Update checking

Inkline includes an update-check feature using GitHub Releases.

- A `Help > Check for Updates` menu item is available in the packaged app.
- The app checks GitHub releases and prompts to download the new version.
- When an update is ready, the installer restarts and installs it.

### Configure GitHub updates

Edit `package.json` and set the correct repository URL:

```json
"repository": {
  "type": "git",
  "url": "https://github.com/your-github-username/your-repo.git"
},
"publish": [
  {
    "provider": "github"
  }
],
```

Then publish new versions as GitHub Releases with the installer asset.

## Screenshots

Add images under `docs/images` and reference them here:

```md
![Inkline Screenshot](docs/images/inkline-demo.png)
```

## Notes

- `deskicon.ico` is used for the Windows app icon.
- `style.css` is included in the packaged build.
- Use GitHub releases if you want users to download installers without source.
