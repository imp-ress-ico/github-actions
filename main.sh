# !/bin/bash

PR_URL="$PR_URL"
token="$GITHUB_TOKEN"
BASE_URI="https://api.github.com"
owner="$REPO_OWNER"
repo="$REPO_NAME"
pull_number="$PR_NUMBER"

#time
aday=86400 #24 hrs
four_days=345600
nine_days=777600
ten_days=864000

#date and time of PR
latest_commit_date=$(curl -X GET -u devops-ibs:$token $BASE_URI/repos/$owner/$repo/pulls/$pull_number/commits | jq -r '.[-1].commit.committer.date')
stale_date=$(curl -X GET -u devops-ibs:$token $BASE_URI/repos/$owner/$repo/pulls/$pull_number | jq -r '.updated_at')

live_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
convert_live_date=$(date -u -d "$live_date" +%s)
convert_latest_commit_date=$(date -u -d "$latest_commit_date" +%s)
convert_stale_date=$(date -u -d "$stale_date" +%s)
DIFFERENCE=$((convert_live_date - convert_latest_commit_date))
label_diff=$((convert_live_date - convert_stale_date))

echo "latest commit date: $latest_commit_date"
echo "stale label date: $stale_date"
echo "live date: $live_date"
echo "convert live date: $convert_live_date"
echo "convert latest commit date: $convert_latest_commit_date"
echo "convert stale label date: $convert_stale_date"  
echo "difference time: $DIFFERENCE"
echo "label difference time: $label_diff"


if [ $DIFFERENCE -lt $nine_days ]
then
   echo "This PR is active. Don't close PR"
   gh pr edit $PR_URL --remove-label "Stale"
elif [ $DIFFERENCE -le $ten_days ]
then
   echo "This PR is stale because it has been open 10 days with no activity."
   gh pr edit $PR_URL --add-label "Stale" 
   gh pr comment $PR_URL --body "This issue is stale because it has been open 10 days with no activity. Remove stale label or comment or this will be closed in 4 days."
elif [ $label_diff -gt $four_days ]
then
   echo "This PR was closed because it has been stalled for 4 days with no activity."
   gh pr close $PR_URL
   gh pr edit $PR_URL --remove-label "Stale"
   gh pr comment $PR_URL --body "This PR was closed because it has been stalled for 4 days with no activity."
 
else
   echo "None of the condition met"
fi