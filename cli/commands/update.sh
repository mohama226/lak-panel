به جای diff از rsync --dry-run استفاده کنیم.

یعنی این قسمت:

#############################################
# Compare Files
#############################################

تا قبل از:

#############################################
# Update Files
#############################################

را حذف کن و این را بگذار:

#############################################
# Compare Files
#############################################

echo

echo "Changed files:"
echo "--------------------------------"


RSYNC_OUTPUT=$(rsync -avnc \
--exclude=".git" \
--exclude=".installed" \
--exclude=".last_update" \
--exclude=".admin_user" \
--exclude=".panel_port" \
"$NEW_DIR/" \
"$INSTALL_DIR/")


FILES=$(echo "$RSYNC_OUTPUT" | \
grep -v "^sending" | \
grep -v "^sent" | \
grep -v "^total")


COUNT=$(echo "$FILES" | grep -c "/" || true)



if [[ "$COUNT" -eq 0 ]]; then

    echo "No changes detected."

else

    echo "Total changed files: $COUNT"

    echo

    echo "$FILES"

fi

و بخش Update را هم اینطوری تغییر بده:

#############################################
# Update Files
#############################################


echo

echo "[+] Updating files..."



rsync -av \
--exclude=".git" \
--exclude=".installed" \
--exclude=".last_update" \
--exclude=".admin_user" \
--exclude=".panel_port" \
"$NEW_DIR/" \
"$INSTALL_DIR/"
