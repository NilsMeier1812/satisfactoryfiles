@echo off
setlocal

:: --- KONFIGURATION (BITTE ANPASSEN) ---

:: 1. Wo liegt das Git-Repository? (Variable umbenannt!)
set "REPO_PATH=C:\Users\Nils\Documents\Satisfactory_Git\satisfactoryfiles"

:: 2. Wo speichert Satisfactory wirklich? (Local AppData)
:: Pfad ist meistens: C:\Users\DEINNAME\AppData\Local\FactoryGame\Saved\SaveGames
set "GAME_SAVE_DIR=C:\Users\Nils\AppData\Local\FactoryGame\Saved\SaveGames\2025_26"

:: 3. Spiel Startbefehl (Steam ID für Satisfactory ist 526870)
set "GAME_EXE=start steam://rungameid/526870"

:: --------------------------------------

echo ==========================================
echo  1/5: Gehe zum Git Repository...
echo ==========================================
cd /d "%REPO_PATH%"

echo.
echo ==========================================
echo  2/5: Hole neusten Stand vom Server (Pull)...
echo ==========================================
git pull
if %errorlevel% neq 0 (
    echo.
    echo [FEHLER] Git Pull fehlgeschlagen!
    echo Skript wird gestoppt.
    pause
    exit /b
)

echo.
echo ==========================================
echo  3/5: Kopiere Savegames ins Spiel-Verzeichnis...
echo ==========================================
robocopy "%REPO_PATH%" "%GAME_SAVE_DIR%" /MIR /XD .git
if %errorlevel% geq 8 (
    echo [FEHLER] Beim Kopieren ins Spiel-Verzeichnis.
    pause
    exit /b
)

echo.
echo ==========================================
echo  4/5: Starte Satisfactory und WARTE...
echo ==========================================
echo Spiel laeuft...
start /wait "" %GAME_EXE%

echo.
echo ==========================================
echo  5/5: Spiel beendet. Kopiere zurueck & Upload...
echo ==========================================

:: Zurück ins Git-Repo kopieren
robocopy "%GAME_SAVE_DIR%" "%REPO_PATH%" /MIR /XD .git

:: Upload
git add .
git commit -m "Satisfactory Sync: %date% %time%"
git push

echo.
echo ==========================================
echo  FERTIG!
echo ==========================================
timeout /t 5