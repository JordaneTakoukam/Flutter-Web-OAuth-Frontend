@echo off
title Flutter Web Server

echo.
echo   ================================================
echo.
echo       Starting Flutter Web Server...
echo        App: http://localhost:3000
echo.
echo   ================================================
echo   Press Ctrl+C to stop
echo   ================================================
echo.

flutter run -d web-server --web-port 3000
