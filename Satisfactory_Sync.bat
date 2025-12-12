@echo off
setlocal

:: --- KONFIGURATION (Vom anderen Skript kopieren!) ---

:: 1. Wo liegt das Git-Repository? (Variable umbenannt!)
set "REPO_PATH=C:\Users\Nils\Documents\Satisfactory_Git\satisfactoryfiles"

:: 2. Wo speichert Satisfactory wirklich? (Local AppData)
set "GAME_SAVE_DIR=C:\Users\Nils\AppData\Local\FactoryGame\Saved\SaveGames\2025_26"

:: --------------------------------------

echo ==========================================
echo  MANUELLER SYNC GESTARTET
echo ==========================================

:: 1. Zum Repo gehen
cd /d "%REPO_PATH%"

:: 2. Erstmal lokale Savegames ins Repo sichern (damit wir was zum Committen haben)
echo.
echo [1/4] Kopiere aktuelle Savegames in den Git-Ordner...
robocopy "%GAME_SAVE_DIR%" "%REPO_PATH%" /MIR /XD .git

:: 3. Commit (Lokal speichern)
echo.
echo [2/4] Erstelle Git Commit...
git add .
git commit -m "Manueller Sync: %date% %time%"

:: 4. Pull (Vom Server holen)
echo.
echo [3/4] Hole Updates vom Server (Pull)...
git pull
if %errorlevel% neq 0 (
    echo.
    echo [ACHTUNG] Konflikt oder Fehler beim Pull. 
    echo Bitte pruefen!
    pause
    exit /b
)

:: 5. Push (Zum Server senden)
echo.
echo [4/4] Lade Daten hoch (Push)...
git push

:: 6. WICHTIG: Falls durch den Pull neue Daten kamen, müssen die ins Spiel!
echo.
echo [Final] Aktualisiere Spiel-Ordner mit neuesten Daten...
robocopy "%REPO_PATH%" "%GAME_SAVE_DIR%" /MIR /XD .git

echo.
echo ==========================================
echo  SYNC ERFOLGREICH!
echo ==========================================
timeout /t 3