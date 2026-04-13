@echo off
cd /d "%~dp0"
start "Research Page Server" /min python -m http.server 8081
timeout /t 2 /nobreak > nul
start "" http://localhost:8081/research.htm
