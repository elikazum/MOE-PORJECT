#!/bin/bash

LOG_FILE="/var/log/syslog"
OUT_TXT="log-summary.txt"
OUT_CSV="log-summary.csv"

# בדיקת קיום קובץ לוג
if [[ ! -f "$LOG_FILE" ]]; then
    echo "שגיאה: קובץ הלוג '$LOG_FILE' לא נמצא."
    exit 1
fi

# חישוב כמות שגיאות
ERRORS=$(grep -i 'error' "$LOG_FILE" | wc -l)
WARNINGS=$(grep -i 'warning' "$LOG_FILE" | wc -l)
FAILED=$(grep -i 'failed' "$LOG_FILE" | wc -l)

# יצירת דוח טקסט
{
echo "----- דוח שגיאות כללי -----"
echo "סה\"כ ERROR:   $ERRORS"
echo "סה\"כ WARNING: $WARNINGS"
echo "סה\"כ FAILED:  $FAILED"
echo ""
echo "----- תאריכים נפוצים -----"
grep -iE 'error|warning|failed' "$LOG_FILE" | awk '{print $1, $2}' | sort | uniq -c | sort -nr | head -10
} > "$OUT_TXT"

# יצירת קובץ CSV
{
echo "ErrorType,Count"
echo "ERROR,$ERRORS"
echo "WARNING,$WARNINGS"
echo "FAILED,$FAILED"
} > "$OUT_CSV"

echo "✅ דוח נוצר בהצלחה:"
echo "- $OUT_TXT"
echo "- $OUT_CSV"
