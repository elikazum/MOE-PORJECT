#!/bin/bash

LOG_FILE="/var/log/syslog"

# בדיקה אם קובץ הלוג קיים
if [[ ! -f "$LOG_FILE" ]]; then
    echo "שגיאה: קובץ הלוג '$LOG_FILE' לא נמצא."
    exit 1
fi

# קבלת פרמטרים מהמשתמש
read -p "הזן תאריך לחיפוש (לדוגמה: Jun 7) או השאר ריק לדילוג: " DATE_FILTER
read -p "הזן סוג שגיאה (ERROR/WARNING/FAILED) או השאר ריק לדילוג: " TYPE_FILTER

# בניית פקודת grep לפי הקלט
SEARCH_CMD="grep -iE 'error|warning|failed' \"$LOG_FILE\""

if [[ -n "$DATE_FILTER" ]]; then
    SEARCH_CMD="$SEARCH_CMD | grep \"$DATE_FILTER\""
fi

if [[ -n "$TYPE_FILTER" ]]; then
    SEARCH_CMD="$SEARCH_CMD | grep -i \"$TYPE_FILTER\""
fi

echo "-------------------------------------"
echo "תוצאות חיפוש בלוג לפי תאריך/סוג שגיאה:"
echo "-------------------------------------"

eval "$SEARCH_CMD"

echo "-------------------------------------"
echo "סיים חיפוש."
