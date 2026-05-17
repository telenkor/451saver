#!/usr/bin/env bash

# Отключаем приветствия Терминала
touch ~/.hushlogin

# =========================
# Название и версия ПО
# =========================

ABOUT="451saver v3.7.0"

# Меняем заголовок окна
echo -ne "\033]0;$ABOUT\007"

# =========================
# ANSI-цвета для консоли
# =========================

NORMAL="\033[0m"
RED="\033[91m"
GREEN="\033[32m"
CYAN="\033[36m"
GRAY="\033[90m"

# =========================
# Пути к файлам системные
# =========================

SCRIPT_DIR="$(dirname "$0")"

# Определяем тип ОС и пути к основным исполняемым файлам
OS_TYPE=$(uname)
if [ "$OS_TYPE" = "Darwin" ]; then
  OS_DIR="$SCRIPT_DIR/macos"
  MKVPROPEDIT_FILE="$OS_DIR/mkvpropedit/mkvpropedit"
elif [ "$OS_TYPE" = "Linux" ]; then
  OS_DIR="$SCRIPT_DIR/linux"
  APPDIR="$OS_DIR/mkvtoolnix_root"
  export LD_LIBRARY_PATH="$APPDIR/usr/lib:$APPDIR/usr/lib64"
  export PATH="$APPDIR/usr/bin:$PATH"
  MKVPROPEDIT_FILE=("$APPDIR/usr/bin/mkvpropedit")
fi

YT_DLP_FILE="$OS_DIR/yt-dlp"
JQ_FILE="$OS_DIR/jq"
FFMPEG_FILE="$OS_DIR/ffmpeg"
FFPROBE_FILE="$OS_DIR/ffprobe"
NODE_VOT_CLI=("$OS_DIR/node/bin/node" "$OS_DIR/node/lib/node_modules/vot-cli-live/src/index.js")

# =========================
# Интерфейс
# =========================

logo()
{
  clear

  printf "${GRAY}█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█${NORMAL}\n"
  printf "${GRAY}█     ██╗██╗███████╗  ███╗   ██████╗ █████╗ ██╗   ██╗███████╗██████╗    █${NORMAL}\n"
  printf "${GRAY}█    ██╔╝██║██╔════╝ ████║  ██╔════╝██╔══██╗██║   ██║██╔════╝██╔══██╗   █${NORMAL}\n"
  printf "${GRAY}█   ██╔╝ ██║██████╗ ██╔██║  ╚█████╗ ███████║╚██╗ ██╔╝█████╗  ██████╔╝   █${NORMAL}\n"
  printf "${GRAY}█   ███████║╚════██╗╚═╝██║   ╚═══██╗██╔══██║ ╚████╔╝ ██╔══╝  ██╔══██╗   █${NORMAL}\n"
  printf "${GRAY}█   ╚════██║██████╔╝███████╗██████╔╝██║  ██║  ╚██╔╝  ███████╗██║  ██║   █${NORMAL}\n"
  printf "${GRAY}█        ╚═╝╚═════╝ ╚══════╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═╝   █${NORMAL}\n"
  printf "${GRAY}███ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ███${NORMAL}\n"
  printf "${GRAY}█▀${NORMAL}                        ${GRAY}-  $ABOUT  -${NORMAL}                        ${GRAY}▀█${NORMAL}\n"
  printf "${GRAY}█ ▄${NORMAL}                    ${GRAY}© 2016–2026 Dmitry Chushkin${NORMAL}                    ${GRAY}▄ █${NORMAL}\n"
  printf "${GRAY}█ ▓${NORMAL}                            ${GRAY}dev@36pix.ru${NORMAL}                           ${GRAY}▓ █${NORMAL}\n"
  printf "${GRAY}▄ ▓▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▓ ▄${NORMAL}\n"
}

leading_spaces()
{
  local i
  for (( i = 0; i < $1; i++ ))
  do
    printf " "
  done
}

info_check()
{
  declare -r msg="$2"
  [[ -z ${msg} ]] && {
    printf "\n"
    return
  }
  leading_spaces $1
  printf "%b%s%b\n" "[${GREEN}✔${NORMAL}]"" ${msg}"
}

info_uncheck()
{
  declare -r msg="$2"
  [[ -z ${msg} ]] && {
    printf "\n"
    return
  }
  leading_spaces $1
  printf "%b%s%b\n" "[${RED}✘${NORMAL}]"" ${msg}"
}

info_color()
{
  local msg="$2"
  local msg_1="$3"
  if [[ -z "$msg" && -z "$msg_1" ]]; then
    printf "\n"
    return
  fi
  # Если цвет не передан — используем NORMAL
  [[ -z "$msg_1" ]] && msg_1="$NORMAL"

  leading_spaces $1
  printf "%b%s%b\n" "${msg_1}" "${msg}" "${NORMAL}"
}

info_color_bi()
{
  local msg="$2"
  local msg_1="$3"
  local msg_2="$4"
  local msg_3="$5"
  local msg_4="$6"
  local msg_5="$7"
  if [[ -z "$msg" && -z "$msg_1" && -z "$msg_2" && -z "$msg_3" && -z "$msg_4" && -z "$msg_5" ]]; then
    printf "\n"
    return
  fi
  # Если цвет не передан — используем NORMAL
  [[ -z "$msg_1" ]] && msg_1="$NORMAL"
  [[ -z "$msg_3" ]] && msg_3="$NORMAL"
  [[ -z "$msg_5" ]] && msg_5="$NORMAL"

  leading_spaces $1
  printf "%b%s%b" "${msg_1}" "${msg}" "${NORMAL}"
  printf "%b%s%b" "${msg_3}" "${msg_2}" "${NORMAL}"
  printf "%b%s%b\n" "${msg_5}" "${msg_4}" "${NORMAL}"
}

info_triple()
{
  declare -r msg_1="$2" msg_2="$3" msg_3="$4"

  [[ -z ${msg_1} ]] && [[ -z ${msg_2} ]] && [[ -z ${msg_3} ]] && {
    printf "\n"
    return
  }
  leading_spaces "$1"
  printf "%b%s%b%b\n" "[${GREEN}✔${NORMAL}] ""${msg_1}${GREEN}${msg_2}${NORMAL}${msg_3}"
}

error()
{
  declare -r msg="$2"
  [[ -z ${msg} ]] && {
    printf "\n"
    return
  }
  leading_spaces $1
  printf "%b%s%b\n" "${RED}" "[✘ ERROR] ${msg}" "${NORMAL}"
}

progress()
{
  local spaces=$1
  local msg=$2
  local spin='-\|/'
  local i=0

  # Создаем строку с отступами
  local indent=$(printf "%${spaces}s" "")

  while true; do
    # Выводим отступ, сообщение, затем цветной спиннер и сброс
    printf "\r%s%s ${GREEN}%c${NORMAL}" "$indent" "$msg" "${spin:i++ % 4:1}"
    sleep 0.1
  done
}

press_enter()
{
  echo ""
  info_color 6 "Press Enter to restart or Ctrl+C to exit" "$CYAN"
  # -s: не выводить нажатый символ, -n 1: читать ровно 1 символ
  read -s -r
}

press_enter_repeat()
{
  error 6 "Press Enter to repeat..."
  # Скрыть курсор
  printf "\033[?25l"
  read -r
}

invalid_input()
{
  echo ""
  error 6 "Invalid input, type [y/n]:"
  error 6 "Press Enter to repeat..."
  # Скрыть курсор
  printf "\033[?25l"
  read -r
}

# =========================
# Функции общего назначения
# =========================

# Соответствие кодов языка YouTube (BCP 47) -> MKV (ISO 639-2)
yt_to_mkv_lang()
{
  local youtube_lang="$1"

  case "$youtube_lang" in
  ru) echo "rus" ;;
  en | en-US | en-GB | en-CA | en-AU) echo "eng" ;;
  de) echo "ger" ;;
  fr) echo "fre" ;;
  es) echo "spa" ;;
  it) echo "ita" ;;
  pt | pt-BR) echo "por" ;;
  zh | zh-CN | zh-TW) echo "chi" ;;
  ja) echo "jpn" ;;
  ko) echo "kor" ;;
  uk) echo "ukr" ;;
  pl) echo "pol" ;;
  nl) echo "dut" ;;
  sv) echo "swe" ;;
  no) echo "nor" ;;
  da) echo "dan" ;;
  fi) echo "fin" ;;
  cs) echo "cze" ;;
  sk) echo "slo" ;;
  hu) echo "hun" ;;
  ro) echo "rum" ;;
  bg) echo "bul" ;;
  sr) echo "srp" ;;
  hr) echo "hrv" ;;
  sl) echo "slv" ;;
  et) echo "est" ;;
  lv) echo "lav" ;;
  lt) echo "lit" ;;
  tr) echo "tur" ;;
  ar) echo "ara" ;;
  he) echo "heb" ;;
  hi) echo "hin" ;;
  id) echo "ind" ;;
  th) echo "tha" ;;
  vi) echo "vie" ;;
  *) echo "und" ;; # Все неизвестные языки → und

  esac
}

# Длительность видео
duration()
{
  local video_file="$1"

  DURATION=$("${FFPROBE_FILE}" -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "$video_file") >/dev/null 2>&1
  DURATION_FORMATTED=$(printf "%02d:%02d:%02d.000" $((${DURATION%.*} / 3600)) $(((${DURATION%.*} % 3600) / 60)) $((${DURATION%.*} % 60))) >/dev/null 2>&1
}

# Функция для очистки пути от экранирования
clean_path()
{
  local input="$1"

  # Удаляем кавычки, если они есть
  input="${input#\"}"
  input="${input%\"}"
  input="${input#\'}"
  input="${input%\'}"
  # Удаляем символы экранирования перед пробелами и спецсимволами
  # Но важно: не удаляем экранирование для скобок и других символов
  printf '%s\n' "$input" | sed 's/\\ / /g' | sed 's/\\\([][(){}]\)/\1/g'
}

# Очистить N строк вверх
clear_lines()
{
  local n=$1
  for (( i = 0; i < n; i++ )); do
    printf "\033[2K" # очистить строку
    printf "\033[1A" # вверх
  done
  printf "\033[2K" # очистить текущую
}

# Функция возвращает ID видеоролика
get_youtube_id()
{
  # 1. ссылка с ?v= (классическая)
  # 2. ссылка youtu.be/ID (короткая)
  # 3. ссылка /shorts/ID (шортсы)
  # 4. проверка, что остался корректный ID из 11 символов
  local id=$(
    echo "$1" | sed -E \
      -e 's/.*[?&]v=([a-zA-Z0-9_-]{11}).*/\1/' \
      -e 's/.*youtu\.be\/([a-zA-Z0-9_-]{11}).*/\1/' \
      -e 's/.*shorts\/([a-zA-Z0-9_-]{11}).*/\1/' \
      -e '/^[a-zA-Z0-9_-]{11}$/!d'
  )

  if [ -z "$id" ]; then
    error 6 "Wrong ID video" >&2
    return 1
  fi
  info_triple 6 "URL/ID accepted: " "$id" "" >&2
  echo "$id"
  return 0
}

# Очищаем строку от апострофов, эмодзи и лишних пробелов
get_clean_string() {
  local input="$1"
  # Удаление апострофов
  # Удаление эмодзи и нестандартных символов (оставляем буквы, цифры, пробелы, .,-_!?[])
  # Убираем подчеркивания и пробелы по краям
  # Сжатие множественных подчеркиваний
  echo "$input" | \
    sed "s/'//g" | \
    perl -CSDA -pe 's/[^\p{L}\p{N} .\-_!?,\[\]]//g' | \
    sed -E 's/ +/ /g; s/^[_ ]+//; s/[_ ]+$//' | \
    sed -E 's/_+/_/g'
}

# Проверка прав на запись в каталог
check_access_dir() {
  local dir="$1"

  if mkdir -p "$dir" 2>/dev/null; then
    return 0
  else
    error 6 "Access to ${dir} is denied"
    error 6 "Run Terminal with Root or change the Working Directory"
    echo ""
    info_color 6 "Press Enter to close this window..." $CYAN
    # </dev/tty нужен, так как stdin уже занят или перенаправлен и read -r читает не клавиатуру,
    # а уже «пустой» поток ввода, поэтому делаем чтение напрямую из терминала
    read -r </dev/tty
    return 1
  fi
}

# Проверка зависимостей
check_file() {
  local path="$1"
  local name="$2"

  if [[ ! -f "$path" ]]; then
    error 3 "Not found: $name ($path)"
    return 1
  fi

  return 0
}

# =========================
# Функции сетевые
# =========================

# Скачивание субтитров на нескольких языках
download_subs()
{
  local video_url="$1"
  local output_dir="$2"
  local base_name="$3"
  shift 3
  # оставшиеся аргументы — языки
  local languages=("$@")

  for lang in "${languages[@]}"; do
    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    if [[ ${status} == "false" ]]; then
      return 1
    fi
    "${NODE_VOT_CLI[@]}" \
      --subs-srt \
      --reslang="$lang" \
      --output="$output_dir" \
      --output-file="${base_name}.${lang}.srt" \
      "$video_url" >/dev/null 2>&1

    if [ -f "${output_dir}/${base_name}.${lang}.srt" ]; then
      info_triple 6 "Subtitles " "$(echo "$lang" | tr '[:lower:]' '[:upper:]')" " saved"
    else
      if [[ "$mode_id" == "single" || "$ai_ru_pause" == "true" ]]; then
        while true; do
          # Сохранить позицию курсора
          printf "\033[s"

          echo ""
          info_color_bi 6 "Subtitles " "" "$(echo "$lang" | tr '[:lower:]' '[:upper:]')" "$RED" " not downloaded" ""
          info_color 6 "You can try downloading it manually using the VOICE-OVER-TRANSLATION browser extension."
          info_color 6 "Do not select \"y\" until the .srt file is placed to the WORKING DIRECTORY."
          echo ""

          printf "\033[?25h"
          info_color_bi 9 ".srt file is ready? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
          # Показать курсор
          printf "\033[?25h"
          echo -n $'\033[9C'
          read -r ans </dev/tty

          result=1 # по умолчанию ошибка

          case "$ans" in
          y | Y | н | Н )
            SRT_FILE=("${WORKDIR}"/*.srt)
            if [ -f "${SRT_FILE[0]}" ]; then
              mv "${SRT_FILE[0]}" "${PROJECT_DIR}/${FILENAME}.${lang}.srt"
              result=0
              clear_lines 7
              info_triple 6 "Subtitles " "$(echo "$lang" | tr '[:lower:]' '[:upper:]')" " saved"
              break
            else
              # Скрыть курсор
              printf "\033[?25l"
              echo ""
              error 9 ".srt file not found in WORKING DIRECTORY, new try..."
              sleep 8
              # Очистка перед повтором
              printf "\033[u"
              clear_lines 9
            fi
            ;;
          n | N | т | Т )
            clear_lines 6

            status=false
            msg="Subtitles $(echo "$lang" | tr '[:lower:]' '[:upper:]') not downloaded"
            error 6 "$msg"
            ERROR="$msg"

            result=1
            break
            ;;
          *)
            echo ""
            error 9 "Invalid input, type [y/n]:"
            error 9 "Press Enter to repeat..."
            # Скрыть курсор
            printf "\033[?25l"
            read -r </dev/tty
            clear_lines 11
            ;;
          esac
        done

        # Скрыть курсор
        printf "\033[?25l"
      elif [[ "$ai_ru_pause" == "false" ]]; then
        status=false
        msg="Subtitles $(tr '[:lower:]' '[:upper:]' <<<"$lang") not downloaded"
        error 6 "$msg"
        ERROR="$msg"
      fi
    fi
  done
}

# Загрузка ИИ субтитров и голосового перевода
download_voice()
{
  voice_lang="ru"

  # Запускаем прогресс в фоне и сохраняем его PID
  printf "\r\033[K"
  progress 10 "Voice downloading" &
  progress_pid=$!

  # Загрузка русского ИИ перевода через vot-cli-live
  "${NODE_VOT_CLI[@]}" \
    "https://www.youtube.com/watch?v=${YT_VIDEO_ID}" \
    --reslang=$voice_lang \
    --voice-style=live \
    --output="$PROJECT_DIR" \
    --output-file="${FILENAME}.mp3" >/dev/null 2>&1

  # Останавливаем прогресс
  printf "\r\033[K"
  kill $progress_pid 2>/dev/null
  wait $progress_pid 2>/dev/null

  if [ -f "${PROJECT_DIR}/${FILENAME}.mp3" ]; then
    info_triple 6 "Voice " "RU" " saved"
  else
    if [[ "$mode_id" == "single" || "$ai_ru_pause" == "true" ]]; then
      while true; do
        # Сохранить позицию курсора
        printf "\033[s"

        echo ""
        info_color_bi 6 "Voice " "" "RU" "$RED" " not downloaded" ""
        info_color 6 "You can try downloading it manually using the VOICE-OVER-TRANSLATION browser extension."
        info_color 6 "Do not select \"y\" until the .mp3 file is placed to the WORKING DIRECTORY."
        echo ""

        printf "\033[?25h"
        info_color_bi 9 ".mp3 file is ready? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
        # Показать курсор
        printf "\033[?25h"
        echo -n $'\033[9C'
        read -r ans </dev/tty

        result=1 # по умолчанию ошибка

        case "$ans" in
        y | Y | н | Н )
          MP3_FILE=("${WORKDIR}"/*.mp3)
          if [ -f "${MP3_FILE[0]}" ]; then
            mv "${MP3_FILE[0]}" "${PROJECT_DIR}/${FILENAME}.mp3"
            result=0
            clear_lines 7
            info_triple 6 "Voice " "RU" " saved"
            break
          else
            # Скрыть курсор
            printf "\033[?25l"
            echo ""
            error 9 ".mp3 file not found in WORKING DIRECTORY, new try..."
            sleep 8
            # Очистка перед повтором
            printf "\033[u"
            clear_lines 9
          fi
          ;;
        n | N | т | Т )
          clear_lines 7

          status=false
          msg="Voice RU not downloaded"
          error 6 "$msg"
          ERROR="$msg"

          result=1
          break
          ;;
        *)
          echo ""
          error 9 "Invalid input, type [y/n]:"
          error 9 "Press Enter to repeat..."
          # Скрыть курсор
          printf "\033[?25l"
          read -r </dev/tty
          clear_lines 11
          ;;
        esac
      done

      # Скрыть курсор
      printf "\033[?25l"

      return $result
    elif [[ "$ai_ru_pause" == "false" ]]; then
      status=false
      msg="Voice RU not downloaded"
      error 6 "$msg"
      ERROR="$msg"
    fi
  fi
}

# =========================
# Меню
# =========================

# Стартовое меню
init_config()
{
  if use_saved_config; then
    return 0
  fi

  # 1. Выбор рабочей директории
  select_workdir || return 1

  # 2. Выбор браузера и профиля
  browser_select || return 1

  # 3. Сохранить всё
  save_config
}

# Сохранение конфигурации в файл
save_config()
{
  cat >"$SCRIPT_DIR/config.txt" <<EOF
WORKDIR="$WORKDIR"
BROWSER="$YT_BROWSER"
PROFILE="$YT_PROFILE_PATH"
EOF
}

# Загрузка конфигурации
load_config()
{
  logo

  if [ -f "$SCRIPT_DIR/config.txt" ]; then
    unset WORKDIR BROWSER PROFILE
    source "$SCRIPT_DIR/config.txt"

    YT_BROWSER="$BROWSER"
    YT_PROFILE_PATH="$PROFILE"

    export WORKDIR YT_BROWSER YT_PROFILE_PATH

    if [[ $YT_BROWSER == "chrome" ]]; then
      YT_BROWSER_UI="Google Chrome"
    elif [[ $YT_BROWSER == "firefox" ]]; then
      YT_BROWSER_UI="Mozilla Firefox"
    fi
    return 0
  fi
  return 1
}

# Автодетектирование профиля
detect_default_profile() {
  local browser="$1"
  local base="$2"
  local default_profile=""

  case "$browser" in
  firefox)
    local ini_file

    if [ "$browser" = "firefox" ]; then
      if [ "$OS_TYPE" = "Darwin" ]; then
        ini_file="$HOME/Library/Application Support/firefox/profiles.ini"
      else
        ini_file="$HOME/.config/mozilla/firefox/profiles.ini"
      fi
    fi

    if [ -f "$ini_file" ]; then
      # Логика поиска профиля:
      # Если в какой-либо секции при Locked=1 путь Default совпадает с путём Path в секции,
      # где IsRelative=1, значит это искомый профиль.
      # 1. Получаем целевой путь из секции [Install...]
      _path=$(
        awk -F'=' '
          /^\[Install/ { in_inst=1 }
          in_inst && /^Default=/ { t=$2 }
          in_inst && /^Locked=1/ { print t; exit }
          /^$/ { in_inst=0 }
      ' "$ini_file"
      )

      # 2. Проверяем его в секциях [Profile...]
      # Мы добавляем переменную "found", чтобы END знал, нужно ли печатать
      default_profile=$(
        awk -F'=' -v target="$_path" '
          /^\[Profile/ { in_prof=1; path=""; rel=0 }
          in_prof && /^Path=/ { path=$2 }
          in_prof && /^IsRelative=/ { rel=$2 }

          # Проверка в конце секции (пустая строка)
          /^$/ {
              if (in_prof && path == target && rel == 1) {
                  print path
                  found=1
                  exit
              }
              in_prof=0
          }

          # Блок END сработает после exit, но напечатает только если
          # мы НЕ нашли ничего в основном цикле (на случай отсутствия пустой строки в конце)
          END {
              if (!found && in_prof && path == target && rel == 1) {
                  print path
              }
          }
      ' "$ini_file"
      )

      if [ -n "$default_profile" ]; then
        default_profile="$base/$default_profile"
      fi
    fi
    ;;
  chrome)
    local state_file="$base/Local State"

    if [ -f "$state_file" ]; then
      default_profile=$(
        grep -o '"last_used":"[^"]*"' "$state_file" \
          | cut -d'"' -f4
      )

      if [ -n "$default_profile" ]; then
        default_profile="$base/$default_profile"
      fi
    fi
    ;;
  esac

  echo "$default_profile"
}

# Получение профилей для всех Chromium-браузеров
get_chromium_profiles() {
  local dir="$1"
  local result=()

  if [ -d "$dir/Default" ]; then
    result+=("$dir/Default")
  fi

  for p in "$dir"/Profile\ *; do
    [ -d "$p" ] && result+=("$p")
  done

  if [ -d "$dir/Guest Profile" ]; then
    result+=("$dir/Guest Profile")
  fi

  # ВАЖНО: построчный вывод
  printf '%s\n' "${result[@]}"
}

# Стартовое меню: браузер
browser_select()
{
  while true; do
    logo

    # Показать курсор
    printf "\033[?25h"

    echo ""
    info_color 3 "SELECT BROWSER:"
    echo ""
    info_color 6 "1. Mozilla Firefox"
    info_color 6 "2. Google Chrome"
    # info_color 3 "10. Quit"
    echo ""
    info_color_bi 6 "Enter option number [" "$CYAN" "1-2" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r browser_choice

    case $browser_choice in
    1)
      BROWSER="firefox"
      YT_BROWSER_UI="Mozilla Firefox"
      break
      ;;
    2)
      BROWSER="chrome"
      YT_BROWSER_UI="Google Chrome"
      break
      ;;
    # 10)
    #     return 1
    #     ;;
    *)
      echo ""
      error 6 "Enter a number from 1 to 2"
      press_enter_repeat
      ;;
    esac
  done

  # ===== поиск профилей =====
  local base=""
  local profiles=()
  local i=1

  case "$BROWSER" in
  firefox)
    if [ "$OS_TYPE" = "Darwin" ]; then
      base="$HOME/Library/Application Support/Firefox"
    else
      base="$HOME/.config/mozilla/firefox"
    fi
    ;;
  chrome)
    if [ "$OS_TYPE" = "Darwin" ]; then
      base="$HOME/Library/Application Support"
    else
      base="$HOME/.config"
    fi
    ;;
  esac

  # подбор конкретных директорий
  case "$BROWSER" in
  firefox)
    if [ "$OS_TYPE" = "Darwin" ]; then
      profiles=("$base/Profiles"/*)
    else
      profiles=()

      ini_file="$base/profiles.ini"

      if [ -f "$ini_file" ]; then
        while IFS= read -r path; do
          full_path="$base/$path"
          [ -d "$full_path" ] && profiles+=("$full_path")
        done < <(awk -F= '/^Path=/{print $2}' "$ini_file")
      fi
    fi
    ;;
  chrome)
    if [ "$OS_TYPE" = "Darwin" ]; then
      case "$BROWSER" in
      chrome)
        browser_dir="$base/Google/Chrome"
        ;;
      esac
    else
      case "$BROWSER" in
      chrome)
        browser_dir="$base/google-chrome"
        ;;
      esac
    fi

    profiles=()

    # получаем профили безопасно
    while IFS= read -r p; do
      [ -d "$p" ] && profiles+=("$p")
    done < <(get_chromium_profiles "$browser_dir")

    ;;
  esac

  # ===== фильтрация реальных папок =====
  local valid_profiles=()
  for p in "${profiles[@]}"; do
    if [ -d "$p" ]; then
      valid_profiles+=("$p")
    fi
  done

  # ===== если ничего не найдено =====
  if [ ${#valid_profiles[@]} -eq 0 ]; then
    # Скрыть курсор
    printf "\033[?25l"

    # Поднимаемся на 2 строки вверх и стираем их
    clear_lines 2

    error 6 "No profiles found for $YT_BROWSER_UI"
    press_enter_repeat
    browser_select
  fi

  # ===== автоопределение дефолтного профиля =====
  if [[ "$BROWSER" =~ ^(chrome|brave|edge|vivaldi|opera|chromium)$ ]]; then
    DEFAULT_PROFILE=$(detect_default_profile "$BROWSER" "$browser_dir")
  else
    DEFAULT_PROFILE=$(detect_default_profile "$BROWSER" "$base")
  fi

  # fallback если не нашли
  if [ -z "$DEFAULT_PROFILE" ] || [ ! -d "$DEFAULT_PROFILE" ]; then
    for p in "${valid_profiles[@]}"; do
      if [[ "$(basename "$p")" == "Default" ]]; then
        DEFAULT_PROFILE="$p"
        break
      fi
    done
  fi

  # если всё ещё пусто — берём первый
  if [ -z "$DEFAULT_PROFILE" ]; then
    DEFAULT_PROFILE="${valid_profiles[0]}"
  fi

  # ===== выбор профиля =====
  while true; do
    logo
    printf "\033[?25h"

    echo ""
    info_color 3 "SELECT PROFILE FOR: $(echo "$BROWSER" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}')"
    echo ""

    i=1
    for p in "${valid_profiles[@]}"; do
      if [ "$p" = "$DEFAULT_PROFILE" ]; then
        info_color 6 "$i. $p ← default" "$GREEN"
      else
        info_color 6 "$i. $p"
      fi
      ((i++))
    done

    echo ""
    info_color_bi 6 "Enter profile [" "$CYAN" "1-${#valid_profiles[@]}" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r profile_choice

    if [[ "$profile_choice" =~ ^[0-9]+$ ]] && \
      [ "$profile_choice" -ge 1 ] && \
      [ "$profile_choice" -le "${#valid_profiles[@]}" ]; then
      PROFILE_PATH="${valid_profiles[$((profile_choice - 1))]}"

      export YT_BROWSER="$BROWSER"
      export YT_PROFILE_PATH="$PROFILE_PATH"

      save_config

      main_menu

      return 0
    fi

    echo ""
    error 6 "Invalid choice"
    press_enter_repeat
  done
}

# Стартовое меню: рабочая директория
select_workdir()
{
  while true; do
    logo
    printf "\033[?25h"

    echo ""
    info_color 3 "SELECT WORKING DIRECTORY"
    echo ""
    info_color 6 "Enter path to working directory:" "$CYAN"
    echo -n $'\033[6C'
    read -r workdir_raw

    # Скрыть курсор
    printf "\033[?25l"

    WORKDIR=$(clean_path "$workdir_raw")

    if [[ -z "$WORKDIR" ]]; then
      error 6 "Path cannot be empty"
      error 6 "Press Enter to repeat..."
      read -r
      continue
    fi

    # Создать если не существует
    if [[ ! -d "$WORKDIR" ]]; then
      mkdir -p "$WORKDIR" 2>/dev/null
      if [[ $? -ne 0 ]]; then
        error 6 "Cannot create directory"
        read -r
        continue
      fi
    fi

    export WORKDIR
    return 0
  done
}

# Принятие конфигурации или создание новой
use_saved_config()
{
  while true; do
    if load_config; then
      # Показать курсор
      printf "\033[?25h"
      echo ""
      info_color 3 "SAVED CONFIG FOUND"
      echo ""
      info_color_bi 6 "Working directory: " "" "$WORKDIR" "$GRAY" "" ""
      info_color_bi 6 "Browser: " "" "$YT_BROWSER_UI" "$GRAY" "" ""
      info_color_bi 6 "Browser profile: " "" "$YT_PROFILE_PATH" "$GRAY" "" ""
      echo ""

      info_color_bi 6 "Use saved config? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
      echo -n $'\033[6C'
      read -r ans

      case "$ans" in
      y | Y | н | Н )
        return 0
        ;;
      n | N | т | Т )
        return 1
        ;;
      *)
        invalid_input
        ;;
      esac
    else
      return 1
    fi
  done
  return 1
}

# Меню упрощенного режима хранения видео
menu_light_storage()
{
  storage="full"

  while true; do
    logo

    eval "$mode"

    info_color 6 "Light storage"
    echo ""
    info_color 6 "When choosing lightweight storage, all videos will be in" $GRAY
    info_color 6 "one channel directory, and there will be no other files." $GRAY
    info_color 6 "Otherwise, each video will be in its own directory along" $GRAY
    info_color 6 "with metadata, previews, subtitles, and chapters." $GRAY
    echo ""

    # Показать курсор
    printf "\033[?25h"

    info_color_bi 6 "Use light storage? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "_storage_"

    case $_storage_ in
    y | Y | н | Н )
      storage="light"
      break
      ;;
    n | N | т | Т )
      storage="full"
      break
      ;;
    *)
      invalid_input
      ;;
    esac
  done
}

# Mеню разрешений видео
menu_resolution()
{
  while true; do
    logo

    eval "$mode"

    info_color 6 "Select video resolution:"
    echo ""
    info_color 6 "1. 360p"
    info_color 6 "2. 480p"
    info_color 6 "3. 720p"
    info_color 6 "4. 1080p"
    info_color 6 "5. 1440p"
    info_color 6 "6. 2160p"
    info_color 6 "7. Best"
    info_color 6 "8. Quit to Main menu"
    echo ""

    # Показать курсор
    printf "\033[?25h"

    info_color_bi 6 "Enter option number [" "$CYAN" "1-8" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "choice"

    case $choice in
    1)
      USER_RESOLUTION="360p"
      break
      ;;
    2)
      USER_RESOLUTION="480p"
      break
      ;;
    3)
      USER_RESOLUTION="720p"
      break
      ;;
    4)
      USER_RESOLUTION="1080p"
      break
      ;;
    5)
      USER_RESOLUTION="1440p"
      break
      ;;
    6)
      USER_RESOLUTION="2160p"
      break
      ;;
    7)
      USER_RESOLUTION="Best"
      break
      ;;
    8)
      main_menu
      ;;
    *)
      echo ""
      error 6 "Enter a number from 1 to 8"
      press_enter_repeat
      ;;
    esac
  done
}

# Меню паузы при загрузке AI Ru
menu_pause_switch()
{
  ai_ru_pause=false

  while true; do
    logo

    eval "$mode"

    info_color 6 "Downloading from Yandex AI translation may fail"
    echo ""
    info_color 6 "You can pause the program if the .mp3/.srt file has not been downloaded." "$GRAY"
    info_color 6 "During this time, you can download these files manually," "$GRAY"
    info_color 6 "using the VOICE-OVER-TRANSLATION browser extension." "$GRAY"
    info_color 6 "File must be placed in the WORKING DIRECTORY." "$GRAY"
    echo ""
    info_color 6 "If you don't pause, the video with this issue will be skipped."
    echo ""

    # Показать курсор
    printf "\033[?25h"

    info_color_bi 6 "Use pause? [" "$CYAN" "y/n" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "ai_ru_pause"

    case $ai_ru_pause in
    y | Y | н | Н )
      ai_ru_pause=true
      break
      ;;
    n | N | т | Т )
      ai_ru_pause=false
      break
      ;;
    *)
      invalid_input
      ;;
    esac
  done
}

# Mеню вкл/выкл ИИ перевода
menu_trans_ai_switch()
{
  FORCE_LNG="off"

  while true; do
    logo

    eval "$mode"

    info_color 6 "Yandex AI translation into Russian:"
    echo ""
    info_color 6 "1. Voice + subtitles"
    info_color 6 "2. Only voice"
    info_color 6 "3. Only subtitles"
    printf "      4. ${RED}✘${NORMAL} No translation\n"
    info_color 6 "5. Quit to Main menu"
    echo ""

    # Показать курсор
    printf "\033[?25h"

    info_color_bi 6 "Enter option number [" "$CYAN" "1-5" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "choice"

    case $choice in
    1)
      RU_TRANS="vo+sb"
      break
      ;;
    2)
      RU_TRANS="vo"
      break
      ;;
    3)
      RU_TRANS="sb"
      break
      ;;
    4)
      RU_TRANS="off"
      break
      ;;
    5)
      main_menu
      ;;
    *)
      echo ""
      error 6 "Enter a number from 1 to 5"
      press_enter_repeat
      ;;
    esac
  done
}

# Mеню форсирования языка
menu_force_lng()
{
  while true; do
    logo

    eval "$mode"

    info_color 6 "Force language if N/A*:"
    info_color 6 "Languages supported by Yandex AI translator" "$GRAY"
    echo ""
    info_color 6 "* Sometimes the language is not detected," "$GRAY"
    info_color 8 "in which case the translation won't load." "$GRAY"
    info_color 8 "If the language is recognized, the forcing will be ignored." "$GRAY"
    echo ""
    printf "       1. ${RED}✘${NORMAL} No force\n"
    info_color 6 " 2. English"
    info_color 6 " 3. German"
    info_color 6 " 4. French"
    info_color 6 " 5. Spanish"
    info_color 6 " 6. Italian"
    info_color 6 " 7. Japanese"
    info_color 6 " 8. Korean"
    info_color 6 " 9. Chinese"
    info_color 6 "10. Lithuanian"
    info_color 6 "11. Latvian"
    info_color 6 "12. Arabic"
    info_color 6 "13. Quit to Main menu"
    echo ""

    # Показать курсор
    printf "\033[?25h"

    info_color_bi 6 "Enter option number [" "$CYAN" "1-13" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "choice_lng"

    case $choice_lng in
    1)
      FORCE_LNG="off"
      break
      ;;
    2)
      FORCE_LNG="en-US"
      break
      ;;
    3)
      FORCE_LNG="de"
      break
      ;;
    4)
      FORCE_LNG="fr"
      break
      ;;
    5)
      FORCE_LNG="es"
      break
      ;;
    6)
      FORCE_LNG="it"
      break
      ;;
    7)
      FORCE_LNG="ja"
      break
      ;;
    8)
      FORCE_LNG="ko"
      break
      ;;
    9)
      FORCE_LNG="zh-CN"
      break
      ;;
    10)
      FORCE_LNG="lt"
      break
      ;;
    11)
      FORCE_LNG="lv"
      break
      ;;
    12)
      FORCE_LNG="ar"
      break
      ;;
    13)
      main_menu
      ;;
    *)
      echo ""
      error 6 "Enter a number from 1 to 13"
      press_enter_repeat
      ;;
    esac
  done
}

# Основное меню
main_menu()
{
  while true; do
    logo

    # Показать курсор
    printf "\033[?25h"

    echo ""
    info_color 3 "SELECT MODE:"
    echo ""
    info_color 6 "1. One URL"
    info_color 6 "2. Batch of URLs"
    info_color 6 "3. Batch of URLs (interrupt)"
    info_color 6 "4. Create URLs list"
    info_color 6 "5. Check Ru voice/sub"
    info_color 6 "6. Quit"
    echo ""
    info_color_bi 6 "Enter option number [" "$CYAN" "1-6" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r choice

    case $choice in
    1)
      mode_single
      ;;
    2)
      interrupt=false
      mode_batch $interrupt mode_single_core

      ;;
    3)
      interrupt=true
      mode_batch $interrupt mode_single_core
      ;;
    4)
      mode_list
      ;;
    5)
      check_voice check_voice_core
      ;;
    6)
      logo
      info_color 6 ""
      info_color 6 "Good bye..." "$GREEN"
      echo ""
      info_color 6 "Press Enter to close this window..." "$CYAN"
      # Скрыть курсор
      printf "\033[?25l"
      read -r
      printf "%12s" | tr ' ' '\n'
      exit 0
      ;;
    *)
      echo ""
      error 6 "Enter a number from 1 to 6"
      press_enter_repeat
      ;;
    esac
  done
}

# =========================
# Основные режимы работы:
# 'single' вручную по одной ссылке 
# 'batch' пакетная обработка списка ссылок
# 'list' создание списка ссылок всего канала
# =========================

mode_single_core()
{
  # Инициализируем и сбрасываем статус
  status=true

  # Получение основных метаданных видео
  result_json=$(
    "${YT_DLP_FILE}" \
      --ffmpeg-location "${FFMPEG_FILE}" \
      --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" \
      --js-runtimes "node:$OS_DIR/node/bin/node" \
      --extractor-args "youtube:player_client=default" \
      --force-ipv4 \
      --quiet \
      --dump-json \
      --skip-download \
      -- "$YT_VIDEO_ID"
  )

  result_meta=$(
    "${JQ_FILE}" -r '
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
    ' <<<"$result_json"
  )

  raw_data=$(
    "${JQ_FILE}" -r '
    [
        (.language // "N/A"),
        (.channel // "N/A"),
        (.title // "N/A"),
        (if .upload_date then (.upload_date | "\(.[0:4])_\(.[4:6])_\(.[6:8])") else "N/A" end),
        ([.formats[]? | select(.height != null) | .height] | unique | sort | map(tostring) | join(" "))
    ] | @tsv
    ' <<<"$result_json"
  )

  # Разбиваем строку в массив
  # Используем IFS (разделитель), чтобы корректно обработать табуляцию
  IFS=$'\t' read -ra data_array <<<"$raw_data"

  LANGUAGE="${data_array[0]}"
  CHANNEL=$(get_clean_string "${data_array[1]}")
  TITLE=$(get_clean_string "${data_array[2]}")
  UPLOAD_DATE="${data_array[3]}"
  RESOLUTIONS="${data_array[4]}"

  # Условие "$LANGUAGE" == "N/A" защита от того, если разрешен перевод, язык видео русский и форсирован, к примеру, английский
  if [[ ${FORCE_LNG} != "off" ]] && [[ "$LANGUAGE" == "N/A" ]]; then
    LANGUAGE="${FORCE_LNG}"
    result_meta=$(echo "$result_meta" | sed "s/^\[language\]:.*$/[language]: ${FORCE_LNG}/")
  fi

  if [[ -z "$result_meta" || -z "$RESOLUTIONS" ]]; then
    status=false
    msg="Failed to get metadata"
    error 6 "$msg"
    ERROR="$msg"
    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    return 1
  else
    info_triple 6 "Title: " "${TITLE}" ""
    info_check 6 "Metadata saved"
  fi

  # 1. Заменяем опасные символы файловой системы на подчеркивания
  # 2. Удаляем эмодзи и нестандартных символов (оставляем буквы, цифры, пробелы, ., -, _, !)
  # 3. Обрезаем до 200 символов (по байтам UTF-8, сохраняя целые символы)
  # 4. Сжимаем множественные пробелы/подчеркивания в один
  FILENAME=$(
    echo "$TITLE" | \
      sed -E 's/[/\\:*"<>|]+/_/g' | \
      perl -CSDA -pe 's/[^\p{L}\p{N} .\-_!?]//g' | \
      perl -CSDA -pe '$_ = substr($_, 0, 200)' | \
      sed -E 's/[ ]+/_/g'
  )

  # Поведение в зависимости от значения Light storage
  if [[ "$storage" == "full" ]]; then
    PROJECT_DIR="${WORKDIR}/${CHANNEL}/${UPLOAD_DATE}_${FILENAME}_temp"
  else
    PROJECT_DIR="${WORKDIR}/${CHANNEL}"
  fi

  # Создаём каталог, проверяя права доступа
  check_access_dir "${PROJECT_DIR}" || exit 1
  # Поведение в зависимости от значения Light storage
  if [[ "$storage" == "full" ]]; then
    echo "$result_meta" >"${PROJECT_DIR}/info.txt"
  fi

  allowed_languages_ai=("en" "en-US" "en-GB" "en-CA" "en-AU" "de" "fr" "es" "it" "ja" "ko" "zh" "zh-CN" "zh-TW" "lt" "lv" "ar")

  if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]]; then
    if [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      download_voice
    fi

    if [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "sb" ]]; then
      subs_lang=("ru" "en")
      download_subs "https://www.youtube.com/watch?v=${YT_VIDEO_ID}" \
        "${PROJECT_DIR}" \
        "${FILENAME}" \
        "${subs_lang[@]}"
    fi

    ru_trans_unsupport="false"

    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    if [[ ${status} == "false" ]]; then
      return 1
    fi
  elif [[ ! " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$RU_TRANS" != "off" ]]; then
    info_uncheck 6 "Translation from $(echo "$LANGUAGE" | tr '[:lower:]' '[:upper:]') language into Russian is not supported"
    # $ru_trans_unsupport: когда перевод активирован, но по языку видео он не поддерживается,
    # в этом случае поток не должен попасть на большую обработку ffmpeg,
    # но в то же время не должно изменяться значение $RU_TRANS
    ru_trans_unsupport="true"
  fi

  if [[ "${USER_RESOLUTION}" == "Best" ]]; then
    FORMAT="bestvideo+bestaudio"
    ACTUAL_HEIGHT=$(echo $RESOLUTIONS | tr ' ' '\n' | sort -n | tail -1)
    info_triple 6 "Resolution: " "${ACTUAL_HEIGHT}p"
  else
    height="${USER_RESOLUTION%p}"
    FORMAT="bestvideo[height=${height}]+bestaudio / bestvideo[height<=${height}]+bestaudio / best"

    ACTUAL_HEIGHT=""

    for r in $RESOLUTIONS; do
      # если нашли точное совпадение — сразу берём
      if [ "$r" -eq "${USER_RESOLUTION%p}" ] 2>/dev/null; then
        ACTUAL_HEIGHT="$r"
        break
      fi
      # иначе запоминаем последнее меньшее
      if [ "$r" -lt "${USER_RESOLUTION%p}" ] 2>/dev/null; then
        ACTUAL_HEIGHT="$r"
      fi
    done

    if [[ "${USER_RESOLUTION%p}" != "${ACTUAL_HEIGHT}" ]]; then
      info_uncheck 6 "Resolution ${USER_RESOLUTION} not available ➜ set ${ACTUAL_HEIGHT}p"
    fi
  fi

  # Получение видео
  # Разбиваем на блоки, чтобы отдельно выделить Формат
  # Блок 1: Базовые опции
  # Два пробела перед %(progress._default_template)s = сдвиг на 2 символа вправо и далее по аналогии
  yt_dlp_base=(
    "${YT_DLP_FILE}"
    --ffmpeg-location
    "${FFMPEG_FILE}"
    --cookies-from-browser
    "${YT_BROWSER}:${YT_PROFILE_PATH}"
    --js-runtimes
    "node:$OS_DIR/node/bin/node"
    --extractor-args
    "youtube:player_client=default"
    --force-ipv4
    --quiet
    --progress
    --progress-template
    "          Media downloading%(progress._default_template)s"
  )
  # Блок 2: Опции формата
  yt_dlp_format=(
    -f
    "$FORMAT"
  )
  # Блок 3: Опции вывода и URL
  yt_dlp_output=(
    --merge-output-format
    mkv
    -o
    "${PROJECT_DIR}/${FILENAME}.%(ext)s"
    --
    "${YT_VIDEO_ID}"
  )
  # Создаём команду
  yt_dlp_full=(
    "${yt_dlp_base[@]}"
    "${yt_dlp_format[@]}"
    "${yt_dlp_output[@]}"
  )
  # Запускаем скачивание
  "${yt_dlp_full[@]}"

  # Ищем полученный MKV файл
  if [ -f "${PROJECT_DIR}/${FILENAME}.mkv" ]; then
    info_check 6 "Video saved"
  else
    status=false
    msg="MKV file not found in: ${PROJECT_DIR}"
    error 6 "$msg"
    ERROR="$msg"
    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    return 1
  fi

  # Поведение в зависимости от значения Light storage
  if [[ "$storage" == "full" ]]; then
    # Получение миниатюры
    curl -s -o "${PROJECT_DIR}/thumbnail.jpg" "https://i.ytimg.com/vi/${YT_VIDEO_ID}/maxresdefault.jpg" >/dev/null 2>&1

    if [[ -f "${PROJECT_DIR}/thumbnail.jpg" ]]; then
      info_check 6 "Thumbnail saved"
    else
      status=false
      msg="Failed to get thumbnail"
      error 6 "$msg"
      ERROR="$msg"
      # Защита от бесполезного выполнения, если на итерации произошла ошибка
      return 1
    fi
  fi

  # Длительность видео
  duration "${PROJECT_DIR}/${FILENAME}.mkv"

  # Получение глав
  CHAPTERS_RAW=$(
    "${JQ_FILE}" -r '
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
    ' <<<"$result_json"
  )

  CHAPTERS_XML="${PROJECT_DIR}/temp_chapters.xml"

  if [ -n "$CHAPTERS_RAW" ]; then
    # Поведение в зависимости от значения Light storage
    if [[ "$storage" == "full" ]]; then
      echo "$CHAPTERS_RAW" >"${PROJECT_DIR}/chapters.txt"
      info_check 6 "Chapters saved"
    fi

    echo '<?xml version="1.0" encoding="UTF-8"?>' >"$CHAPTERS_XML"
    echo '<!DOCTYPE Chapters SYSTEM "matroskachapters.dtd">' >>"$CHAPTERS_XML"
    echo '<Chapters>' >>"$CHAPTERS_XML"
    echo '  <EditionEntry>' >>"$CHAPTERS_XML"
    echo '    <EditionUID>1</EditionUID>' >>"$CHAPTERS_XML"
    echo '    <EditionFlagHidden>0</EditionFlagHidden>' >>"$CHAPTERS_XML"
    echo '    <EditionFlagDefault>0</EditionFlagDefault>' >>"$CHAPTERS_XML"

    prev_time=""
    prev_title=""
    chapter_uid=1

    echo "$CHAPTERS_RAW" | while IFS= read -r line; do
      [ -z "$line" ] && continue

      time=$(echo "$line" | awk '{print $1".000"}')
      title=$(echo "$line" | cut -d' ' -f2-)

      if [ -n "$prev_time" ]; then
        cat >>"$CHAPTERS_XML" <<EOF
        <ChapterAtom>
          <ChapterUID>$chapter_uid</ChapterUID>
          <ChapterTimeStart>$prev_time</ChapterTimeStart>
          <ChapterTimeEnd>$time</ChapterTimeEnd>
          <ChapterDisplay>
            <ChapterString>$prev_title</ChapterString>
            <ChapterLanguage>eng</ChapterLanguage>
          </ChapterDisplay>
        </ChapterAtom>
EOF
        ((chapter_uid++))
      fi

      prev_time="$time"
      prev_title="$title"
    done

    # Добавляем последнюю главу
    if [ -n "$prev_time" ]; then
      cat >>"$CHAPTERS_XML" <<EOF
        <ChapterAtom>
          <ChapterUID>$chapter_uid</ChapterUID>
          <ChapterTimeStart>$prev_time</ChapterTimeStart>
          <ChapterTimeEnd>$DURATION_FORMATTED</ChapterTimeEnd>
          <ChapterDisplay>
            <ChapterString>$prev_title</ChapterString>
            <ChapterLanguage>eng</ChapterLanguage>
          </ChapterDisplay>
        </ChapterAtom>
EOF
    fi

    echo '  </EditionEntry>' >>"$CHAPTERS_XML"
    echo '</Chapters>' >>"$CHAPTERS_XML"
  else
    info_uncheck 6 "No chapters to save"
  fi

  if [[ "$status" == "true" ]]; then
    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$LANGUAGE" != "ru" ]] &&
      [[ "$LANGUAGE" != "N/A" ]] && [[ "$RU_TRANS" != "off" ]] && [[ "$ru_trans_unsupport" == "false" ]]; then
      SUFFIX="_RUS"
    else
      SUFFIX=""
    fi

    FINAL_MKV="${PROJECT_DIR}/${FILENAME}_${UPLOAD_DATE}${SUFFIX}_${ACTUAL_HEIGHT}p.mkv"

    # === ОРИГИНАЛЬНЫЙ ГОЛОС + РУССКАЯ ОЗВУЧКА + 2 СУБТИТРА ===
    trap 'printf "\r\033[K\n"' EXIT

    # Собираем аргументы в массив
    ff_args=(
      "${FFMPEG_FILE}"
      -i
      "${PROJECT_DIR}/${FILENAME}.mkv"
    )

    # Добавляем файл озвучки (только -i, без -map)
    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      ff_args+=(-i "${PROJECT_DIR}/${FILENAME}.mp3")
    fi

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "sb" ]]; then
      # Добавляем субтитры как входные файлы (только -i, без -map)
      ff_args+=(-i "${PROJECT_DIR}/${FILENAME}.ru.srt")
      ff_args+=(-i "${PROJECT_DIR}/${FILENAME}.en.srt")
    fi

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      if [ "$OS_TYPE" = "Linux" ]; then
        # Запускаем прогресс в фоне и сохраняем его PID
        progress 10 "Audio mixing" &
        progress_pid=$!
      fi

      ff_args+=(
        -filter_complex
        "[0:a]aformat=channel_layouts=stereo[bg];

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

        [a_mix]loudnorm=I=-16:LRA=9:TP=-1.5[a_mixed]"
      )
    fi

    ff_args+=(
      -map
      0:v # Поток видео
    )

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      ff_args+=(
        -map
        "[a_mixed]"
        -map
        1:a
      )
    fi

    ff_args+=(
      -map
      0:a # Поток аудио оригинальный
    )

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "sb" ]]; then
      # Добавляем MAP для выходного файла (после всех входных)
      # Определяем индекс первого субтитра
      # Всегда: 0 - mkv
      # Далее: если есть mp3, то 1 - mp3, затем 2 - ru.srt, 3 - en.srt
      #        если нет mp3, то 1 - ru.srt, 2 - en.srt
      local srt_index=2 # По умолчанию (когда есть mp3)

      # Проверяем, был ли добавлен mp3
      if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
        [[ "$RU_TRANS" == "sb" ]]; then
        srt_index=1 # Если нет mp3, то субтитры на индексах 1 и 2
      fi

      ff_args+=(-map "${srt_index}:s")
      srt_index=$((srt_index + 1))
      ff_args+=(-map "${srt_index}:s")
      ff_args+=(-metadata:s:s:0 title='AI Yandex Rus')
      ff_args+=(-metadata:s:s:0 language=rus)
      ff_args+=(-metadata:s:s:1 title='AI Yandex Eng')
      ff_args+=(-metadata:s:s:1 language=eng)
    fi

    if [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]] && [[ "$ru_trans_unsupport" == "false" ]]; then
      a_index=2
    else
      a_index=0
    fi

    ff_args+=(
      -c:v
      copy # Копируем видео без изменений
    )

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      ff_args+=(
        -c:a:0
        aac # Первый аудиопоток (смешанный) кодируем в AAC
        -b:a:0
        128k # Битрейт для первого аудиопотока
        -c:a:1
        copy # Второй аудиопоток (RU голос) копируем без изменений
      )
    fi

    ff_args+=(
      -c:a:${a_index}
      copy # Третий или единственный оригинальный аудиопоток копируем без изменений
    )

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "sb" ]]; then
      ff_args+=(
        -c:s
        copy # Копируем субтитры без изменений
      )
    fi

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      ff_args+=(
        -metadata:s:a:0
        title="AAC 2 ch 128 kbps AI Yandex Mixed Rus"
        -metadata:s:a:0
        language=rus
        -metadata:s:a:1
        title="MP3 1 ch 128 kbps AI Yandex Rus"
        -metadata:s:a:1
        language=rus
      )
    fi

    ff_args+=(
      -metadata:s:a:${a_index}
      title="AAC 2 ch 128 kbps $(
        echo "$(yt_to_mkv_lang "$LANGUAGE")" | awk '{print toupper(substr($0,1,1)) tolower(substr($0,2))}'
      )"
      -metadata:s:a:${a_index}
      language=$(yt_to_mkv_lang "$LANGUAGE")
    )

    ff_args+=(
      -metadata
      title="${TITLE}"
      -progress
      pipe:1
      -nostats
      "${FINAL_MKV}"
    )

    if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
      [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "vo" ]]; then
      # Запускаем и обрабатываем прогресс
      "${ff_args[@]}" 2>&1 |
        grep --line-buffered out_time |
        LC_NUMERIC=C awk -v duration="$DURATION" '{
              if ($0 ~ /out_time=/) {
                  split($0,a,"=");
                  time=a[2];
                  gsub(/:/," ",time);
                  split(time,t," ");
                  sec=t[1]*3600 + t[2]*60 + t[3];
                  percent = (sec/duration)*100;
                  printf "\r\033[K          Audio mixing: \033[32m%.1f%%\033[0m", percent;
                  fflush();
                  if (percent >= 100) {
                      printf "\r\033[K";
                      fflush();
                      exit;
                  }
              }
          }
          END {
              printf "\r\033[K";
              fflush();
          }'

      if [ "$OS_TYPE" = "Linux" ]; then
        # Останавливаем прогресс
        kill $progress_pid 2>/dev/null
        wait $progress_pid 2>/dev/null
      fi
    else
      "${ff_args[@]}" >/dev/null 2>&1
    fi

    mkv_args=(
      "${MKVPROPEDIT_FILE}"
      "${FINAL_MKV}"
    )

    if [ -f "${PROJECT_DIR}/${FILENAME}.mp3" ]; then
      mkv_args+=(
        --edit
        track:a1
        --set
        flag-default=1
        --edit
        track:a2
        --set
        flag-default=0
        --edit
        track:a3
        --set
        flag-default=0
      )
      info_triple 6 "Voice " "RU" " added"
      rm "${PROJECT_DIR}/${FILENAME}.mp3"
    fi

    if [[ -f "${PROJECT_DIR}/${FILENAME}.ru.srt" && -f "${PROJECT_DIR}/${FILENAME}.en.srt" ]]; then
      mkv_args+=(
        --edit
        track:s1
        --set
        flag-default=0
        --edit
        track:s2
        --set
        flag-default=0
      )
      info_triple 6 "Subtitles " "RU" " added"
      info_triple 6 "Subtitles " "EN" " added"
    fi

    "${mkv_args[@]}" >/dev/null 2>&1

    if [ -f "$CHAPTERS_XML" ]; then
      "${MKVPROPEDIT_FILE}" \
        "${FINAL_MKV}" \
        --chapters "$CHAPTERS_XML" >/dev/null 2>&1
      rm -f "$CHAPTERS_XML"
      info_check 6 "Chapters added"
    fi

    info_triple 6 "Video metadata updated"

    rm "${PROJECT_DIR}/${FILENAME}.mkv"

    # Поведение в зависимости от значения Light storage
    if [[ "$storage" == "full" ]]; then
      NEW_PROJECT_DIR="${PROJECT_DIR%_temp}"

      # Синхронизация, а не копирование с удалением на случай, если в целевой директории будет несколько видео, например, разного разрешения
      rsync -a "${PROJECT_DIR}/" "${NEW_PROJECT_DIR}/"
      rm -rf "${PROJECT_DIR}"
    else
      if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]] && [[ "$ru_trans_unsupport" == "false" ]] &&
        [[ "$RU_TRANS" == "vo+sb" || "$RU_TRANS" == "sb" ]]; then
        rm "${PROJECT_DIR}/${FILENAME}.ru.srt"
        rm "${PROJECT_DIR}/${FILENAME}.en.srt"
      fi
    fi
  fi

}

mode_single()
{
  STO=""
  RES=""
  TRN=""
  LNG=""
  mode='echo ""
      info_color 3 "MODE: One URL $STO $RES $TRN $LNG"
      echo ""
     '
  mode_id="single"

  menu_light_storage
  STO="/ Stor: ${storage}"

  menu_resolution
  RES="/ Quality: ${USER_RESOLUTION}"

  menu_trans_ai_switch
  TRN="/ ➜ Ru: ${RU_TRANS}"

  if [[ "${RU_TRANS}" != "off" ]]; then
    menu_force_lng
    LNG="/ Force lang: ${FORCE_LNG}"
  fi

  while true; do
    logo

    eval "$mode"
    info_color_bi 6 "Enter YouTube video URL:" "$CYAN"
    echo -n $'\033[6C'
    read -r "VIDEO_URL"

    # Скрыть курсор
    printf "\033[?25l"

    logo
    eval "$mode"

    YT_VIDEO_ID=$(get_youtube_id "$VIDEO_URL")
    if [[ -z "$YT_VIDEO_ID" ]]; then
      error 6 "Press Enter to repeat..."
      read -s -r
      # Показать курсор
      printf "\033[?25h"
      continue
    fi

    # Для совместимости с пакетным режимом
    mode_single_core </dev/null

    info_color 6 ""
    if [[ "$status" == "false" ]]; then
      info_color 6 "Failed" "$RED"
    else
      info_color 6 "Completed" "$GREEN"
    fi

    press_enter
    # Показать курсор
    printf "\033[?25h"
  done
}

mode_batch_common()
{
  local callback="$1"

  while true; do
    logo

    eval "$mode"

    # Показать курсор
    printf "\033[?25h"

    info_color 6 "Enter the path to the URLs list file:" "$CYAN"
    echo -n $'\033[6C'
    read -r "url_list_path_raw"

    # Скрыть курсор
    printf "\033[?25l"

    logo
    eval "$mode"

    URL_LIST_PATH=$(clean_path "$url_list_path_raw")

    if [ -z "$URL_LIST_PATH" ]; then
      error 6 "Path to the URLs list file cannot be empty"
      press_enter_repeat
      continue
    else
      _f_=$(basename "$URL_LIST_PATH")
    fi

    BASENAME_URL_LIST_PATH="${_f_%.*}"

    # Проверка существования файла
    if [[ ! -f "$URL_LIST_PATH" ]]; then
      error 6 "File not found"
      press_enter_repeat
      continue
    fi

    # Проверка на пустой файл
    if [[ ! -s "$URL_LIST_PATH" ]]; then
      error 6 "File cannot be empty"
      press_enter_repeat
      continue
    fi

    # Если рабочая директория по каким-либо причинам отсутствует
    # Создаём каталог, проверяя права доступа
    check_access_dir "${WORKDIR}" || exit 1

    datetime=$(date '+%Y_%m_%d_%H-%M-%S')

    # Создаём временный файл
    ERRORS_FILE="${WORKDIR}/${BASENAME_URL_LIST_PATH}_log_errors_${datetime}.txt"
    touch "${ERRORS_FILE}"

    # Файл содержит оставшуюся очередь на скачивание
    QUEUE_FILE="${WORKDIR}/${BASENAME_URL_LIST_PATH}_log_queue_${datetime}.txt"
    cp "${URL_LIST_PATH}" "${QUEUE_FILE}"

    # Инициализируем счетчик строк
    line_number=0
    # Инициализируем счетчик ошибок
    reject_number=0

    # Общее количество непустых строк в файле
    total_lines=$(grep -c -v '^$' "${URL_LIST_PATH}")
    # Количество разрядов в числе строк
    width=${#total_lines}

    # Читаем файл построчно
    # Условие [[ -n "$line_raw" ]] на случай, если последняя строка не заканчивается \n
    while IFS= read -r line_raw || [[ -n "$line_raw" ]]; do
      # Пропускаем полностью пустые строки, чтобы не создавать дыр
      [[ -z "$line_raw" ]] && continue

      # Удаляем символ \r (CR), если файл в формате DOS/Windows
      line=$(printf '%s' "$line_raw" | tr -d '\r')

      # Извлекаем первую HTTP/HTTPS ссылку из строки
      link=$(echo "$line" | grep -Eo 'https?://[^ ]+' | head -n1)

      if [[ -z "$link" ]]; then
        # info_uncheck 6 "URL not found in line: $line_number"
        printf '%s\n' "[ FAIL ] $line_raw" >>"$ERRORS_FILE"
        continue
      else
        # Увеличиваем счетчик для каждой строки (включая пустые)
        ((line_number++))
      fi

      # Очищаем ссылку от возможных знаков препинания в конце (.,;:))
      link=$(printf '%s' "$link" | sed 's/[.,;:)]*$//')

      formatted_line_number=$(printf "%0${width}d" "$line_number")
      if [[ "$line_number" != 1 ]]; then
        echo ""
      fi
      info_color 6 "Processing URL ${formatted_line_number}/${total_lines}" "$GRAY"
      echo ""

      YT_VIDEO_ID=$(get_youtube_id "$link")
      if [[ -z "$YT_VIDEO_ID" ]]; then
        status=false
      else
        "$callback" </dev/null
      fi

      # Проверяем итоговый статус
      if [[ "$status" == "false" ]]; then
        ((reject_number++))
        echo ""
        info_uncheck 6 "Error at one of steps ➜ rejected"
        printf '%s\n' "[ ${ERROR} ]: $line_raw" >>"$ERRORS_FILE"
        rm -rf "$PROJECT_DIR"
      fi

      # Удаляем верхнюю строку из QUEUE_FILE в любом случае, т.к. мы уже прошли этот файл
      tail -n +2 "$QUEUE_FILE" >"$QUEUE_FILE.tmp" && mv "$QUEUE_FILE.tmp" "$QUEUE_FILE"

      line_raw=""
      link=""

      if [[ $interrupt == "true" ]]; then
        while true; do
          printf "\r\033[K"
          echo ""
          info_color 6 "Press Enter to continue..." "$CYAN"
          # Скрыть курсор
          printf "\033[?25l"
          read -s -r input </dev/tty
          if [[ -z "$input" ]]; then
            printf "\033[2A" # вверх на 2 строки
            printf "\033[2K" # очистить строку 1
            printf "\033[1B" # вниз на 1
            printf "\033[2K" # очистить строку 2
            printf "\033[1A" # вернуть курсор обратно

            break
          fi
        done

        printf "\r\033[K"
      fi

    done <"$URL_LIST_PATH"

    info_color 6 ""
    info_color 6 "Batch completed" "$GREEN"
    echo ""
    info_color_bi 9 "Total: " "$GRAY" "    ${line_number}" "$CYAN" "" ""
    info_color_bi 9 "Completed: " "$GRAY" "$((line_number - reject_number))" "$GREEN" "" ""
    info_color_bi 9 "Rejected: " "$GRAY" " ${reject_number}" "$RED" "" ""

    press_enter
    # Показать курсор
    printf "\033[?25h"

  done
}

mode_batch()
{
  local interrupt="$1"
  local callback="$2"

  IRT=""
  if [ $interrupt = "true" ]; then
    IRT=" ⏯"
  fi
  STO=""
  RES=""
  TRN=""
  LNG=""
  mode='echo ""
        info_color 3 "MODE: Batch of URLs${IRT} $STO $RES $TRN $LNG"
        echo ""
     '
  mode_id="batch"

  menu_light_storage
  STO="/ Stor: ${storage}"

  menu_resolution
  RES="/ Quality: ${USER_RESOLUTION}"

  menu_trans_ai_switch
  TRN="/ ➜ Ru: ${RU_TRANS}"

  if [[ "${RU_TRANS}" != "off" ]]; then
    menu_force_lng
    LNG="/ Force lang: ${FORCE_LNG}"

    menu_pause_switch
  fi

  mode_batch_common "$callback"
}

mode_list()
{
  mode='echo ""
          info_color 3 "MODE: Creating URLs list for a channel"
          echo ""
         '
  while true; do
    logo
    eval "$mode"
    info_color_bi 6 "Enter the channel name in any format
      [" "$CYAN" "@channel, channel, https://youtube.com/@channel" "$RED" "]:" "$CYAN"
    echo -n $'\033[6C'
    read -r "YT_CHANNEL"

    # Скрыть курсор
    printf "\033[?25l"

    logo
    eval "$mode"

    # Проверка на пустое имя
    if [[ -z "${YT_CHANNEL}" ]]; then
      error 6 "Channel name cannot be empty"
      error 6 "Press Enter to repeat..."
      read -s -r
      # Показать курсор
      printf "\033[?25h"
      continue
    else
      # Запускаем прогресс в фоне и сохраняем его PID
      progress 6 "In progress" &
      progress_pid=$!

      # Обработка YT_CHANNEL
      if [[ "${YT_CHANNEL}" == *"@"* ]]; then
        # Удаляем всё до первого @ (сам @ оставляем)
        YT_CHANNEL="@${YT_CHANNEL#*@}"

        # Если после @ есть /, удаляем всё начиная с /
        YT_CHANNEL="${YT_CHANNEL%%/*}"
      else
        # Если @ нет, добавляем @ в начало
        YT_CHANNEL="@${YT_CHANNEL}"
        # И потом удаляем всё после / (если есть)
        YT_CHANNEL="${YT_CHANNEL%%/*}"
      fi

      FILE_CH_TEMP="${WORKDIR}/${YT_CHANNEL}.tmp"

      # Получение списка видео на канале
      ${YT_DLP_FILE} \
        --ffmpeg-location "${FFMPEG_FILE}" \
        --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" \
        --js-runtimes "node:$OS_DIR/node/bin/node" \
        --extractor-args "youtube:player_client=default" \
        --force-ipv4 \
        --quiet \
        --flat-playlist \
        --print "%(title)s - https://youtu.be/%(id)s" \
        "https://www.youtube.com/${YT_CHANNEL}/videos" >"${FILE_CH_TEMP}" 2> >(
        while IFS= read -r err_line; do
          echo -e "\n   ${RED}${err_line}${NORMAL}" >&2
        done
      )

      # Останавливаем прогресс
      kill $progress_pid 2>/dev/null
      wait $progress_pid 2>/dev/null

      logo
      eval "$mode"

      datetime=$(date '+%Y_%m_%d_%H-%M-%S')
      FILE_CH_FINAL="${WORKDIR}/${YT_CHANNEL}_${datetime}.txt"

      # Перемещаем только если команда успешна и файл не пуст
      if [ $? -eq 0 ] && [ -s "${FILE_CH_TEMP}" ]; then
        mv "${FILE_CH_TEMP}" "${FILE_CH_FINAL}"
      else
        rm -f "${FILE_CH_TEMP}"
        error 6 "File not created"
      fi

      if [[ -f "${WORKDIR}/"${YT_CHANNEL}_${datetime}".txt" ]]; then
        info_check 6 "The URLs list is ready:"
        info_color 10 "${WORKDIR}/"${YT_CHANNEL}_${datetime}".txt" "$GRAY"
        info_color 6 ""
        info_color 6 "Completed" "$GREEN"
      fi
    fi
    press_enter
    # Показать курсор
    printf "\033[?25h"

  done
}

check_voice_core()
{
  # Инициализируем статус
  status=true

  # Получение основных метаданных видео
  result_json=$(
    "${YT_DLP_FILE}" \
      --ffmpeg-location "${FFMPEG_FILE}" \
      --cookies-from-browser "${YT_BROWSER}:${YT_PROFILE_PATH}" \
      --js-runtimes "node:$OS_DIR/node/bin/node" \
      --extractor-args "youtube:player_client=default" \
      --force-ipv4 \
      --quiet \
      --dump-json \
      --skip-download \
      -- "$YT_VIDEO_ID"
  )

  result_meta=$(
    "${JQ_FILE}" -r '
    {
      "channel": .channel,
      "uploader": .uploader,
      "title": .title,
      "upload_date": .upload_date,
      "language": .language,
    } | to_entries | map("[\(.key)]: \(.value // "N/A")") | .[]
    ' <<<"$result_json"
  )

  raw_data=$(
    "${JQ_FILE}" -r '
    [
        (.language // "N/A"),
        (.channel // "N/A"),
        (.title // "N/A"),
        (if .upload_date then (.upload_date | "\(.[0:4])_\(.[4:6])_\(.[6:8])") else "N/A" end),
        ([.formats[]? | select(.height != null) | .height] | unique | sort | map(tostring) | join(" "))
    ] | @tsv
    ' <<<"$result_json"
  )

  # Разбиваем строку в массив
  # Используем IFS (разделитель), чтобы корректно обработать табуляцию
  IFS=$'\t' read -ra data_array <<<"$raw_data"

  LANGUAGE="${data_array[0]}"
  CHANNEL=$(get_clean_string "${data_array[1]}")
  TITLE=$(get_clean_string "${data_array[2]}")
  UPLOAD_DATE="${data_array[3]}"

  if [[ -z "$result_meta" ]]; then
    status=false
    msg="Failed to get metadata"
    error 6 "$msg"
    ERROR="$msg"
    # Защита от бесполезного выполнения, если на итерации произошла ошибка
    return 1
  else
    info_triple 6 "Title: " "${TITLE}" ""
  fi

  # 1. Заменяем опасные символы файловой системы на подчеркивания
  # 2. Удаляем эмодзи и нестандартных символов (оставляем буквы, цифры, пробелы, ., -, _, !)
  # 3. Обрезаем до 200 символов (по байтам UTF-8, сохраняя целые символы)
  # 4. Пробелы в подчеркивания
  FILENAME=$(
    echo "$TITLE" | \
      sed -E 's/[/\\:*"<>|]+/_/g' | \
      perl -CSDA -pe 's/[^\p{L}\p{N} .\-_!?]//g' | \
      perl -CSDA -pe '$_ = substr($_, 0, 200)' | \
      sed -E 's/[ ]+/_/g'
  )

  PROJECT_DIR="${WORKDIR}/${CHANNEL}_CHECK_VOICE/${UPLOAD_DATE}_${FILENAME}_CHECK_VOICE"
  # Создаём каталог, проверяя права доступа
  check_access_dir "${PROJECT_DIR}" || exit 1

  ai_ru_pause=false
  allowed_languages_ai=("en" "en-US" "en-GB" "en-CA" "en-AU" "de" "fr" "es" "it" "ja" "zh" "zh-CN" "zh-TW" "ar")

  if [[ " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]]; then
    download_voice
    subs_lang=("ru" "en")
    download_subs "https://www.youtube.com/watch?v=${YT_VIDEO_ID}" \
      "${PROJECT_DIR}" \
      "${FILENAME}" \
      "${subs_lang[@]}"
  elif [[ ! " ${allowed_languages_ai[@]} " =~ " ${LANGUAGE} " ]]; then
    info_uncheck 6 "Translation from $(echo "$LANGUAGE" | tr '[:lower:]' '[:upper:]') language into Russian is not supported"
  fi

  if [[ "$status" == "false" ]]; then
    info_color 6 "Failed" "$RED"
    rm -rf "$PROJECT_DIR"
  else
    info_color 6 "Completed" "$GREEN"
  fi
}

check_voice()
{
  local callback="$1"

  mode='echo ""
        info_color 3 "MODE: Checking Ru voice/sub"
        echo ""
     '
  mode_id="batch"

  mode_batch_common "$callback"
}

# =========================
# Проверка зависимостей
# =========================

clear
echo ""
failed=0
check_file "$YT_DLP_FILE" "YT-dlp" || failed=1
check_file "$JQ_FILE" "Jq" || failed=1
check_file "$FFMPEG_FILE" "FFmpeg" || failed=1
check_file "$FFPROBE_FILE" "FFprobe" || failed=1
check_file "$MKVPROPEDIT_FILE" "Mkvpropedit" || failed=1
check_file "$OS_DIR/node/bin/node" "Node" || failed=1
check_file "$OS_DIR/node/lib/node_modules/vot-cli-live/src/index.js" "VOT-cli-live" || failed=1

if [[ $failed -ne 0 ]]; then
  echo ""
  error 3 "Required files are missing!"
  echo ""
  info_color 3 "Press Enter to close this window..." "$CYAN"
  # Скрыть курсор
  printf "\033[?25l"
  read -r

  printf "%8s" | tr ' ' '\n'
  exit 1
fi

# =========================
# Установка разрешений на исполнение
# =========================

chmod +x "$YT_DLP_FILE"
chmod +x "$JQ_FILE"
chmod +x "$FFMPEG_FILE"
chmod +x "$FFPROBE_FILE"
chmod +x "$OS_DIR/node/bin/node"
chmod +x "$MKVPROPEDIT_FILE"

cd ${WORKDIR}

init_config || exit 1
main_menu
