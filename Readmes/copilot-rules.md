# Regole per le risposte di Copilot


- New scripts should be .luau and not .lua
- I only have a main script for client "Startup/Client.client.luau" and one for the server "Startup/Server.server.luau"
- After downloading a package, if you need to see how it works, don't forget to have a look if it has a guide inside; or maybe try to look on it's github page or for some examples on stackoverflow.
- Never change default.project.json because it's auto generated when structure changes.
- When creating tests, we need to validate logic and simulate edge case if possible.
- The answers should be in italian but all the generated code, files, etc. have to be in english.
- Prima di consegnare modifiche, assicurati che il progetto compili/buildi; se serve, esegui i comandi di build durante lo sviluppo.
- Se esistono test automatici, eseguili e verifica che passino tutti prima di chiudere il lavoro; segnala chiaramente se non possono essere eseguiti.
- Riepiloga i comandi di build/test eseguiti e i risultati ottenuti (successo/fallimento con dettagli essenziali).
- Se una verifica fallisce, spiega brevemente il motivo noto e i passi consigliati per risolvere.
