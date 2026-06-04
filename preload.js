const { contextBridge, ipcRenderer } = require('electron');

contextBridge.exposeInMainWorld('electronAPI', {
  onMenuExport: (callback) => ipcRenderer.on('menu-export', callback),
  onMenuOpen: (callback) => ipcRenderer.on('menu-open', callback),
  onMenuNew: (callback) => ipcRenderer.on('menu-new', callback),
  exportCanvas: (pngDataUrl) => ipcRenderer.invoke('export-canvas', pngDataUrl),
  openJSON: () => ipcRenderer.invoke('open-json'),
  windowControl: (action) => ipcRenderer.send('window-control', action),
  openExternal: (url) => ipcRenderer.invoke('open-external', url),
  checkForUpdates: () => ipcRenderer.send('check-for-updates'),
  onUpdateStatus: (callback) => ipcRenderer.on('update-status', (event, data) => callback(data))
});
