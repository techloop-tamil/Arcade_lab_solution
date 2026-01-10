#!/bin/bash

# Define color variables
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'

# Define text formatting variables
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

# Welcome message
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}         INITIATING EXECUTION...  ${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}=======================================${RESET_FORMAT}"
echo




gcloud auth list

export ZONE=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-zone])")

export REGION=$(gcloud compute project-info describe --format="value(commonInstanceMetadata.items[google-compute-default-region])")

gcloud config set compute/region $REGION

export PROJECT_ID=$(gcloud config get-value project)

export PROJECT_ID=$DEVSHELL_PROJECT_ID


gcloud spanner databases execute-sql banking-db --instance=banking-instance \
 --sql="INSERT INTO Customer (CustomerId, Name, Location) VALUES ('bdaaaa97-1b4b-4e58-b4ad-84030de92235', 'Richard Nelson', 'Ada Ohio')"

cat > insert.py <<EOF_CP
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types

INSTANCE_ID = "banking-instance"
DATABASE_ID = "banking-db"

spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)

def insert_customer(transaction):
    row_ct = transaction.execute_update(
        "INSERT INTO Customer (CustomerId, Name, Location)"
        "VALUES ('b2b4002d-7813-4551-b83b-366ef95f9273', 'Shana Underwood', 'Ely Iowa')"
    )
    print("{} record(s) inserted.".format(row_ct))

database.run_in_transaction(insert_customer)

EOF_CP

python3 insert.py


sleep 60


cat > batch_insert.py <<EOF_CP
from google.cloud import spanner
from google.cloud.spanner_v1 import param_types

INSTANCE_ID = "banking-instance"
DATABASE_ID = "banking-db"

spanner_client = spanner.Client()
instance = spanner_client.instance(INSTANCE_ID)
database = instance.database(DATABASE_ID)

with database.batch() as batch:
    batch.insert(
        table="Customer",
        columns=("CustomerId", "Name", "Location"),
        values=[
        ('edfc683f-bd87-4bab-9423-01d1b2307c0d', 'John Elkins', 'Roy Utah'),
        ('1f3842ca-4529-40ff-acdd-88e8a87eb404', 'Martin Madrid', 'Ames Iowa'),
        ('3320d98e-6437-4515-9e83-137f105f7fbc', 'Theresa Henderson', 'Anna Texas'),
        ('6b2b2774-add9-4881-8702-d179af0518d8', 'Norma Carter', 'Bend Oregon'),

        ],
    )

print("Rows inserted")
EOF_CP


python3 batch_insert.py


sleep 60





gsutil mb gs://$DEVSHELL_PROJECT_ID
touch emptyfile
gsutil cp emptyfile gs://$DEVSHELL_PROJECT_ID/tmp/emptyfile


gcloud services disable dataflow.googleapis.com --force
gcloud services enable dataflow.googleapis.com


sleep 90

gcloud dataflow jobs run spanner-load --gcs-location gs://dataflow-templates-$REGION/latest/GCS_Text_to_Cloud_Spanner --region $REGION --staging-location gs://$DEVSHELL_PROJECT_ID/tmp/ --parameters instanceId=banking-instance,databaseId=banking-db,importManifest=gs://cloud-training/OCBL372/manifest.json

echo -e "\033[1;33mCheck Dataflow Job is status\033[0m \033[1;34mhttps://console.cloud.google.com/dataflow/jobs?referrer=search&project=$DEVSHELL_PROJECT_ID\033[0m"




echo 

# Function to display a random congratulatory message
function random_congrats() {
    MESSAGES=(
        "${GREEN}Congratulations For Completing The Lab! Keep up the great work!${RESET}"
        "${CYAN}Well done! Your hard work and effort have paid off!${RESET}"
        "${YELLOW}Amazing job! You’ve successfully completed the lab!${RESET}"
        "${BLUE}Outstanding! Your dedication has brought you success!${RESET}"
        "${MAGENTA}Great work! You’re one step closer to mastering this!${RESET}"
        "${RED}Fantastic effort! You’ve earned this achievement!${RESET}"
        "${CYAN}Congratulations! Your persistence has paid off brilliantly!${RESET}"
        "${GREEN}Bravo! You’ve completed the lab with flying colors!${RESET}"
        "${YELLOW}Excellent job! Your commitment is inspiring!${RESET}"
        "${BLUE}You did it! Keep striving for more successes like this!${RESET}"
        "${MAGENTA}Kudos! Your hard work has turned into a great accomplishment!${RESET}"
        "${RED}You’ve smashed it! Completing this lab shows your dedication!${RESET}"
        "${CYAN}Impressive work! You’re making great strides!${RESET}"
        "${GREEN}Well done! This is a big step towards mastering the topic!${RESET}"
        "${YELLOW}You nailed it! Every step you took led you to success!${RESET}"
        "${BLUE}Exceptional work! Keep this momentum going!${RESET}"
        "${MAGENTA}Fantastic! You’ve achieved something great today!${RESET}"
        "${RED}Incredible job! Your determination is truly inspiring!${RESET}"
        "${CYAN}Well deserved! Your effort has truly paid off!${RESET}"
        "${GREEN}You’ve got this! Every step was a success!${RESET}"
        "${YELLOW}Nice work! Your focus and effort are shining through!${RESET}"
        "${BLUE}Superb performance! You’re truly making progress!${RESET}"
        "${MAGENTA}Top-notch! Your skill and dedication are paying off!${RESET}"
        "${RED}Mission accomplished! This success is a reflection of your hard work!${RESET}"
        "${CYAN}You crushed it! Keep pushing towards your goals!${RESET}"
        "${GREEN}You did a great job! Stay motivated and keep learning!${RESET}"
        "${YELLOW}Well executed! You’ve made excellent progress today!${RESET}"
        "${BLUE}Remarkable! You’re on your way to becoming an expert!${RESET}"
        "${MAGENTA}Keep it up! Your persistence is showing impressive results!${RESET}"
        "${RED}This is just the beginning! Your hard work will take you far!${RESET}"
        "${CYAN}Terrific work! Your efforts are paying off in a big way!${RESET}"
        "${GREEN}You’ve made it! This achievement is a testament to your effort!${RESET}"
        "${YELLOW}Excellent execution! You’re well on your way to mastering the subject!${RESET}"
        "${BLUE}Wonderful job! Your hard work has definitely paid off!${RESET}"
        "${MAGENTA}You’re amazing! Keep up the awesome work!${RESET}"
        "${RED}What an achievement! Your perseverance is truly admirable!${RESET}"
        "${CYAN}Incredible effort! This is a huge milestone for you!${RESET}"
        "${GREEN}Awesome! You’ve done something incredible today!${RESET}"
        "${YELLOW}Great job! Keep up the excellent work and aim higher!${RESET}"
        "${BLUE}You’ve succeeded! Your dedication is your superpower!${RESET}"
        "${MAGENTA}Congratulations! Your hard work has brought great results!${RESET}"
        "${RED}Fantastic work! You’ve taken a huge leap forward today!${RESET}"
        "${CYAN}You’re on fire! Keep up the great work!${RESET}"
        "${GREEN}Well deserved! Your efforts have led to success!${RESET}"
        "${YELLOW}Incredible! You’ve achieved something special!${RESET}"
        "${BLUE}Outstanding performance! You’re truly excelling!${RESET}"
        "${MAGENTA}Terrific achievement! Keep building on this success!${RESET}"
        "${RED}Bravo! You’ve completed the lab with excellence!${RESET}"
        "${CYAN}Superb job! You’ve shown remarkable focus and effort!${RESET}"
        "${GREEN}Amazing work! You’re making impressive progress!${RESET}"
        "${YELLOW}You nailed it again! Your consistency is paying off!${RESET}"
        "${BLUE}Incredible dedication! Keep pushing forward!${RESET}"
        "${MAGENTA}Excellent work! Your success today is well earned!${RESET}"
        "${RED}You’ve made it! This is a well-deserved victory!${RESET}"
        "${CYAN}Wonderful job! Your passion and hard work are shining through!${RESET}"
        "${GREEN}You’ve done it! Keep up the hard work and success will follow!${RESET}"
        "${YELLOW}Great execution! You’re truly mastering this!${RESET}"
        "${BLUE}Impressive! This is just the beginning of your journey!${RESET}"
        "${MAGENTA}You’ve achieved something great today! Keep it up!${RESET}"
        "${RED}You’ve made remarkable progress! This is just the start!${RESET}"
    )

    RANDOM_INDEX=$((RANDOM % ${#MESSAGES[@]}))
    echo -e "${BOLD}${MESSAGES[$RANDOM_INDEX]}"
}

# Display a random congratulatory message
random_congrats
echo
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}              LAB COMPLETED SUCCESSFULLY!!              ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}              SUBSCRIBE TO TECHLOOP TAMIL!!            ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo ""
echo -e "${RED_TEXT}${BOLD_TEXT}Subscribe my Channel (Techloop Tamil):${RESET_FORMAT} ${BLUE_TEXT}${BOLD_TEXT}https://www.youtube.com/@Techloop_Tamil${RESET_FORMAT}"
echo -e "\n" 
