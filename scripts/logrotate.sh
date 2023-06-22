#!/bin/bash

# Verzeichnis, das die Logrotate-Konfigurationsdateien enthält
logrotate_dir="/etc/logrotate.d"

# Optionen, die entfernt werden sollen
options_to_remove=("monthly" "weekly" "daily" "rotate" "compress" "delaycompress" "dateext")

# Optionen, die hinzugefügt werden sollen
options_to_add=("daily" "rotate 28" "compress" "dateext")


help() {
    echo ""
    echo ""
    echo ""
    echo "Hilfe für das Script:"
    echo "---------------------"
    echo "--help     : Zeigt diese Hilfe an."
    echo "--test     : Zeigt welche Dateien wie aussehen würden nach einem Deployment."
    echo "--deploy   : Führt die Änderungen ohne weitere Nachfrage aus."
    echo ""
    echo ""
    echo ""
}

test_deploy() {
# Funktion zum Schreiben von Zeilen
write_line() {
  local line="$1"
    echo "$line"
}


# Schleife über die Logrotate-Konfigurationsdateien im Verzeichnis
for conf_file in "$logrotate_dir"/*
do
  # Überprüfen, ob es sich um eine reguläre Datei handelt
  if [[ -f "$conf_file" ]]; then
    echo "Verarbeite Datei: $conf_file"

    # Variable, um zu verfolgen, ob der Block bereits geöffnet wurde
    block_opened=false

    # Variable, um die Anzahl der Blocköffnungen zu zählen
    block_count=0

    # Schleife über die Logrotate-Konfigurationsdatei
    while IFS= read -r line
    do

      # Überprüfen, ob die Zeile mit einem Block beginnt
      if [[ $line == *{* ]]; then
        block_count=$((block_count+1))

        # Schreib die öffnende Klammer
        write_line "$line"

        # Neue Optionen nach der öffnenden Klammer einfügen
        if [[ $block_opened == false ]]; then
          for option in "${options_to_add[@]}"
          do
            write_line "        $option"
          done
          block_opened=true
        fi
      elif [[ $line == *}* ]]; then
        block_count=$((block_count-1))

        # Schreib die schließende Klammer
        write_line "$line"

        if [[ $block_count -eq 0 ]]; then
          block_opened=false
        fi
      else
        # Zeilen innerhalb des Blocks schreiben
        if [[ $block_opened == true ]]; then
          # Überprüfen, ob die Optionen entfernt werden sollen
          should_remove_option=true
          for option in "${options_to_remove[@]}"
          do
            if [[ $line == *$option* ]]; then
              should_remove_option=false
              break
            fi
          done

          # Nur Zeilen schreiben, wenn die Optionen nicht entfernt werden sollen
          if [[ $should_remove_option == true ]]; then

                line=$(echo "$line" | awk '{gsub(/        /, "\t"); print}')
                line=$(echo "$line" | awk '{gsub(/    /, "\t"); print}')
                match=$(echo "$line" | grep -oE '^\s*')
                count=${#match}
                doubled_indent=""
                for ((i = 0; i < count; i++)); do
                  doubled_indent+="     "
                done
                line=$(echo "$line" | sed  's/^\s*//')

                if [[ $line == *"missingok"* ]]; then
                        write_line "$doubled_indent$line" | sed 's/^\t\tmissingok/\tmissingok/'

                elif [[ $line == *"notifempty"* ]]; then
                        write_line "$doubled_indent$line" | sed 's/^\t\tnotifempty/\tnotifempty/'
                else
                        write_line "$doubled_indent$line"
                fi

          fi
        else
          # Zeilen außerhalb von Blöcken direkt schreiben
          write_line "$line"
        fi
      fi
    done < "$conf_file"

    echo "-------------------"
  fi
done
}

deploy() {
# Funktion zum Schreiben von Zeilen
write_line() {
  local line="$1"
  echo "$line"
}

# Schleife über die Logrotate-Konfigurationsdateien im Verzeichnis
for conf_file in "$logrotate_dir"/*
do
  # Überprüfen, ob es sich um eine reguläre Datei handelt
  if [[ -f "$conf_file" ]]; then
    echo "Verarbeite Datei: $conf_file"

    # Erzeuge den temporären Dateinamen
    tmp_file=$(mktemp)

    # Variable, um zu verfolgen, ob der Block bereits geöffnet wurde
    block_opened=false

    # Variable, um die Anzahl der Blocköffnungen zu zählen
    block_count=0

    # Schleife über die Logrotate-Konfigurationsdatei
    while IFS= read -r line
    do

      # Überprüfen, ob die Zeile mit einem Block beginnt
      if [[ $line == *{* ]]; then
        block_count=$((block_count+1))

        # Schreib die öffnende Klammer
        write_line "$line" >> "$tmp_file"

        # Neue Optionen nach der öffnenden Klammer einfügen
        if [[ $block_opened == false ]]; then
          for option in "${options_to_add[@]}"
          do
            write_line "        $option" >> "$tmp_file"
          done
          block_opened=true
        fi
      elif [[ $line == *}* ]]; then
        block_count=$((block_count-1))

        # Schreib die schließende Klammer
        write_line "$line" >> "$tmp_file"

        if [[ $block_count -eq 0 ]]; then
          block_opened=false
        fi
      else
        # Zeilen innerhalb des Blocks schreiben
        if [[ $block_opened == true ]]; then
          # Überprüfen, ob die Optionen entfernt werden sollen
          should_remove_option=true
          for option in "${options_to_remove[@]}"
          do
            if [[ $line == *$option* ]]; then
              should_remove_option=false
              break
            fi
          done

          # Nur Zeilen schreiben, wenn die Optionen nicht entfernt werden sollen
          if [[ $should_remove_option == true ]]; then

            line=$(echo "$line" | awk '{gsub(/        /, "\t"); print}')
            line=$(echo "$line" | awk '{gsub(/    /, "\t"); print}')
            match=$(echo "$line" | grep -oE '^\s*')
            count=${#match}
            doubled_indent=""
            for ((i = 0; i < count; i++)); do
              doubled_indent+=" "
            done
            line=$(echo "$line" | sed  's/^\s*//')

            if [[ $line == *"missingok"* ]]; then
              write_line "$doubled_indent$line" | sed 's/^\t\tmissingok/\tmissingok/' >> "$tmp_file"

            elif [[ $line == *"notifempty"* ]]; then
              write_line "$doubled_indent$line" | sed 's/^\t\tnotifempty/\tnotifempty/' >> "$tmp_file"
            else
              write_line "$doubled_indent$line" >> "$tmp_file"
            fi

          fi
        else
          # Zeilen außerhalb von Blöcken direkt schreiben
          write_line "$line" >> "$tmp_file"
        fi
      fi
    done < "$conf_file"

    # Konfigurationsdatei mit tmp_file austauschen
    mv "$tmp_file" "$conf_file"

    echo "-------------------"
  fi
done
}



if [[ "$1" == "--help" ]]; then
help
elif [[ "$1" == "--test" ]]; then
test_deploy
elif [[ "$1" == "--deploy" ]]; then
deploy
else
echo -e "\e[31mERROR:\e[0m Du hast weder --help, --test noch --deploy als Option übergeben"
echo ""
help
fi