@echo off
REM ============================================================================
REM ONLINE BOOKSTORE - OPTIMIZED COMPILATION SCRIPT (FIXED DEPENDENCIES)
REM ============================================================================
REM This script compiles all Java classes in the correct order with proper
REM classpath configuration for the Online Bookstore web application.
REM 
REM Author: Bookstore Development Team
REM Version: 2.1 (Dependency Fix)
REM Last Updated: 2025-08-15
REM ============================================================================

echo.
echo ============================================================================
echo ONLINE BOOKSTORE - OPTIMIZED COMPILATION SCRIPT
echo ============================================================================
echo Starting compilation process...
echo.

REM Set color for better visibility
color 0A

REM Check if Java is available
java -version >nul 2>&1
if %errorlevel% neq 0 (
    color 0C
    echo ERROR: Java is not installed or not in PATH!
    echo Please install Java JDK and set JAVA_HOME environment variable.
    pause
    exit /b 1
)

REM Set classpath with all required libraries + compiled classes
set CLASSPATH=WEB-INF\classes;WEB-INF\lib\*;C:\apache-tomcat-9.0.104\lib\servlet-api.jar

echo Setting up classpath...
echo CLASSPATH: %CLASSPATH%
echo.

REM Create backup of existing class files
echo Creating backup of existing compiled classes...
if exist "WEB-INF\classes\backup" rmdir /s /q "WEB-INF\classes\backup"
mkdir "WEB-INF\classes\backup" 2>nul
xcopy "WEB-INF\classes\com" "WEB-INF\classes\backup\com\" /s /e /i /q 2>nul

echo.
echo ============================================================================
echo COMPILATION PHASE 1: UTILITY CLASSES
echo ============================================================================

echo Compiling DatabaseConnection utility...
javac -cp "%CLASSPATH%" -d WEB-INF\classes WEB-INF\classes\com\bookstore\util\DatabaseConnection.java
if %errorlevel% neq 0 goto :error
echo [OK] DatabaseConnection compiled successfully

echo.
echo ============================================================================
echo COMPILATION PHASE 2: MODEL CLASSES
echo ============================================================================

REM Compile all models together to avoid dependency issues
echo Compiling all model classes...
javac -cp "%CLASSPATH%" -d WEB-INF\classes WEB-INF\classes\com\bookstore\model\*.java
if %errorlevel% neq 0 goto :error
echo [OK] All model classes compiled successfully

echo.
echo ============================================================================
echo COMPILATION PHASE 3: DAO CLASSES
echo ============================================================================

echo Compiling DAO classes...
javac -cp "%CLASSPATH%" -d WEB-INF\classes WEB-INF\classes\com\bookstore\dao\*.java
if %errorlevel% neq 0 goto :error
echo [OK] DAO classes compiled successfully

echo.
echo ============================================================================
echo COMPILATION PHASE 4: SERVLET CLASSES
echo ============================================================================

echo Compiling Servlet classes...
javac -cp "%CLASSPATH%" -d WEB-INF\classes WEB-INF\classes\com\bookstore\servlet\*.java
if %errorlevel% neq 0 goto :error
echo [OK] Servlet classes compiled successfully

echo.
echo ============================================================================
echo COMPILATION COMPLETED SUCCESSFULLY!
echo ============================================================================
color 0A
echo All Java classes have been compiled successfully!
echo.
echo NEXT STEPS:
echo 1. Restart Apache Tomcat server
echo 2. Access the application at: http://localhost:8080/bookstore/
echo 3. Login with admin credentials: admin / admin123
echo.
echo For troubleshooting, check Tomcat logs at:
echo C:\apache-tomcat-9.0.104\logs\catalina.out
echo.
pause
exit /b 0

:error
color 0C
echo.
echo ============================================================================
echo COMPILATION FAILED!
echo ============================================================================
echo Please check the error messages above and fix the issues.
echo.
echo COMMON SOLUTIONS:
echo 1. Ensure all required JAR files are in WEB-INF\lib\
echo 2. Check JAVA_HOME environment variable
echo 3. Verify Tomcat installation path
echo 4. Review Java source code for syntax errors
echo.
echo Restoring backup files...
if exist "WEB-INF\classes\backup" (
    rmdir /s /q "WEB-INF\classes\com" 2>nul
    xcopy "WEB-INF\classes\backup\com" "WEB-INF\classes\com\" /s /e /i /q 2>nul
    rmdir /s /q "WEB-INF\classes\backup"
    echo Backup restored successfully.
)
echo.
pause
exit /b 1
