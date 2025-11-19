# Guida Setup genRojoTree

## Introduzione

Il tool `genRojoTree.js` è uno script che permette di automatizzare la gestione della struttura del progetto Roblox, mantenendo una struttura compatta in VS Code e generando automaticamente il file `default.project.json` per Rojo.

## Obiettivi

- **Struttura compatta**: Mantenere una struttura del progetto più organizzata in VS Code
- **Distribuzione automatica**: I file vengono automaticamente distribuiti nelle giuste posizioni in Roblox Studio:
  - `Client.luau` e `Utils.luau` → **ReplicatedStorage**
  - `Server.luau` → **ServerScriptService**
- **Hot reloading**: Aggiornamento automatico del file `default.project.json` ad ogni modifica dei file sorgente

## Crediti

- **Progetto originale**: [leifstout/genRojoTree](https://github.com/leifstout/genRojoTree)
- **Tutorial YouTube**: [Roblox TypeScript Tutorial](https://www.youtube.com/watch?v=ouNVJcGH9MA) (timestamp: 6:10:16)

## Struttura del Progetto

```
src/
├── classes/          # Classi condivise
├── modules/          # Moduli utility
├── services/         # Servizi del gioco
│   └── <NomeServizio>/
│       ├── Client.luau    # Logica client
│       ├── Server.luau    # Logica server
│       └── Utils.luau     # Utility condivise (opzionale)
├── startup/          # Script di avvio
│   ├── Client.client.luau
│   └── Server.server.luau
└── ui/              # Interfacce utente
```

## Setup Completo

### 1. Configurazione VS Code

Sono necessari due file nella cartella `.vscode/`:

#### `.vscode/settings.json`
```json
{
    "stylua.targetReleaseVersion": "latest",
    "workbench.editor.customLabels.patterns": {
        "**/init.lua": "${dirname} (${filename}.${extname})",
        "**/init.luau": "${dirname} (${filename}.${extname})",
        "**/Client.luau": "${dirname}${filename}.${extname}",
        "**/Server.luau": "${dirname}${filename}.${extname}",
        "**/Utils.luau": "${dirname}${filename}.${extname}",
        "**/*.json": "${filename}",
        "**/*.js": "${filename}"
    }
}
```

> **Nota**: Questa configurazione permette di visualizzare i file con nomi più descrittivi nei tab di VS Code (es. "TestServiceClient.luau" invece di "Client.luau")

#### `.vscode/tasks.json`
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "label": "Watch Rojo Tree",
            "type": "shell",
            "command": "npm run watch:rojo",
            "options": {
                "shell": {
                    "executable": "cmd.exe",
                    "args": ["/d", "/c"]
                }
            },
            "isBackground": true,
            "problemMatcher": [],
            "group": {
                "kind": "build",
                "isDefault": true
            }
        }
    ]
}
```

### 2. Inizializzazione del Progetto Node.js

Apri un terminale Git Bash nella root del progetto e esegui:

```bash
# Inizializza package.json
npm init -y

# Installa chokidar-cli per il file watching
npm install --save-dev chokidar-cli
```

### 3. Configurazione Script NPM

Aggiungi questi script al `package.json`:

```json
"scripts": {
    "test": "echo \"Error: no test specified\" && exit 1",
    "build:rojo": "node tools/genRojoTree.js",
    "watch:rojo": "chokidar \"src/**/*\" -c \"npm run build:rojo\""
}
```

**Spiegazione script:**
- `build:rojo`: Esegue il tool per generare/aggiornare `default.project.json`
- `watch:rojo`: Monitora la cartella `src/` e rigenera automaticamente il file ad ogni modifica

### 4. Setup Rojo

Installa e configura Rojo:

```bash
# Aggiorna rokit
rokit.exe self-update

# Inizializza rokit nel progetto
rokit init

# Installa Rojo
rokit add rojo

# Inizializza il progetto Rojo
rojo init
```

### 5. Avvio del Watch Mode

1. Apri VS Code
2. Premi `Ctrl+Shift+P`
3. Seleziona "Tasks: Run Task"
4. Scegli "Watch Rojo Tree"

Da questo momento, ogni modifica ai file nella cartella `src/` aggiornerà automaticamente `default.project.json`.

## Personalizzazione

### Configurazione del Nome Progetto

Nel file `tools/genRojoTree.js`, modifica la proprietà `name` con il nome del tuo progetto:

```javascript
const tree = {
    name: "il-tuo-progetto",  // ← Modifica qui
    tree: {
        // ... resto della configurazione
    }
};
```

### Rimozione CustomPackages (se presente)

Se nel file `genRojoTree.js` è presente una sezione `CustomPackages` sotto `tree.ReplicatedStorage`, rimuovila se non necessaria.

## File da Committare

Assicurati di committare questi file nel repository:
- ✅ `default.project.json`
- ✅ `package.json`
- ✅ `package-lock.json`
- ❌ `sourcemap.json` (viene rigenerato automaticamente)

> **Nota**: Se il file `sourcemap.json` dovesse dare problemi, eliminalo e riavvia VS Code per farlo rigenerare dal Luau Language Server.

## Troubleshooting

### Problemi Comuni

1. **Il task non si avvia**: Verifica che `chokidar-cli` sia installato correttamente
2. **File non aggiornato**: Controlla che il nome del progetto in `genRojoTree.js` sia corretto
3. **Errori di sincronizzazione**: Elimina `sourcemap.json` e riavvia VS Code

### Verifica Funzionamento

Per testare che tutto funzioni:
1. Modifica un file in `src/services/`
2. Controlla che `default.project.json` venga aggiornato
3. Verifica la console del task "Watch Rojo Tree" per eventuali errori

## Estensioni VS Code Consigliate

- **Luau Language Server**: Intellisense e import automatici per Luau
- **Rojo - Roblox Studio Sync**: Integrazione con Rojo
- **GitHub Copilot Chat**: Assistant AI per coding
- **Selene**: Linting per Luau
- **StyLua**: Formattazione automatica del codice

## Come Funziona

Il tool `genRojoTree.js`:
1. Scansiona ricorsivamente la cartella `src/`
2. Analizza i nomi dei file per determinare la destinazione (Server vs Client)
3. Genera la struttura appropriata in `default.project.json`
4. I file `*Server.luau` vanno in **ServerScriptService**
5. Tutti gli altri file vanno in **ReplicatedStorage**
6. Applica la convenzione PascalCase ai nomi delle cartelle