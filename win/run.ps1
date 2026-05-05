# =========================
# Запускать на Windows 10+ с PowerShell 7+
# =========================

# =========================
# Кодировка UTF-8
# =========================
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

# =========================
# Чёрный фон окна
# =========================
$Host.UI.RawUI.BackgroundColor = "Black"
Clear-Host

# =========================
# Название и версия ПО
# =========================

$ABOUT = "451saver v3.5"

# Меняем заголовок окна
$Host.UI.RawUI.WindowTitle = $ABOUT

# =========================
# ANSI-цвета для консоли
# =========================

$NORMAL = "`e[0m"
$RED    = "`e[91m"
$GREEN  = "`e[32m"
$CYAN   = "`e[36m"
$GRAY   = "`e[90m"

# =========================
# Пути к файлам системные
# =========================

$SCRIPT_DIR = Split-Path -Parent $MyInvocation.MyCommand.Path

$YT_DLP_FILE = "$SCRIPT_DIR\win\yt-dlp.exe"
$JQ_FILE = "$SCRIPT_DIR\win\jq.exe"
$FFMPEG_FILE = "$SCRIPT_DIR\win\ffmpeg.exe"
$FFPROBE_FILE = "$SCRIPT_DIR\win\ffprobe.exe"
$MKVPROPEDIT_FILE = "$SCRIPT_DIR\win\mkvpropedit.exe"
$NODE_EXE = "$SCRIPT_DIR\win\node\node.exe"
$VOT_CLI_JS = "$SCRIPT_DIR\win\node\node_modules\vot-cli-live\src\index.js"

# =========================
# Интерфейс
# =========================

function logo {
    Clear-Host
    Write-Host "$($GRAY)█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█$($NORMAL)"
    Write-Host "$($GRAY)█     ██╗██╗███████╗  ███╗   ██████╗ █████╗ ██╗   ██╗███████╗██████╗    █$($NORMAL)"
    Write-Host "$($GRAY)█    ██╔╝██║██╔════╝ ████║  ██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗   █$($NORMAL)"
    Write-Host "$($GRAY)█   ██╔╝ ██║██████╗ ██╔██║  ╚█████╗ ███████║╚██╗ ██╔╝█████╗  ██████╔╝   █$($NORMAL)"
    Write-Host "$($GRAY)█   ███████║╚════██╗╚═╝██║   ╚═══██╗██╔══██║ ╚████╔╝ ██╔══╝  ██╔══██╗   █$($NORMAL)"
     Write-Host "$($GRAY)█   ╚════██║██████╔╝███████╗██████╔╝██║  ██║  ╚██╔╝  ███████╗██║  ██║   █$($NORMAL)"
    Write-Host "$($GRAY)█        ╚═╝╚═════╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   █$($NORMAL)"
    Write-Host "$($GRAY)███ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ███$($NORMAL)"
    Write-Host "$($GRAY)█▀$($NORMAL)                          $($GRAY)-  $ABOUT  -$($NORMAL)                        $($GRAY)▀█$($NORMAL)"
    Write-Host "$($GRAY)█ ▄$($NORMAL)                    $($GRAY)© 2016–2026 Dmitry Chushkin$($NORMAL)                    $($GRAY)▄ █$($NORMAL)"
    Write-Host "$($GRAY)█ ▓$($NORMAL)                            $($GRAY)dev@36pix.ru$($NORMAL)                           $($GRAY)▓ █$($NORMAL)"
    Write-Host "$($GRAY)▄ ▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓ ▄$($NORMAL)"
}

function leading_spaces {
    param($1)
    $i = 0
    for ($i = 0; $i -lt $1; $i++) {
        Write-Host " " -NoNewline
    }
}

function info_check {
    param($1, $2)
    $MSG = $2
    if ([string]::IsNullOrEmpty($MSG)) {
        Write-Host "`n"
        return
    }
    leading_spaces $1
    Write-Host "[${GREEN}v${NORMAL}] $MSG"
}

function info_uncheck {
    param($1, $2)
    $MSG = $2
    if ([string]::IsNullOrEmpty($MSG)) {
        Write-Host "`n"
        return
    }
    leading_spaces $1
    Write-Host "[${RED}x${NORMAL}] $MSG"
}

function info_color {
    param($1, $2, $3)
    $MSG = $2
    $MSG1 = $3
    if ([string]::IsNullOrEmpty($MSG) -and [string]::IsNullOrEmpty($MSG1)) {
        Write-Host "`n"
        return
    }
    # Если цвет не передан — используем NORMAL
    if ([string]::IsNullOrEmpty($MSG1)) { $MSG1 = $NORMAL }

    leading_spaces $1
    Write-Host -NoNewline "${MSG1}${MSG}${NORMAL}`n"
}

function info_color_bi {
    param($1, $2, $3, $4, $5, $6, $7)
    $MSG = $2
    $MSG1 = $3
    $MSG2 = $4
    $MSG3 = $5
    $MSG4 = $6
    $MSG5 = $7
    if ([string]::IsNullOrEmpty($MSG) -and [string]::IsNullOrEmpty($MSG1) -and [string]::IsNullOrEmpty($MSG2) -and [string]::IsNullOrEmpty($MSG3) -and [string]::IsNullOrEmpty($MSG4) -and [string]::IsNullOrEmpty($MSG5)) {
        Write-Host "`n"
        return
    }
    # Если цвет не передан — используем NORMAL
    if ([string]::IsNullOrEmpty($MSG1)) { $MSG1 = $NORMAL }
    if ([string]::IsNullOrEmpty($MSG3)) { $MSG3 = $NORMAL }
    if ([string]::IsNullOrEmpty($MSG5)) { $MSG5 = $NORMAL }

    leading_spaces $1
    Write-Host -NoNewline "${MSG1}${MSG}${NORMAL}"
    Write-Host -NoNewline "${MSG3}${MSG2}${NORMAL}"
    Write-Host "${MSG5}${MSG4}${NORMAL}"
}

function info_triple {
    param($1, $2, $3, $4)
    $MSG1 = $2
    $MSG2 = $3
    $MSG3 = $4

    if ([string]::IsNullOrEmpty($MSG1) -and [string]::IsNullOrEmpty($MSG2) -and [string]::IsNullOrEmpty($MSG3)) {
        Write-Host "`n"
        return
    }
    leading_spaces $1
    Write-Host "[${GREEN}v${NORMAL}] ${MSG1}${GREEN}${MSG2}${NORMAL}${MSG3}"
}

function error {
    param($1, $2)
    $MSG = $2
    if ([string]::IsNullOrEmpty($MSG)) {
        Write-Host "`n"
        return
    }
    leading_spaces $1
    Write-Host "${STRONG}${RED}[x ERROR] ${MSG}${NORMAL}"
}

function progress {
    param($1, $2)
    $spaces = $1
    $message = $2
    $spin = @('-', '\', '|', '/')
    $i = 0

    # Создаем строку с отступами
    $indent = " " * $spaces

    while ($true) {
        # Выводим отступ, сообщение, затем цветной спиннер и сброс
        Write-Host -NoNewline "`r$indent$message ${GREEN}$($spin[$i % 4])${NORMAL}"
        $i++
        Start-Sleep -Milliseconds 100
    }
}

function press_enter {
    Write-Host ""
    info_color 6 "Press Enter to restart or Ctrl+C to exit" $CYAN
    # -s: не выводить нажатый символ, -n 1: читать ровно 1 символ
    Read-Host -AsSecureString | Out-Null
}

function press_enter_repeat {
    error 6 "Press Enter to repeat..."
    # Скрыть курсор
    Write-Host -NoNewline "`e[?25l"
    Read-Host
}

function invalid_input {
    Write-Host ""
    error 6 "Invalid input, type [y/n]:"
    error 6 "Press Enter to repeat..."
    # Скрыть курсор
    Write-Host -NoNewline "`e[?25l"
    Read-Host
}

# =========================
# Функции общего назначения
# =========================

# Соответствие кодов языка YouTube (BCP 47) -> MKV (ISO 639-2)
function yt_to_mkv_lang {
    param($1)
    $youtube_lang = $1

    switch ($youtube_lang) {
        "ru" { Write-Output "rus" }
        { $_ -in "en", "en-US", "en-GB", "en-CA", "en-AU" } { Write-Output "eng" }
        "de" { Write-Output "ger" }
        "fr" { Write-Output "fre" }
        "es" { Write-Output "spa" }
        "it" { Write-Output "ita" }
        { $_ -in "pt", "pt-BR" } { Write-Output "por" }
        { $_ -in "zh", "zh-CN", "zh-TW" } { Write-Output "chi" }
        "ja" { Write-Output "jpn" }
        "ko" { Write-Output "kor" }
        "uk" { Write-Output "ukr" }
        "pl" { Write-Output "pol" }
        "nl" { Write-Output "dut" }
        "sv" { Write-Output "swe" }
        "no" { Write-Output "nor" }
        "da" { Write-Output "dan" }
        "fi" { Write-Output "fin" }
        "cs" { Write-Output "cze" }
        "sk" { Write-Output "slo" }
        "hu" { Write-Output "hun" }
        "ro" { Write-Output "rum" }
        "bg" { Write-Output "bul" }
        "sr" { Write-Output "srp" }
        "hr" { Write-Output "hrv" }
        "sl" { Write-Output "slv" }
        "et" { Write-Output "est" }
        "lv" { Write-Output "lav" }
        "lt" { Write-Output "lit" }
        "tr" { Write-Output "tur" }
        "ar" { Write-Output "ara" }
        "he" { Write-Output "heb" }
        "hi" { Write-Output "hin" }
        "id" { Write-Output "ind" }
        "th" { Write-Output "tha" }
        "vi" { Write-Output "vie" }
        default { Write-Output "und" }
    }
}

# Длительность видео
function duration {
    param($1)

    $video_file = $1

    $raw = & $FFPROBE_FILE `
        -v error `
        -show_entries format=duration `
        -of default=noprint_wrappers=1:nokey=1 `
        $video_file 2>$null

    # Защита от пустого/битого вывода
    if ([string]::IsNullOrWhiteSpace($raw)) {
        $global:DURATION = 0
    } else {
        $global:DURATION = [double]$raw
    }

    $duration_seconds = [math]::Floor($global:DURATION)

    $hours   = [math]::Floor($duration_seconds / 3600)
    $minutes = [math]::Floor(($duration_seconds % 3600) / 60)
    $seconds = $duration_seconds % 60

    # Форматируем уже безопасные int
    $global:DURATION_FORMATTED =
        ("{0:00}:{1:00}:{2:00}.000" -f `
        [int]$hours, [int]$minutes, [int]$seconds)
}

# Функция для очистки пути от экранирования
function clean_path {
    param($1)
    $input_path = $1

    # Удаляем кавычки, если они есть
    $input_path = $input_path -replace '^"', ''
    $input_path = $input_path -replace '"$', ''
    $input_path = $input_path -replace "^'", ''
    $input_path = $input_path -replace "'$", ''
    
    # Удаляем символы экранирования перед пробелами и спецсимволами
    # Но важно: не удаляем экранирование для скобок и других символов
    $input_path = $input_path -replace '\\ ', ' '
    $input_path = $input_path -replace '\\([][(){}])', '$1'
    
    Write-Output $input_path
}

# Очистить N строк вверх
function clear_lines {
    param($1)
    $n = $1
    for ($i = 0; $i -lt $n; $i++) {
        Write-Host -NoNewline "`e[2K" # очистить строку
        Write-Host -NoNewline "`e[1A" # вверх
    }
    Write-Host -NoNewline "`e[2K" # очистить текущую
}

# Функция возвращает ID видеоролика
function get_youtube_id {
    param($1)
    
    $id = $null
    $input_url = $1
    
    # Проверка: youtu.be/ID
    if ($input_url -match 'youtu\.be/([a-zA-Z0-9_-]{11})') {
        $id = $matches[1]
    }
    # Проверка: ?v=ID или &v=ID в URL
    elseif ($input_url -match '[?&]v=([a-zA-Z0-9_-]{11})') {
        $id = $matches[1]
    }
    # Проверка: просто 11-символьный ID
    elseif ($input_url -match '^[a-zA-Z0-9_-]{11}$') {
        $id = $input_url
    }
    
    if ([string]::IsNullOrEmpty($id)) {
        error 6 "Wrong ID video" 2>&1 | Out-Null
        return
    }
    info_triple 6 "URL/ID accepted: " "$id" "" 2>&1 | Out-Null
    Write-Output $id
    return
}

# Проверка зависимостей
function check_file {
    param($1, $2)
    $path = $1
    $name = $2

    if (-not (Test-Path -Path $path -PathType Leaf)) {
        error 3 "Not found: $name ($path)"
        return $false
    }

    return $true
}

# =========================
# Функции сетевые
# =========================

# Скачивание субтитров на нескольких языках
function download_multilang_subs {
    param($1, $2, $3)
    $video_url = $1
    $output_dir = $2
    $base_name = $3

    foreach ($lang in $subs_lang) {
        # Защита от бесполезного выполнения, если на итерации произошла ошибка
        if ($status -eq $false) {
            return $false
        }
        & $NODE_EXE $VOT_CLI_JS `
            --subs-srt `
            --reslang=$lang `
            --output=$output_dir `
            --output-file="${base_name}.${lang}.srt" `
            $video_url 2>$null >$null

        if (Test-Path -Path "${output_dir}/${base_name}.${lang}.srt" -PathType Leaf) {
            info_triple 6 "Subtitles " "$($lang.ToUpper())" " saved"
        } else {
            $lang_upper = $lang.ToUpper()
            $msg = "Subtitles $lang_upper not downloaded"
            error 6 "$msg"
            $global:current_ERROR = $msg
            $global:status = "false"
        }
    }
}

# Загрузка ИИ субтитров и голосового перевода
function voice_sub {
    # Условия выполнения задаются при вызове всей функции
    $global:subs_lang = @("ru", "en")
    $voice_lang = "ru"

    download_multilang_subs "https://www.youtube.com/watch?v=${YT_VIDEO_ID}" `
        "${PROJECT_DIR}" `
        "${FILENAME}" `
        $subs_lang

    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    if ($global:status -eq $false) {
        return $false
    }
    
    # Выводим начальный текст
    $spaces = " " * 9
    Write-Host "$spaces Voice downloading  " -NoNewline
    
    $spinner = @('\', '|', '/', '-')
    $i = 0
    $running = $true
    
    # Запускаем основную команду в фоновом задании
    $job = Start-Job -ScriptBlock {
        param($nodeExe, $votCli, $videoId, $voiceLang, $projectDir, $fileName)
        & $nodeExe $votCli `
            "https://www.youtube.com/watch?v=${videoId}" `
            --reslang=$voiceLang `
            --voice-style=live `
            --output="$projectDir" `
            --output-file="${fileName}.mp3" 2>$null >$null
    } -ArgumentList $NODE_EXE, $VOT_CLI_JS, $YT_VIDEO_ID, $voice_lang, $PROJECT_DIR, $FILENAME
    
    # Рисуем спиннер в основном потоке, пока задание выполняется
    while ($job.State -eq 'Running') {
        Write-Host "`b$GREEN$($spinner[$i])$NORMAL" -NoNewline
        $i = ($i + 1) % 4
        Start-Sleep -Milliseconds 100
    }
    
    # Получаем результат задания
    Receive-Job $job -ErrorAction SilentlyContinue
    Remove-Job $job
    
    # Удаляем строку с текстом и спиннером
    $currentCursorTop = [System.Console]::CursorTop
    [System.Console]::SetCursorPosition(0, $currentCursorTop)
    Write-Host (" " * 50) -NoNewline
    [System.Console]::SetCursorPosition(0, $currentCursorTop)

    if (Test-Path -Path "${PROJECT_DIR}/${FILENAME}.mp3" -PathType Leaf) {
        info_triple 6 "Voice " "RU" " saved"
    } else {
        if (($mode_id -eq "single") -or ($ai_ru_pause -eq "true")) {
            while ($true) {
                # Сохранить позицию курсора (эмуляция через переменную)
                $cursorPos = [Console]::GetCursorPosition()
                
                Write-Host ""
                info_color 6 "Voice RU not downloaded."
                info_color 6 "You can try downloading it manually using the VOICE-OVER-TRANSLATION browser extension."
                info_color 6 "Do not select `"y`" until the .mp3 file is placed to the WORKING DIRECTORY."
                Write-Host ""
                
                Write-Host -NoNewline "`e[?25h"
                info_color_bi 9 ".mp3 file is ready? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
                # Показать курсор
                Write-Host -NoNewline "`e[?25h"
                Write-Host -NoNewline "`e[9C"
                $ans = Read-Host

                $result = 1 # по умолчанию ошибка

                switch ($ans) {
                    "y" {
                        $MP3_FILE = Get-ChildItem -Path "$WORKDIR" -Filter "*.mp3"
                        if (Test-Path -Path $MP3_FILE[0].FullName -PathType Leaf) {
                            Move-Item -Path $MP3_FILE[0].FullName -Destination "${PROJECT_DIR}/${FILENAME}.mp3"
                            $result = 0
                            clear_lines 7
                            break
                        } else {
                            # Скрыть курсор
                            Write-Host -NoNewline "`e[?25l"
                            Write-Host ""
                            error 9 ".mp3 file not found in WORKING DIRECTORY, new try..."
                            Start-Sleep -Seconds 8
                            # Очистка перед повтором (эмуляция)
                            [Console]::SetCursorPosition($cursorPos.Left, $cursorPos.Top)
                            clear_lines 9
                        }
                        break
                    }
                    "n" {
                        clear_lines 6
                        
                        $global:status = $false
                        $msg = "Voice RU not downloaded"
                        error 6 "$msg"
                        $global:current_ERROR = $msg
                        
                        $result = 1
                        break
                    }
                    default {
                        Write-Host ""
                        error 6 "Invalid input, type [y/n]:"
                        error 6 "Press Enter to repeat..."
                        # Скрыть курсор
                        Write-Host -NoNewline "`e[?25l"
                        clear_lines 10
                        Read-Host
                        break
                    }
                }
            }
            
            # Скрыть курсор
            Write-Host -NoNewline "`e[?25l"
            # Восстановить позицию курсора
            [Console]::SetCursorPosition($cursorPos.Left, $cursorPos.Top)
            
            return $result
            
        } elseif ($ai_ru_pause -eq "false") {
            $global:status = $false
            $msg = "Voice RU not downloaded"
            error 6 "$msg"
            $global:current_ERROR = $msg
        }
    }
}

# =========================
# Меню
# =========================

# Стартовое меню
function init_config {
    logo
    if (use_saved_config) {
        return $true
    }
    # 1. Выбор рабочей директории
    $tempResult = select_workdir
    if ($tempResult -eq 1) { return $false }

    # 2. Выбор браузера и профиля
    $tempResult = browser_select
    if ($tempResult -eq 1) { return $false }

    # 3. Сохранить всё
    save_config
    return $true
}

# Стартовое меню: управление конфигурацией
function save_config {
    $configContent = @"
WORKDIR="$WORKDIR"
BROWSER="$YT_BROWSER"
PROFILE="$YT_PROFILE_PATH"
"@
    $configContent | Out-File -FilePath "$SCRIPT_DIR/config.txt" -Encoding utf8 -NoNewline
}

# Загрузка конфигурации
function load_config {
    logo

    if (Test-Path -Path "$SCRIPT_DIR/config.txt" -PathType Leaf) {
        # Удаляем переменные, если они существуют
        Remove-Variable -Name WORKDIR, BROWSER, PROFILE -ErrorAction SilentlyContinue
        
        # Читаем и парсим конфиг
        Get-Content -Path "$SCRIPT_DIR/config.txt" | ForEach-Object {
            if ($_ -match '^([^=]+)="?(.*?)"?$') {
                $varName = $matches[1]
                $varValue = $matches[2] -replace '^"|"$', ''  # Удаляем кавычки по краям
                Set-Variable -Name $varName -Value $varValue -Scope Global
            }
        }

        $global:YT_BROWSER = $global:BROWSER
        $global:YT_PROFILE_PATH = $global:PROFILE

        if ($global:YT_BROWSER -eq "chrome") {
            $global:_browser_ui_ = "Google Chrome"
        } elseif ($global:YT_BROWSER -eq "firefox") {
            $global:_browser_ui_ = "Mozilla Firefox"
        }
        return $true
    }
    return $false
}

# Автодетектирование профиля
function detect_default_profile {
    param($1, $2)
    $browser = $1
    $base = $2
    $default_profile = ""

    switch ($browser) {
        "firefox" {
            $ini_file = ""
            
            if ($browser -eq "firefox") {
                $ini_file = "$base\profiles.ini"
            
            }

            if (Test-Path -Path $ini_file -PathType Leaf) {
                # Читаем весь ini-файл
                $iniContent = Get-Content -Path $ini_file -Raw
                
                # 1. Получаем целевой путь из секции [Install...]
                $_path = $null
                $in_inst = $false
                $inInstSections = $iniContent -split '(?=\r?\[Install)'
                
                foreach ($section in $inInstSections) {
                    if ($section -match '^\[Install[^\]]*\]') {
                        $defaultMatch = [regex]::Match($section, '(?m)^Default=(.+)$')
                        $lockedMatch = [regex]::Match($section, '(?m)^Locked=1$')
                        if ($defaultMatch.Success -and $lockedMatch.Success) {
                            $_path = $defaultMatch.Groups[1].Value.Trim()
                            break
                        }
                    }
                }

                # 2. Проверяем его в секциях [Profile...]
                if ($_path) {
                    $profileSections = $iniContent -split '(?=\r?\[Profile)'
                    $found = $false
                    
                    foreach ($section in $profileSections) {
                        if ($section -match '^\[Profile[^\]]*\]') {
                            $pathMatch = [regex]::Match($section, '(?m)^Path=(.+)$')
                            $relMatch = [regex]::Match($section, '(?m)^IsRelative=(.+)$')
                            
                            $path = if ($pathMatch.Success) { $pathMatch.Groups[1].Value.Trim() } else { "" }
                            $rel = if ($relMatch.Success) { $relMatch.Groups[1].Value.Trim() } else { "0" }
                            
                            # Нормировка записи пути, т.к. в ini-файле UNIX стиль, а у нас форточки
                            $path_norm   = $path -replace '/', '\'
                            $target_norm = $_path -replace '/', '\'

                            if ($path_norm -eq $target_norm -and $rel -eq "1") {
                                $found = $true
                                $default_profile = $path
                                break
                            }
                        }
                    }
                    
                    # Если не нашли через секции, проверяем последнюю секцию (аналог END в awk)
                    if (-not $found) {
                        # Ищем последнюю секцию Profile
                        $lastSection = ($profileSections[-1])
                        if ($lastSection -match '^\[Profile[^\]]*\]') {
                            $pathMatch = [regex]::Match($lastSection, '(?m)^Path=(.+)$')
                            $relMatch = [regex]::Match($lastSection, '(?m)^IsRelative=(.+)$')
                            $path = if ($pathMatch.Success) { $pathMatch.Groups[1].Value.Trim() } else { "" }
                            $rel = if ($relMatch.Success) { $relMatch.Groups[1].Value.Trim() } else { "0" }
                            
                            $path_norm   = $path -replace '/', '\'
                            $target_norm = $_path -replace '/', '\'

                            if ($path_norm -eq $target_norm -and $rel -eq "1") {
                                $default_profile = $path
                            }
                        }
                    }
                }

                if (-not [string]::IsNullOrEmpty($default_profile)) {
                    $default_profile = Join-Path $base ($default_profile -replace '/', '\')
                }
            }
            break
        }
        
        "chrome" {
            $state_file = "$base\Local State"

            if (Test-Path -Path $state_file -PathType Leaf) {
                $stateContent = Get-Content -Path $state_file -Raw
                $match = [regex]::Match($stateContent, '"last_used":"([^"]*)"')
                
                if ($match.Success) {
                    $default_profile = $match.Groups[1].Value
                }

                if (-not [string]::IsNullOrEmpty($default_profile)) {
                    $default_profile = "$base\$default_profile"
                }
            }
            break
        }
    }

    Write-Output $default_profile
}

# Получение профилей для всех Chromium-браузеров
function get_chromium_profiles {
    param($1)
    $dir = $1
    $result = @()

    if (Test-Path -Path "$dir/Default" -PathType Container) {
        $result += "$dir/Default"
    }

    foreach ($p in (Get-ChildItem -Path "$dir/Profile *" -Directory -ErrorAction SilentlyContinue)) {
        if (Test-Path -Path $p.FullName -PathType Container) {
            $result += $p.FullName
        }
    }

    if (Test-Path -Path "$dir/Guest Profile" -PathType Container) {
        $result += "$dir/Guest Profile"
    }

    # ВАЖНО: построчный вывод
    $result | ForEach-Object { Write-Output $_ }
}

# Стартовое меню: браузер
function browser_select {
    while ($true) {
        logo

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        Write-Host ""
        info_color 3 "SELECT BROWSER:"
        Write-Host ""
        info_color 6 "1. Mozilla Firefox"
        info_color 6 "2. Google Chrome"
        # info_color 3 "10. Quit"
        Write-Host ""
        info_color_bi 6 "Enter option number [" "$CYAN" "1-2" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $browser_choice = Read-Host

        switch ($browser_choice) {
            "1" {
                $script:BROWSER = "firefox"
                $script:_browser_ui_ = "Mozilla Firefox"
                break
            }
            "2" {
                $script:BROWSER = "chrome"
                $script:_browser_ui_ = "Google Chrome"
                break
            }
            default {
                Write-Host ""
                error 6 "Enter a number from 1 to 2"
                press_enter_repeat
                continue
            }
        }
        break
    }

    # ===== поиск профилей =====
    $base = ""
    $profiles = @()
    $i = 1

    switch ($script:BROWSER) {
        "firefox" {
            $base = "$env:APPDATA\Mozilla\Firefox"
        }
        "chrome" {
            $base = "$env:LOCALAPPDATA\Google\Chrome"
        }
    }

    # подбор конкретных директорий
    switch ($script:BROWSER) {
        "firefox" {
            $profiles = Get-ChildItem -Path "$base\Profiles\*" -Directory -ErrorAction SilentlyContinue | ForEach-Object { $_.FullName }
        }
        "chrome" {
            $browser_dir = "$base\User Data"

            $profiles = @()
            # получаем профили безопасно
            $chromiumProfiles = get_chromium_profiles $browser_dir
            foreach ($p in $chromiumProfiles) {
                if (Test-Path -Path $p -PathType Container) {
                    $profiles += $p
                }
            }
        }
    }

    # ===== фильтрация реальных папок =====
    $valid_profiles = @()
    foreach ($p in $profiles) {
        if (Test-Path -Path $p -PathType Container) {
            $valid_profiles += $p
        }
    }

    # ===== если ничего не найдено =====
    if ($valid_profiles.Count -eq 0) {
        # Скрыть курсор
        Write-Host -NoNewline "`e[?25l"

        # Поднимаемся на 2 строки вверх и стираем их
        clear_lines 2

        error 6 "No profiles found for $_browser_ui_"
        press_enter_repeat
        browser_select
        return
    }

    # ===== автоопределение дефолтного профиля =====
    $DEFAULT_PROFILE = $null
    if ($script:BROWSER -match "^(chrome)$") {
        $DEFAULT_PROFILE = detect_default_profile $script:BROWSER $browser_dir
    } else {
        $DEFAULT_PROFILE = detect_default_profile $script:BROWSER $base
    }

    # fallback если не нашли
    if ([string]::IsNullOrEmpty($DEFAULT_PROFILE) -or (-not (Test-Path $DEFAULT_PROFILE))) {
        foreach ($p in $valid_profiles) {
            if ((Split-Path $p -Leaf) -eq "Default") {
                $DEFAULT_PROFILE = $p
                break
            }
        }
    }

    # если всё ещё пусто — берём первый
    if ([string]::IsNullOrEmpty($DEFAULT_PROFILE)) {
        $DEFAULT_PROFILE = $valid_profiles[0]
    }

    # ===== выбор профиля =====
    while ($true) {
        logo
        Write-Host -NoNewline "`e[?25h"

        Write-Host ""
        $browserName = $script:BROWSER.Substring(0,1).ToUpper() + $script:BROWSER.Substring(1)
        info_color 3 "SELECT PROFILE FOR: $browserName"
        Write-Host ""

        $i = 1
        foreach ($p in $valid_profiles) {
            if ($p -eq $DEFAULT_PROFILE) {
                info_color 6 "$i. $p ← default" $GREEN
            } else {
                info_color 6 "$i. $p"
            }
            $i++
        }

        Write-Host ""
        info_color_bi 6 "Enter profile [" "$CYAN" "1-$($valid_profiles.Count)" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $profile_choice = Read-Host

        if ($profile_choice -match '^\d+$' -and 
            [int]$profile_choice -ge 1 -and 
            [int]$profile_choice -le $valid_profiles.Count) {
            
            $script:PROFILE_PATH = $valid_profiles[[int]$profile_choice - 1]

            $global:YT_BROWSER = $script:BROWSER
            $global:YT_PROFILE_PATH = $script:PROFILE_PATH

            save_config

            main_menu

            return $true
        }

        Write-Host ""
        error 6 "Invalid choice"
        press_enter_repeat
    }
}

# Стартовое меню: рабочая директория
function select_workdir {
    while ($true) {
        logo
        Write-Host -NoNewline "`e[?25h"

        Write-Host ""
        info_color 3 "SELECT WORKING DIRECTORY"
        Write-Host ""
        info_color 6 "Enter path to working directory:" $CYAN
        Write-Host -NoNewline "`e[6C"
        $workdir_raw = Read-Host

        # Скрыть курсор
        Write-Host -NoNewline "`e[?25l"

        $script:WORKDIR = clean_path $workdir_raw

        if ([string]::IsNullOrEmpty($script:WORKDIR)) {
            error 6 "Path cannot be empty"
            Read-Host
            continue
        }

        # Создать если не существует
        if (-not (Test-Path -Path $script:WORKDIR -PathType Container)) {
            New-Item -Path $script:WORKDIR -ItemType Directory -Force -ErrorAction SilentlyContinue | Out-Null
            if ($LASTEXITCODE -ne 0) {
                error 6 "Cannot create directory"
                Read-Host
                continue
            }
        }

        $global:WORKDIR = $script:WORKDIR
        return 0
    }
}

# Принятие конфигурации или создание новой
function use_saved_config {
    while ($true) {
        if (load_config) {
            # Показать курсор
            Write-Host -NoNewline "`e[?25h"
            Write-Host ""
            info_color 3 "SAVED CONFIG FOUND"
            Write-Host ""
            info_color_bi 6 "Working directory: " "" "$WORKDIR" "$GRAY" "" ""
            info_color_bi 6 "Browser: " "" "$_browser_ui_" "$GRAY" "" ""
            info_color_bi 6 "Browser profile: " "" "$YT_PROFILE_PATH" "$GRAY" "" ""
            Write-Host ""

            info_color_bi 6 "Use saved config? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
            Write-Host -NoNewline "`e[6C"
            $ans = (Read-Host).ToLower()

            switch ($ans) {
                "y" { return $true }
                "n" { return $false }
                default { invalid_input }
            }
        } else {
            return $false
        }
    }
    return $false
}

# Меню разрешений видео
function menu_resolution {
    while ($true) {
        logo

        render_status

        info_color 6 "Select video resolution:"
        Write-Host ""
        info_color 6 "1. 360p"
        info_color 6 "2. 480p"
        info_color 6 "3. 720p"
        info_color 6 "4. 1080p"
        info_color 6 "5. 1440p"
        info_color 6 "6. 2160p"
        info_color 6 "7. Best"
        info_color 6 "8. Quit to Main menu"
        Write-Host ""

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        info_color_bi 6 "Enter option number [" "$CYAN" "1-8" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $choice = Read-Host

        switch ($choice) {
            "1" {
                $global:USER_RESOLUTION = "360p"
                break
            }
            "2" {
                $global:USER_RESOLUTION = "480p"
                break
            }
            "3" {
                $global:USER_RESOLUTION = "720p"
                break
            }
            "4" {
                $global:USER_RESOLUTION = "1080p"
                break
            }
            "5" {
                $global:USER_RESOLUTION = "1440p"
                break
            }
            "6" {
                $global:USER_RESOLUTION = "2160p"
                break
            }
            "7" {
                $global:USER_RESOLUTION = "Best"
                break
            }
            "8" {
                main_menu
                return
            }
            default {
                Write-Host ""
                error 6 "Enter a number from 1 to 8"
                press_enter_repeat
            }
        }
        
        # Выход из цикла только при выборе 1-7
        if ($choice -match "^[1-7]$") {
            break
        }
    }
}

# Меню паузы при загрузке AI Ru
function menu_pause_switch {
    $script:ai_ru_pause = $false

    while ($true) {
        logo

        render_status

        info_color 6 "Yandex AI translation may be fails"
        Write-Host ""
        info_color 6 "You can pause the program if the .mp3 file has not been downloaded." $GRAY
        info_color 6 "During this time, you can download the .mp3 file manually," $GRAY
        info_color 6 "using the VOICE-OVER-TRANSLATION browser extension." $GRAY
        info_color 6 "The .mp3 file should be placed in the WORKING DIRECTORY." $GRAY
        Write-Host ""
        info_color 6 "If you don't pause, the video with this issue will be skipped."
        Write-Host ""

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        info_color_bi 6 "Use pause? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $ai_ru_pause_input = Read-Host

        switch ($ai_ru_pause_input) {
            "y" { $script:ai_ru_pause = $true; break }
            "Y" { $script:ai_ru_pause = $true; break }
            "n" { $script:ai_ru_pause = $false; break }
            "N" { $script:ai_ru_pause = $false; break }
            default { invalid_input }
        }
        
        if ($ai_ru_pause_input -match "^[yYnN]$") {
            break
        }
    }
}

# Меню вкл/выкл ИИ перевода
function menu_trans_ai_switch {
    $script:FORCE_LNG = "off"

    while ($true) {
        logo

        render_status

        info_color 6 "Yandex AI translation into Russian"
        Write-Host ""

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        info_color_bi 6 "Translate video? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $RU_TRANS_input = Read-Host

        switch ($RU_TRANS_input) {
            "y" { $script:RU_TRANS = "on"; break }
            "Y" { $script:RU_TRANS = "on"; break }
            "n" { $script:RU_TRANS = "off"; break }
            "N" { $script:RU_TRANS = "off"; break }
            default { invalid_input }
        }
        
        if ($RU_TRANS_input -match "^[yYnN]$") {
            break
        }
    }
}

# Меню форсирования языка
function menu_force_lng {
    while ($true) {
        logo

        render_status

        info_color 6 "Force language if N/A*:"
        info_color 6 "Languages supported by Yandex Translator AI" $GRAY
        Write-Host ""
        info_color 6 "* Sometimes the language is not detected," $GRAY
        info_color 8 "in which case the translation won't load." $GRAY
        info_color 8 "If the language is recognized, the forcing will be ignored." $GRAY
        Write-Host ""
        Write-Host "       1. ${RED}x${NORMAL} No force"
        info_color 6 " 2. English"
        info_color 6 " 3. German"
        info_color 6 " 4. French"
        info_color 6 " 5. Spanish"
        info_color 6 " 6. Italian"
        info_color 6 " 7. Japanese"
        info_color 6 " 8. Chinese"
        info_color 6 " 9. Arabic"
        info_color 6 "10. Quit to Main menu"
        Write-Host ""

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        info_color_bi 6 "Enter option number [" "$CYAN" "1-10" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $choice_lng = Read-Host

        switch ($choice_lng) {
            "1" {
                $script:FORCE_LNG = "off"
                break
            }
            "2" {
                $script:FORCE_LNG = "en-US"
                break
            }
            "3" {
                $script:FORCE_LNG = "de"
                break
            }
            "4" {
                $script:FORCE_LNG = "fr"
                break
            }
            "5" {
                $script:FORCE_LNG = "es"
                break
            }
            "6" {
                $script:FORCE_LNG = "it"
                break
            }
            "7" {
                $script:FORCE_LNG = "ja"
                break
            }
            "8" {
                $script:FORCE_LNG = "zh-CN"
                break
            }
            "9" {
                $script:FORCE_LNG = "ar"
                break
            }
            "10" {
                main_menu
                return
            }
            default {
                Write-Host ""
                error 6 "Enter a number from 1 to 10"
                press_enter_repeat
            }
        }
        
        if ($choice_lng -match "^[1-9]$|^10$") {
            break
        }
    }
}

# Основное меню
function main_menu {
    while ($true) {
        logo

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        Write-Host ""
        info_color 3 "SELECT MODE:"
        Write-Host ""
        info_color 6 "1. One URL"
        info_color 6 "2. Batch of URLs"
        info_color 6 "3. Batch of URLs (interrupt)"
        info_color 6 "4. Create URLs list"
        info_color 6 "5. Check Ru voice/sub"
        info_color 6 "6. Quit"
        Write-Host ""
        info_color_bi 6 "Enter option number [" "$CYAN" "1-6" "$RED" "]:" "$CYAN"
        Write-Host -NoNewline "`e[6C"
        $choice = Read-Host

        switch ($choice) {
            "1" {
                mode_single
            }
            "2" {
                $interrupt = $false
                mode_batch $interrupt mode_single_core
            }
            "3" {
                $interrupt = $true
                mode_batch $interrupt mode_single_core
            }
            "4" {
                mode_list
            }
            "5" {
                check_voice check_voice_core
            }
            "6" {
                logo
                info_color 6 ""
                info_color 6 "Good bye..." $GREEN
                # printf "%12s" | tr ' ' '\n' - 12 пустых строк
                1..12 | ForEach-Object { Write-Host "" }
                exit 0
            }
            default {
                Write-Host ""
                error 6 "Enter a number from 1 to 6"
                press_enter_repeat
            }
        }
    }
}

# =========================
# Основные режимы работы:
# 'single' вручную по одной ссылке 
# 'batch' пакетная обработка списка ссылок
# 'list' создание списка ссылок всего канала
# =========================

function mode_single_core {
    # Инициализируем и сбрасываем статус
    $script:status = $true

    # Получение основных метаданных видео
    $result_json = & $YT_DLP_FILE `
        --ffmpeg-location "${FFMPEG_FILE}" `
        --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" `
        --js-runtimes "node:$NODE_EXE" `
        --extractor-args "youtube:player_client=default" `
        --force-ipv4 `
        --quiet `
        --dump-json `
        --skip-download `
        -- $YT_VIDEO_ID 2>$null

    # Сохраняем JSON во временный файл для jq (из-за ограничений PowerShell с <<<)
    $tempJsonFile = [System.IO.Path]::GetTempFileName()
    $result_json | Out-File -FilePath $tempJsonFile -Encoding utf8 -NoNewline

    $result_meta = & $JQ_FILE -r @"
    {
      "channel_url": .channel_url,
      "channel": .channel,
      "channel_id": .channel_id,
      "uploader": .uploader,
      "title": .title,
      "id": .id,
      "upload_date": .upload_date,
      "duration": .duration,
      "resolution": .resolution,
      "categories": (.categories | join(", ")),
      "language": .language,
      "description": .description
    } | to_entries | map("[\(.key)]: \(.value // "N/A")") | .[]
"@ -r $tempJsonFile 2>$null

    $raw_data = & $JQ_FILE -r @'
    [
        (.language // "N/A"),
        (.channel // "N/A"),
        (.title // "N/A"),
        (if .upload_date then (.upload_date | "\(.[0:4])_\(.[4:6])_\(.[6:8])") else "N/A" end),
        ([.formats[]? | select(.height != null) | .height] | unique | sort | map(tostring) | join(" "))
    ] | @tsv
'@ -r $tempJsonFile 2>$null

    Remove-Item $tempJsonFile

    # Разбиваем строку в массив (табуляция как разделитель)
    $data_array = $raw_data -split "`t"

    $script:LANGUAGE = $data_array[0]
    $script:CHANNEL = $data_array[1]
    $script:TITLE = $data_array[2]
    $script:UPLOAD_DATE = $data_array[3]
    $script:RESOLUTIONS = $data_array[4]

    # Условие "$LANGUAGE" == "N/A" защита от того, если разрешен перевод, язык видео русский и форсирован, к примеру, английский
    if (($global:FORCE_LNG -ne "off") -and ($script:LANGUAGE -eq "N/A")) {
        $script:LANGUAGE = $global:FORCE_LNG
        $result_meta = $result_meta -replace "^\[language\]:.*$", "[language]: $global:FORCE_LNG"
    }

    if ([string]::IsNullOrEmpty($result_meta) -or [string]::IsNullOrEmpty($script:RESOLUTIONS)) {
        $script:status = $false
        $msg = "Failed to get metadata"
        error 6 "$msg"
        $global:current_ERROR = $msg
        return
    } else {
        info_triple 6 "Title: " "$script:TITLE" ""
        info_check 6 "Metadata saved"
    }

    # 1. Заменяем опасные символы файловой системы на подчеркивания
    # 2. Удаляем апострофы
    # 3. Удаляем эмодзи и прочие нестандартные символы, оставляя только буквы (кириллица/латиница), цифры, пробелы, дефисы и точки, !, ?
    # 4. Сжимаем множественные пробелы/подчеркивания в один
    # 5. Сжатие подряд идущих _
    # 6. Обрезаем строку до 200 символов, корректно с UTF-8
    # 7. Убираем пробелы и _ по краям
    
    $script:FILENAME = $script:TITLE
    # Замена опасных символов
    $script:FILENAME = $script:FILENAME -replace '[/\\:*?"<>|]+', '_'
    # Удаление апострофов
    $script:FILENAME = $script:FILENAME -replace "'", ''
    # Удаление эмодзи и нестандартных символов (оставляем буквы, цифры, пробелы, ., -, _, !)
    $script:FILENAME = $script:FILENAME -replace '[^\p{L}\p{N}\ .\-_!]', ''
    # Пробелы в подчеркивания
    $script:FILENAME = $script:FILENAME -replace '[ ]+', '_'
    # Сжатие множественных подчеркиваний
    $script:FILENAME = $script:FILENAME -replace '_+', '_'
    # Обрезаем до 200 символов (по байтам UTF-8, сохраняя целые символы)
    if ($script:FILENAME.Length -gt 200) {
        $script:FILENAME = $script:FILENAME.Substring(0, 200)
    }
    # Убираем подчеркивания и пробелы по краям
    $script:FILENAME = $script:FILENAME -replace '^[_ ]+', ''
    $script:FILENAME = $script:FILENAME -replace '[_ ]+$', ''

    $script:PROJECT_DIR = "$WORKDIR\$CHANNEL\${UPLOAD_DATE}_${FILENAME}_temp"
    New-Item -ItemType Directory -Path $script:PROJECT_DIR -Force | Out-Null
    $result_meta | Out-File -FilePath "$script:PROJECT_DIR\info.txt" -Encoding utf8

    # Формат:
    # 1) avc1 (приоритет)
    # 2) иначе любой лучший (vp9/av1 и т.д.)
    # 3) если выбранное разрешение не входит в список доступных, тогда берём ближайшее меньшее
    if ($global:USER_RESOLUTION -eq "Best") {
        $global:FORMAT = "bestvideo[vcodec^=avc1]+bestaudio"
        $resolutionsList = $script:RESOLUTIONS -split ' '
        $script:ACTUAL_HEIGHT = ($resolutionsList | ForEach-Object { [int]$_ } | Sort-Object | Select-Object -Last 1)
        info_triple 6 "Resolution: " "${ACTUAL_HEIGHT}p"
    } else {
        $height = [int]($global:USER_RESOLUTION -replace 'p$', '')
        $global:FORMAT = "bestvideo[vcodec^=avc1][height<=${height}]+bestaudio " +
            "/bestvideo[height<=${height}]+bestaudio " +
            "/best[height<=${height}]"

        $script:ACTUAL_HEIGHT = $null
        $resolutionsList = $script:RESOLUTIONS -split ' ' | ForEach-Object { [int]$_ }

        # Ищем точное совпадение или ближайшее меньшее
        if ($resolutionsList -contains $height) {
            $script:ACTUAL_HEIGHT = $height
        } else {
            $lower = $resolutionsList | Where-Object { $_ -lt $height } | Sort-Object | Select-Object -Last 1
            if ($lower) { $script:ACTUAL_HEIGHT = $lower }
        }

        if ($height -ne $script:ACTUAL_HEIGHT) {
            info_uncheck 6 "Resolution ${global:USER_RESOLUTION} not available ➜ set ${ACTUAL_HEIGHT}p"
        }
    }

    # Получение видео
    & $YT_DLP_FILE `
        --ffmpeg-location "$FFMPEG_FILE" `
        --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" `
        --js-runtimes "node:$NODE_EXE" `
        --extractor-args "youtube:player_client=default" `
        --force-ipv4 `
        --quiet `
        --progress `
        --progress-template "          Media downloading%(progress._default_template)s" `
        -f "$FORMAT" `
        --merge-output-format mkv `
        -o "$script:PROJECT_DIR/%(title)s.%(ext)s" `
        -- $YT_VIDEO_ID 2>$null

    # Безопасное переименование видеофайла
    $MKV_FILE = Get-ChildItem -Path "$script:PROJECT_DIR" -Filter "*.mkv" -ErrorAction SilentlyContinue
    if ($MKV_FILE -and (Test-Path $MKV_FILE[0].FullName)) {
        info_check 6 "Video saved"

        $src = $MKV_FILE[0].FullName
        $dir = Split-Path $src
        $dst = Join-Path $dir "${script:FILENAME}.mkv"
        Remove-Item $dst -Force -ErrorAction SilentlyContinue
        Rename-Item -Path $src -NewName "${script:FILENAME}.mkv"
    } else {
        $script:status = $false
        $msg = "MKV file not found in: $script:PROJECT_DIR"
        error 6 "$msg"
        $global:current_ERROR = $msg
        return $false
    }

    # Получение миниатюры
    curl -s -o "$script:PROJECT_DIR\thumbnail.jpg" "https://i.ytimg.com/vi/${YT_VIDEO_ID}/maxresdefault.jpg" 2>$null

    if (Test-Path "$script:PROJECT_DIR\thumbnail.jpg") {
        info_check 6 "Thumbnail saved"
    } else {
        $script:status = $false
        $msg = "Failed to get thumbnail"
        error 6 "$msg"
        $global:current_ERROR = $msg
        return $false
    }

    # Getting duration of video
    duration "$script:PROJECT_DIR\${FILENAME}.mkv"

    # Получение глав
    $tempJsonFile2 = [System.IO.Path]::GetTempFileName()
    $result_json | Out-File -FilePath $tempJsonFile2 -Encoding utf8 -NoNewline

    $CHAPTERS_RAW = & $JQ_FILE -r @'
    def pad: tostring | if length == 1 then "0" + . else . end;

    def to_hms:
      floor as $t
      | ($t / 3600 | floor) as $h
      | (($t % 3600) / 60 | floor) as $m
      | ($t % 60 | floor) as $s
      | "\($h):\($m|pad):\($s|pad)";

    .chapters // [] 
    | map(
        ( .start_time | to_hms ) + " " + .title
    )
    | join("\n")
'@ -r $tempJsonFile2 2>$null

    Remove-Item $tempJsonFile2

    $CHAPTERS_XML = "$script:PROJECT_DIR\temp_chapters.xml"

    if (-not [string]::IsNullOrEmpty($CHAPTERS_RAW)) {
        $CHAPTERS_RAW | Out-File -FilePath "$script:PROJECT_DIR/chapters.txt" -Encoding utf8
        info_check 6 "Chapters saved"

        @'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE Chapters SYSTEM "matroskachapters.dtd">
<Chapters>
  <EditionEntry>
    <EditionUID>1</EditionUID>
    <EditionFlagHidden>0</EditionFlagHidden>
    <EditionFlagDefault>0</EditionFlagDefault>
'@ | Out-File -FilePath $CHAPTERS_XML -Encoding utf8

        $prev_time = ""
        $prev_title = ""
        $chapter_uid = 1
        $chaptersList = $CHAPTERS_RAW -split "`n"

        foreach ($line in $chaptersList) {
            if ([string]::IsNullOrEmpty($line)) { continue }

            $timeParts = $line -split ' ', 2
            $time = $timeParts[0] + ".000"
            $title = if ($timeParts.Count -gt 1) { $timeParts[1] } else { "" }

            if ($prev_time) {
                @"
        <ChapterAtom>
          <ChapterUID>$chapter_uid</ChapterUID>
          <ChapterTimeStart>$prev_time</ChapterTimeStart>
          <ChapterTimeEnd>$time</ChapterTimeEnd>
          <ChapterDisplay>
            <ChapterString>$prev_title</ChapterString>
            <ChapterLanguage>eng</ChapterLanguage>
          </ChapterDisplay>
        </ChapterAtom>
"@ | Out-File -FilePath $CHAPTERS_XML -Append -Encoding utf8
                $chapter_uid++
            }

            $prev_time = $time
            $prev_title = $title
        }

        # Добавляем последнюю главу
        if ($prev_time) {
            @"
        <ChapterAtom>
          <ChapterUID>$chapter_uid</ChapterUID>
          <ChapterTimeStart>$prev_time</ChapterTimeStart>
          <ChapterTimeEnd>$global:DURATION_FORMATTED</ChapterTimeEnd>
          <ChapterDisplay>
            <ChapterString>$prev_title</ChapterString>
            <ChapterLanguage>eng</ChapterLanguage>
          </ChapterDisplay>
        </ChapterAtom>
"@ | Out-File -FilePath $CHAPTERS_XML -Append -Encoding utf8
        }

        @'
  </EditionEntry>
</Chapters>
'@ | Out-File -FilePath $CHAPTERS_XML -Append -Encoding utf8
    } else {
        info_uncheck 6 "No chapters to save"
    }

    $allowed_languages_ai = @("en", "en-US", "en-GB", "en-CA", "en-AU", "de", "fr", "es", "it", "ja", "zh", "zh-CN", "zh-TW", "ar")

    if (($allowed_languages_ai -contains $script:LANGUAGE) -and ($script:RU_TRANS -eq "on")) {
        voice_sub
    } elseif (($allowed_languages_ai -notcontains $script:LANGUAGE) -and ($script:RU_TRANS -eq "on")) {
        $script:NOT_SUPP_TRANS = $true
        info_uncheck 6 "Translation from $($script:LANGUAGE.ToUpper()) language into Russian is not supported"
    }

    if ($script:status -eq $true) {
        if (($allowed_languages_ai -contains $script:LANGUAGE) -and ($script:LANGUAGE -ne "ru") -and ($script:LANGUAGE -ne "N/A") -and ($script:RU_TRANS -eq "on")) {
            $SUFFIX = "_RUS"
        } else {
            $SUFFIX = ""
        }

        $FINAL_MKV = "$script:PROJECT_DIR\${FILENAME}_${UPLOAD_DATE}${SUFFIX}_${ACTUAL_HEIGHT}p.mkv"

        if (($allowed_languages_ai -contains $script:LANGUAGE) -and ($script:RU_TRANS -eq "on")) {
            # === ОРИГИНАЛЬНЫЙ ГОЛОС + РУССКАЯ ОЗВУЧКА + 2 СУБТИТРА ===

            # FFmpeg аудио-микширование
            & $FFMPEG_FILE `
                -i "$script:PROJECT_DIR\${FILENAME}.mkv" `
                -i "$script:PROJECT_DIR\${FILENAME}.mp3" `
                -i "$script:PROJECT_DIR\${FILENAME}.ru.srt" `
                -i "$script:PROJECT_DIR\${FILENAME}.en.srt" `
                -filter_complex @"
        [0:a]aformat=channel_layouts=stereo[bg];

        [1:a]aformat=channel_layouts=mono,
        volume=1.8,
        asplit=2[voice_sc][voice_mix];

        [bg]loudnorm=I=-22:LRA=7:TP=-2[bg_norm];

        [bg_norm][voice_sc]sidechaincompress=
            threshold=0.03:
            ratio=6:
            attack=10:
            release=500:
            knee=6:
            makeup=4
        [bg_duck];

        [voice_mix]pan=stereo|c0=c0|c1=c0[voice_stereo];

        [bg_duck][voice_stereo]amix=inputs=2:weights=1 1.6
            duration=longest:
            dropout_transition=1
        [a_mix];

        [a_mix]loudnorm=I=-16:LRA=9:TP=-1.5[a_mixed]
"@ `
                -map 0:v `
                -map "[a_mixed]" `
                -map 1:a `
                -map 0:a `
                -map 2:s `
                -map 3:s `
                -metadata:s:s:0 title='AI Yandex Rus' `
                -metadata:s:s:0 language=rus `
                -metadata:s:s:1 title='AI Yandex Eng' `
                -metadata:s:s:1 language=eng `
                -c:v copy `
                -c:a:0 aac -b:a:0 128k `
                -c:a:1 copy `
                -c:a:2 copy `
                -c:s copy `
                -metadata title="$TITLE" `
                -metadata:s:a:0 title="AAC 2 ch 128 kbps AI Yandex Mixed Rus" `
                -metadata:s:a:0 language=rus `
                -metadata:s:a:1 title="MP3 1 ch 128 kbps AI Yandex Rus" `
                -metadata:s:a:1 language=rus `
                -metadata:s:a:2 title="AAC 2 ch 128 kbps $(yt_to_mkv_lang $LANGUAGE | ForEach-Object { $_.Substring(0,1).ToUpper() + $_.Substring(1) })" `
                -metadata:s:a:2 language=$(yt_to_mkv_lang $LANGUAGE) `
                -progress pipe:1 -nostats `
                "$FINAL_MKV" 2>&1 | ForEach-Object {
                    if ($_ -match "out_time=(\d{2}):(\d{2}):(\d{2})\.(\d{2})") {
                        $sec = [int]$matches[1]*3600 + [int]$matches[2]*60 + [int]$matches[3]
                        $percent = ($sec / $global:DURATION) * 100
                        Write-Host -NoNewline "`r          Audio mixing: $([math]::Round($percent,0))%"
                    }
                }
            # Очищаем строку
            Write-Host -NoNewline "`r`e[2K"

            & $MKVPROPEDIT_FILE `
                "$FINAL_MKV" `
                --edit track:a1 --set flag-default=1 `
                --edit track:a2 --set flag-default=0 `
                --edit track:a3 --set flag-default=0 `
                --edit track:s1 --set flag-default=0 `
                --edit track:s2 --set flag-default=0 *> $null

            info_triple 6 "Voice " "RU" " added"
            info_triple 6 "Subtitles " "RU" " added"
            info_triple 6 "Subtitles " "EN" " added"

        } else {
            # === ЛЮБОЙ ГОЛОС, КРОМЕ ПЕРЕВОДНОГО ===
            $langCode = yt_to_mkv_lang $LANGUAGE
            $langName = $langCode.Substring(0,1).ToUpper() + $langCode.Substring(1)
            
            & $FFMPEG_FILE `
                -i "$script:PROJECT_DIR\${FILENAME}.mkv" `
                -map 0:v `
                -map 0:a `
                -c copy `
                -metadata title="$TITLE" `
                -metadata:s:a:0 title="AAC 2 ch 128 kbps $langName" `
                -metadata:s:a:0 language=$(yt_to_mkv_lang $LANGUAGE) `
                "$FINAL_MKV" 2>$null

            info_triple 6 "Video metadata updated"
        }

        if (Test-Path $CHAPTERS_XML) {
            & $MKVPROPEDIT_FILE "$FINAL_MKV" --chapters "$CHAPTERS_XML" 2>$null
            Remove-Item -Path $CHAPTERS_XML -Force
            info_check 6 "Chapters added"
        }

        Remove-Item -Path "$script:PROJECT_DIR\${FILENAME}.mkv" -Force -ErrorAction SilentlyContinue

        if (($allowed_languages_ai -contains $script:LANGUAGE) -and ($script:RU_TRANS -eq "on")) {
            Remove-Item -Path "$script:PROJECT_DIR\${FILENAME}.mp3" -Force -ErrorAction SilentlyContinue
        }

        $NEW_PROJECT_DIR = $script:PROJECT_DIR -replace '_temp$', ''

        # Копирование через Robocopy (Windows) или rsync (Linux/Mac)
        robocopy $script:PROJECT_DIR $NEW_PROJECT_DIR /E > $null
        Remove-Item -Path $script:PROJECT_DIR -Recurse -Force

        $script:PROJECT_DIR = ""
        $NEW_PROJECT_DIR = ""
    }
    
    Write-Host ""
    if ($script:status -eq $false) {
        info_color 6 "Failed" $RED
    } else {
        info_color 6 "Completed" $GREEN
    }
}

function render_status {
    Write-Host ""
    info_color 3 "MODE: $($script:mode) $($script:RES) $($script:TRN) $($script:LNG)"
    Write-Host ""
}

function mode_single {
    $script:RES = ""
    $script:TRN = ""
    $script:LNG = ""
    $script:mode_id = "single"

    $script:mode = "One URL"

    menu_resolution
    $script:RES = "/ Quality: $global:USER_RESOLUTION"

    menu_trans_ai_switch
    $script:TRN = "/ → Ru: $script:RU_TRANS"

    if ($script:RU_TRANS -eq "on") {
        menu_force_lng
        $script:LNG = "/ Force lang: $script:FORCE_LNG"
    }

    while ($true) {
        logo

        render_status

        info_color_bi 6 "Enter YouTube video URL:" $CYAN
        Write-Host -NoNewline "`e[6C"
        $VIDEO_URL = Read-Host

        # Скрыть курсор
        Write-Host -NoNewline "`e[?25l"

        logo
        render_status

        $global:YT_VIDEO_ID = get_youtube_id $VIDEO_URL
        if ([string]::IsNullOrEmpty($global:YT_VIDEO_ID)) {
            error 6 "Press Enter to repeat..."
            Read-Host
            # Показать курсор
            Write-Host -NoNewline "`e[?25h"
            continue
        }

        # Для совместимости с пакетным режимом
        mode_single_core

        press_enter
        # Показать курсор
        Write-Host -NoNewline "`e[?25h"
    }
}

function mode_batch_common {
    param($1)
    $callback = $1

    while ($true) {
        logo
        render_status

        # Показать курсор
        Write-Host -NoNewline "`e[?25h"

        info_color 6 "Enter the path to the URLs list file:" $CYAN
        Write-Host -NoNewline "`e[6C"
        $url_list_path_raw = Read-Host

        # Скрыть курсор
        Write-Host -NoNewline "`e[?25l"

        logo
        render_status

        $script:URL_LIST_PATH = clean_path $url_list_path_raw

        $_f_ = Split-Path $URL_LIST_PATH -Leaf
        $BASENAME_URL_LIST_PATH = [System.IO.Path]::GetFileNameWithoutExtension($_f_)

        # Проверка существования файла
        if (-not (Test-Path -Path $script:URL_LIST_PATH -PathType Leaf)) {
            error 6 "File not found"
            press_enter_repeat
            continue
        }

        # Проверка на пустой файл
        $fileInfo = Get-Item $script:URL_LIST_PATH
        if ($fileInfo.Length -eq 0) {
            error 6 "File cannot be empty"
            press_enter_repeat
            continue
        }

        # Если рабочая директория по каким-либо причинам отсутствует
        New-Item -ItemType Directory -Path $global:WORKDIR -Force | Out-Null

        $datetime = Get-Date -Format "yyyy_MM_dd_HH-mm-ss"

        # Создаём временный файл
        $script:ERRORS_FILE = "$global:WORKDIR\${BASENAME_URL_LIST_PATH}_log_errors_${datetime}.txt"
        New-Item -ItemType File -Path $script:ERRORS_FILE -Force | Out-Null

        # Файл содержит оставшуюся очередь на скачивание
        $script:QUEUE_FILE = "$global:WORKDIR\${BASENAME_URL_LIST_PATH}_log_queue_${datetime}.txt"
        Copy-Item -Path $script:URL_LIST_PATH -Destination $script:QUEUE_FILE -Force

        # Инициализируем счетчик строк
        $line_number = 0
        # Инициализируем счетчик ошибок
        $reject_number = 0

        # Общее количество непустых строк в файле
        $total_lines = (Get-Content $script:URL_LIST_PATH | Where-Object { $_ -match '\S' } | Measure-Object).Count
        # Количество разрядов в числе строк
        $width = $total_lines.ToString().Length

        # Читаем файл построчно
        $fileContent = Get-Content -Path $script:URL_LIST_PATH -ErrorAction SilentlyContinue
        foreach ($line_raw in $fileContent) {
            # Пропускаем полностью пустые строки, чтобы не создавать дыр
            if ([string]::IsNullOrWhiteSpace($line_raw)) { continue }

            # Удаляем символ \r (CR), если файл в формате DOS/Windows
            $line = $line_raw -replace "`r", ""

            # Извлекаем первую HTTP/HTTPS ссылку из строки
            $match = [regex]::Match($line, 'https?://[^\s]+')
            $link = if ($match.Success) { $match.Value } else { $null }

            if ([string]::IsNullOrEmpty($link)) {
                # info_uncheck 6 "URL not found in line: $line_number"
                "[ FAIL ] $line_raw" | Out-File -FilePath $script:ERRORS_FILE -Append -Encoding utf8
                continue
            } else {
                # Увеличиваем счетчик для каждой строки (включая пустые)
                $line_number++
            }

            # Очищаем ссылку от возможных знаков препинания в конце (.,;:))
            $link = $link -replace '[.,;:)]*$', ''

            $formatted_line_number = $line_number.ToString().PadLeft($width, '0')
            if ($line_number -ne 1) {
                Write-Host ""
            }
            info_color 6 "Processing URL ${formatted_line_number}/${total_lines}" $GRAY
            Write-Host ""

            $global:YT_VIDEO_ID = get_youtube_id $link
            if ([string]::IsNullOrEmpty($global:YT_VIDEO_ID)) {
                $script:status = $false
            } else {
                # Вызов callback-функции
                & $callback
            }

            # Проверяем итоговый статус
            if ($script:status -eq $false) {
                $reject_number++
                Write-Host ""
                info_uncheck 6 "Error at one of steps → rejected"
                "[ $global:current_ERROR ]: $line_raw" | Out-File -FilePath $script:ERRORS_FILE -Append -Encoding utf8
                if ($script:PROJECT_DIR -and (Test-Path $script:PROJECT_DIR)) {
                    Remove-Item -Path $script:PROJECT_DIR -Recurse -Force -ErrorAction SilentlyContinue
                }
            }

            # Удаляем верхнюю строку из QUEUE_FILE
            $queueContent = Get-Content $script:QUEUE_FILE
            if ($queueContent.Count -gt 1) {
                $queueContent[1..($queueContent.Count-1)] | Out-File -FilePath $script:QUEUE_FILE -Encoding utf8
            } else {
                Clear-Content -Path $script:QUEUE_FILE
            }

            if ($global:interrupt -eq $true) {
                while ($true) {
                    Write-Host -NoNewline "`r`e[K"
                    Write-Host ""
                    info_color 6 "Press Enter to continue..." $CYAN
                    # Скрыть курсор
                    Write-Host -NoNewline "`e[?25l"
                    $input = Read-Host
                    if ([string]::IsNullOrEmpty($input)) {
                    # вверх на 3 строки
                    Write-Host -NoNewline "`e[3A"
                    # очищаем 3 строки по очереди
                    Write-Host -NoNewline "`e[2K"   # строка 1 (верхняя)
                    Write-Host -NoNewline "`e[1B"
                    Write-Host -NoNewline "`e[2K"   # строка 2
                    Write-Host -NoNewline "`e[1B"
                    Write-Host -NoNewline "`e[2K"   # строка 3
                    # возвращаемся обратно на исходную позицию (на 2 строки вверх)
                    Write-Host -NoNewline "`e[2A"
                        break
                    }
                }
                Write-Host -NoNewline "`r`e[K"
            }
        }

        Write-Host ""
        info_color 6 "Batch completed" $GREEN
        Write-Host ""
        $completed = $line_number - $reject_number
        info_color_bi 9 "Total: " $GRAY "    $line_number" $CYAN "" ""
        info_color_bi 9 "Completed: " $GRAY "    $completed" $GREEN "" ""
        info_color_bi 9 "Rejected: " $GRAY "    $reject_number" $RED "" ""

        press_enter
        # Показать курсор
        Write-Host -NoNewline "`e[?25h"
    }
}

function mode_batch {
    param($1, $2)
    $global:interrupt = $1
    $callback = $2

    $script:IRT = ""
    if ($global:interrupt -eq $true) {
         $script:IRT = " i"
    }
    $script:RES = ""
    $script:TRN = ""
    $script:LNG = ""
    $script:mode_id = "batch"

    $script:mode = "Batch of URLs$script:IRT"

    menu_resolution
    $script:RES = "/ Quality: $global:USER_RESOLUTION"

    menu_trans_ai_switch
    $script:TRN = "/ → Ru: $script:RU_TRANS"

    if ($script:RU_TRANS -eq "on") {
        menu_force_lng
        $script:LNG = "/ Force lang: $script:FORCE_LNG"

        menu_pause_switch
    }

    mode_batch_common $callback
}

function mode_list {
    $script:mode = @"
    Write-Host ""
    info_color 3 "MODE: Creating URLs list for a channel"
    Write-Host ""
"@

    while ($true) {
        logo
        Invoke-Expression -Command $script:mode
        info_color_bi 6 "Enter the channel name in any format
      [" $CYAN "@channel, channel, https://youtube.com/@channel" $RED "]:" $CYAN
        Write-Host -NoNewline "`e[6C"
        $YT_CHANNEL_raw = Read-Host

        # Скрыть курсор
        Write-Host -NoNewline "`e[?25l"

        logo
        Invoke-Expression -Command $script:mode

        # Проверка на пустое имя
        if ([string]::IsNullOrEmpty($YT_CHANNEL_raw)) {
            error 6 "Channel name cannot be empty"
        } else {
            $YT_CHANNEL = $YT_CHANNEL_raw

            # Обработка YT_CHANNEL
            if ($YT_CHANNEL -like "*@*") {
                # Удаляем всё до первого @ (сам @ оставляем)
                $atIndex = $YT_CHANNEL.IndexOf('@')
                $YT_CHANNEL = "@" + $YT_CHANNEL.Substring($atIndex + 1)

                # Если после @ есть /, удаляем всё начиная с /
                $slashIndex = $YT_CHANNEL.IndexOf('/')
                if ($slashIndex -ne -1) {
                    $YT_CHANNEL = $YT_CHANNEL.Substring(0, $slashIndex)
                }
            } else {
                # Если @ нет, добавляем @ в начало
                $YT_CHANNEL = "@$YT_CHANNEL"
                # И потом удаляем всё после / (если есть)
                $slashIndex = $YT_CHANNEL.IndexOf('/')
                if ($slashIndex -ne -1) {
                    $YT_CHANNEL = $YT_CHANNEL.Substring(0, $slashIndex)
                }
            }

            $FILE_CH_TEMP = "$global:WORKDIR\${YT_CHANNEL}.tmp"

            # Выводим начальный текст
            $spaces = " " * 5
            Write-Host "$spaces In progress  " -NoNewline
            
            $spinner = @('\', '|', '/', '-')
            $i = 0
            $running = $true
            
            # Запускаем основную команду в фоновом задании
            # Параметры нужны потому, что фоновое задание не видит переменных, поэтому даём аргументы нашими переменными
            $job = Start-Job -ScriptBlock {
                param($yt_dlp_file, $ffmpeg_file, $yt_browser, $yt_profile_path, $node_exe, $yt_channel, $file_ch_temp)
                & $yt_dlp_file `
                    --ffmpeg-location "$ffmpeg_file" `
                    --cookies-from-browser "${yt_browser}:${yt_profile_path}" `
                    --js-runtimes "node:$node_exe" `
                    --extractor-args "youtube:player_client=default" `
                    --force-ipv4 `
                    --flat-playlist `
                    --print "%(title)s - https://youtu.be/%(id)s" `
                    "https://www.youtube.com/${yt_channel}/videos" 2>$null | Out-File -FilePath $file_ch_temp -Encoding utf8
            } -ArgumentList $YT_DLP_FILE, $FFMPEG_FILE, ${global:YT_BROWSER}, ${global:YT_PROFILE_PATH}, $NODE_EXE, $YT_CHANNEL, $FILE_CH_TEMP

            # Рисуем спиннер в основном потоке, пока задание выполняется
            while ($job.State -eq 'Running') {
                Write-Host "`b$GREEN$($spinner[$i])$NORMAL" -NoNewline
                $i = ($i + 1) % 4
                Start-Sleep -Milliseconds 100
            }
            
            # Получаем результат задания
            Receive-Job $job -ErrorAction SilentlyContinue
            Remove-Job $job

            logo
            Invoke-Expression -Command $script:mode

            $datetime = Get-Date -Format "yyyy_MM_dd_HH-mm-ss"
            $FILE_CH_FINAL = "$global:WORKDIR\${YT_CHANNEL}_${datetime}.txt"

            # Проверяем успешность выполнения и наличие файла
            $fileInfo = Get-Item $FILE_CH_TEMP -ErrorAction SilentlyContinue
            if ($fileInfo -and $fileInfo.Length -gt 0) {
                Move-Item -Path $FILE_CH_TEMP -Destination $FILE_CH_FINAL -Force
            } else {
                Remove-Item -Path $FILE_CH_TEMP -Force -ErrorAction SilentlyContinue
                error 6 "File not created"
            }

            if (Test-Path -Path "$global:WORKDIR\${YT_CHANNEL}_${datetime}.txt" -PathType Leaf) {
                info_check 6 "The URLs list is ready:"
                info_color 10 "$global:WORKDIR\${YT_CHANNEL}_${datetime}.txt" $GRAY
                Write-Host ""
                info_color 6 "Completed" $GREEN
            }
        }
        press_enter
        # Показать курсор
        Write-Host -NoNewline "`e[?25h"
    }
}

function check_voice_core {
    # Инициализируем статус
    $script:status = $true

    # Получение основных метаданных видео
    $result_json = & $YT_DLP_FILE `
        --ffmpeg-location "${FFMPEG_FILE}" `
        --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" `
        --js-runtimes "node:$NODE_EXE" `
        --extractor-args "youtube:player_client=default" `
        --force-ipv4 `
        --quiet `
        --dump-json `
        --skip-download `
        -- $YT_VIDEO_ID 2>$null

    # Сохраняем JSON во временный файл для jq
    $tempJsonFile = [System.IO.Path]::GetTempFileName()
    $result_json | Out-File -FilePath $tempJsonFile -Encoding utf8 -NoNewline

    $result_meta = & $JQ_FILE -r @'
    {
      "channel": .channel,
      "uploader": .uploader,
      "title": .title,
      "upload_date": .upload_date,
      "language": .language,
    } | to_entries | map("[\(.key)]: \(.value // "N/A")") | .[]
'@ -r $tempJsonFile 2>$null

    $raw_data = & $JQ_FILE -r @'
    [
        (.language // "N/A"),
        (.channel // "N/A"),
        (.title // "N/A"),
        (if .upload_date then (.upload_date | "\(.[0:4])_\(.[4:6])_\(.[6:8])") else "N/A" end),
        ([.formats[]? | select(.height != null) | .height] | unique | sort | map(tostring) | join(" "))
    ] | @tsv
'@ -r $tempJsonFile 2>$null

    Remove-Item $tempJsonFile

    # Разбиваем строку в массив (табуляция как разделитель)
    $data_array = $raw_data -split "`t"

    $script:LANGUAGE = $data_array[0]
    $script:CHANNEL = $data_array[1]
    $script:TITLE = $data_array[2]
    $script:UPLOAD_DATE = $data_array[3]

    if ([string]::IsNullOrEmpty($result_meta)) {
        $script:status = $false
        $msg = "Failed to get metadata"
        error 6 "$msg"
        $global:current_ERROR = $msg
        return $false
    } else {
        info_triple 6 "Title: " "$script:TITLE" ""
    }

    # 1. Заменяем опасные символы файловой системы на подчеркивания
    # 2. Удаляем апострофы
    # 3. Удаляем эмодзи и прочие нестандартные символы
    # 4. Сжимаем множественные пробелы/подчеркивания в один
    # 5. Сжатие подряд идущих _
    # 6. Обрезаем строку до 200 символов
    # 7. Убираем пробелы и _ по краям
    $script:FILENAME = $script:TITLE
    # Замена опасных символов
    $script:FILENAME = $script:FILENAME -replace '[/\\:*?"<>|]+', '_'
    # Удаление апострофов
    $script:FILENAME = $script:FILENAME -replace "'", ''
    # Удаление эмодзи и нестандартных символов (оставляем буквы, цифры, пробелы, ., -, _, !)
    $script:FILENAME = $script:FILENAME -replace '[^\p{L}\p{N}\ .\-_!]', ''
    # Пробелы в подчеркивания
    $script:FILENAME = $script:FILENAME -replace '[ ]+', '_'
    # Сжатие множественных подчеркиваний
    $script:FILENAME = $script:FILENAME -replace '_+', '_'
    # Обрезаем до 200 символов (по байтам UTF-8, сохраняя целые символы)
    if ($script:FILENAME.Length -gt 200) {
        $script:FILENAME = $script:FILENAME.Substring(0, 200)
    }
    # Убираем подчеркивания и пробелы по краям
    $script:FILENAME = $script:FILENAME -replace '^[_ ]+', ''
    $script:FILENAME = $script:FILENAME -replace '[_ ]+$', ''

    $script:PROJECT_DIR = "$global:WORKDIR\${CHANNEL}_CHECK_VOICE\${UPLOAD_DATE}_${FILENAME}_CHECK_VOICE"
    New-Item -ItemType Directory -Path $script:PROJECT_DIR -Force | Out-Null

    $script:ai_ru_pause = $false
    $allowed_languages_ai = @("en", "en-US", "en-GB", "en-CA", "en-AU", "de", "fr", "es", "it", "ja", "zh", "zh-CN", "zh-TW", "ar")

    if ($allowed_languages_ai -contains $script:LANGUAGE) {
        voice_sub
    } elseif ($allowed_languages_ai -notcontains $script:LANGUAGE) {
        info_uncheck 6 "Translation from $($script:LANGUAGE.ToUpper()) language into Russian is not supported"
    }

    if ($script:status -eq $false) {
        Remove-Item -Path $script:PROJECT_DIR -Recurse -Force
    }
    $script:PROJECT_DIR = ""

    Write-Host ""
    if ($script:status -eq $false) {
        info_color 6 "Failed" $RED
    } else {
        info_color 6 "Completed" $GREEN
    }
}

function check_voice {
    param($1)
    $callback = $1

    $script:RES = ""
    $script:TRN = ""
    $script:LNG = ""
    $script:mode_id = "batch"

    $script:mode = "Checking Ru voice/sub"

    mode_batch_common $callback
}

# =========================
# Проверка среды выполнения
# =========================

# Получаем текущую версию PowerShell
$currentVersion = $PSVersionTable.PSVersion
$majorVersion = $currentVersion.Major

# Проверяем версию PowerShell
if ($majorVersion -lt 7) {
    Write-Host ""
    Write-Host "   [ERROR] PowerShell 7 or higher required" -ForegroundColor Red
    Write-Host "           Current version: $currentVersion"
    Write-Host "           Download PowerShell 7: https://github.com/PowerShell/PowerShell/releases"
    Write-Host ""
    
    # Завершаем скрипт с кодом ошибки
    exit 1
}

# =========================
# Проверка зависимостей
# =========================

Clear-Host
Write-Host ""
$failed = 0
if (-not (check_file $YT_DLP_FILE   "YT-dlp"))   { $failed = 1 }
if (-not (check_file $JQ_FILE       "Jq"))       { $failed = 1 }
if (-not (check_file $FFMPEG_FILE   "FFmpeg"))   { $failed = 1 }
if (-not (check_file $FFPROBE_FILE  "FFprobe"))  { $failed = 1 }
if (-not (check_file $MKVPROPEDIT_FILE  "Mkvpropedit"))   { $failed = 1 }
if (-not (check_file $NODE_EXE  "Node"))   { $failed = 1 }
if (-not (check_file $VOT_CLI_JS  "VOT-cli-live"))   { $failed = 1 }

if ($failed -ne 0) {
    error 3 "Required files are missing!"
    " " * 12 -split '' | ForEach-Object { Write-Host $_ }
    exit 1
}

Set-Location -Path $WORKDIR

if (-not (init_config)) { exit 1 }
main_menu
