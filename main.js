const { app, BrowserWindow, Menu, dialog, ipcMain } = require('electron');
const path = require('path');
const fs = require('fs');

let mainWindow;

function createWindow() {
  mainWindow = new BrowserWindow({
    width: 1200,
    height: 800,
    frame: false,
    titleBarStyle: 'hidden',
    backgroundColor: '#f8f5f0',
    title: 'Inkline',
    icon: path.join(__dirname, 'appicon.ico'),
    webPreferences: {
      preload: path.join(__dirname, 'preload.js'),
      contextIsolation: true,
      nodeIntegration: false,
    }
  });

  mainWindow.loadFile(path.join(__dirname, 'excalidraw-clone.html'));
  // mainWindow.webContents.openDevTools();
  createMenu();
}

function createMenu() {
  const template = [
    {
      label: 'File',
      submenu: [
        {
          label: 'New Board',
          accelerator: 'CmdOrCtrl+N',
          click: () => {
            if (mainWindow) mainWindow.webContents.send('menu-new');
          }
        },
        {
          label: 'Open Board',
          accelerator: 'CmdOrCtrl+O',
          click: () => {
            if (mainWindow) mainWindow.webContents.send('menu-open');
          }
        },
        {
          label: 'Export as PNG',
          accelerator: 'CmdOrCtrl+S',
          click: () => {
            if (mainWindow) mainWindow.webContents.send('menu-export');
          }
        },
        { type: 'separator' },
        { role: 'quit', label: 'Exit' }
      ]
    },
    {
      label: 'Help',
      submenu: [
        {
          label: 'About',
          click: () => {
            dialog.showMessageBox(mainWindow, {
              type: 'info',
              title: 'About Inkline',
              message: 'Inkline Desktop',
              detail: 'A polished drawing application built with Electron.\n\nVersion 1.0.0'
            });
          }
        }
      ]
    }
  ];
  const menu = Menu.buildFromTemplate(template);
  Menu.setApplicationMenu(menu);
}

app.whenReady().then(() => {
  createWindow();
  app.on('activate', function () {
    if (BrowserWindow.getAllWindows().length === 0) createWindow();
  });
});

app.on('window-all-closed', function () {
  if (process.platform !== 'darwin') app.quit();
});

// IPC: Export canvas to file
ipcMain.handle('export-canvas', async (event, pngDataUrl) => {
  const result = await dialog.showSaveDialog(mainWindow, {
    defaultPath: 'whiteboard.png',
    filters: [{ name: 'PNG Images', extensions: ['png'] }]
  });
  if (!result.canceled) {
    const base64Data = pngDataUrl.replace(/^data:image\/png;base64,/, '');
    fs.writeFileSync(result.filePath, Buffer.from(base64Data, 'base64'));
    return { success: true, path: result.filePath };
  }
  return { success: false };
});

ipcMain.handle('open-json', async () => {
  const result = await dialog.showOpenDialog(mainWindow, {
    title: 'Open Whiteboard JSON',
    filters: [{ name: 'Whiteboard JSON', extensions: ['json'] }],
    properties: ['openFile']
  });
  if (result.canceled || !result.filePaths.length) {
    return { canceled: true };
  }
  const content = fs.readFileSync(result.filePaths[0], 'utf8');
  return { canceled: false, content, filePath: result.filePaths[0] };
});

ipcMain.handle('open-external', async (event, url) => {
  const { shell } = require('electron');
  await shell.openExternal(url);
  return { success: true };
});

ipcMain.on('window-control', (event, action) => {
  if (!mainWindow) return;
  switch (action) {
    case 'minimize':
      mainWindow.minimize();
      break;
    case 'maximize':
      mainWindow.isMaximized() ? mainWindow.unmaximize() : mainWindow.maximize();
      break;
    case 'close':
      mainWindow.close();
      break;
  }
});