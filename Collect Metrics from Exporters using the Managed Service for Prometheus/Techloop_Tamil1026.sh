#!/bin/bash
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

echo
clear

echo
echo "${CYAN_TEXT}${BOLD_TEXT}===================================${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}🚀     INITIATING EXECUTION     🚀${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}===================================${RESET_FORMAT}"
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}🧐 Detecting your default GCP zone...${RESET_FORMAT}"
export ZONE=$(gcloud compute project-info describe \
--format="value(commonInstanceMetadata.items[google-compute-default-zone])" 2>/dev/null)

if [ -z "$ZONE" ]; then
    echo "${YELLOW_TEXT}Hmm, couldn't automatically detect the default zone.${RESET_FORMAT}"
    echo "${GREEN_TEXT}${BOLD_TEXT}✍️ Please enter your ZONE:${RESET_FORMAT}"
    read -p "${GREEN_TEXT}Zone: ${RESET_FORMAT}" ZONE
fi

echo "${BLUE_TEXT}${BOLD_TEXT}📍 Using GCP Zone: $ZONE${RESET_FORMAT}"
echo

echo "${CYAN_TEXT}${BOLD_TEXT}🛠️  Next up: Creating a GKE cluster named 'gmp-cluster'.${RESET_FORMAT}"
gcloud beta container clusters create gmp-cluster --num-nodes=1 --zone $ZONE --enable-managed-prometheus
echo

echo "${BLUE_TEXT}${BOLD_TEXT}🔑  Fetching Kubernetes credentials for 'gmp-cluster'.${RESET_FORMAT}"
gcloud container clusters get-credentials gmp-cluster --zone=$ZONE
echo

echo "${GREEN_TEXT}${BOLD_TEXT}🏷️  Creating a new Kubernetes namespace: 'gmp-test'.${RESET_FORMAT}"
kubectl create ns gmp-test
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}🚀 Deploying an example application to the 'gmp-test' namespace.${RESET_FORMAT}"
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/example-app.yaml
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}📈 Setting up PodMonitoring for our example app.${RESET_FORMAT}"
kubectl -n gmp-test apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/prometheus-engine/v0.2.3/examples/pod-monitoring.yaml
echo

echo "${CYAN_TEXT}${BOLD_TEXT}📥 Cloning the GoogleCloudPlatform Prometheus repository and moving into it.${RESET_FORMAT}"
git clone https://github.com/GoogleCloudPlatform/prometheus && cd prometheus
echo

echo "${BLUE_TEXT}${BOLD_TEXT}🔄 Switching to a specific version (v2.28.1-gmp.4) of the Prometheus code.${RESET_FORMAT}"
git checkout v2.28.1-gmp.4
echo

echo "${GREEN_TEXT}${BOLD_TEXT}🔽 Downloading a Prometheus binary.${RESET_FORMAT}"
wget https://storage.googleapis.com/kochasoft/gsp1026/prometheus
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}🆔 Fetching your GCP Project ID.${RESET_FORMAT}"
export PROJECT_ID=$(gcloud config get-value project)
echo

echo "${RED_TEXT}${BOLD_TEXT}🔥 Starting the Prometheus server!${RESET_FORMAT}"
./prometheus \
  --config.file=documentation/examples/prometheus.yml --export.label.project-id=$PROJECT_ID --export.label.location=$ZONE 
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}📦 Downloading the Prometheus Node Exporter.${RESET_FORMAT}"
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
echo

echo "${CYAN_TEXT}${BOLD_TEXT}🗜️ Extracting the Node Exporter archive.${RESET_FORMAT}"
tar xvfz node_exporter-1.3.1.linux-amd64.tar.gz
echo

echo "${BLUE_TEXT}${BOLD_TEXT}📁 Navigating into the Node Exporter directory.${RESET_FORMAT}"
cd node_exporter-1.3.1.linux-amd64
echo

echo "${GREEN_TEXT}${BOLD_TEXT}📝 Creating a 'config.yaml' for the Node Exporter.${RESET_FORMAT}"
cat > config.yaml <<EOF_END
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: node
    static_configs:
      - targets: ['localhost:9100']

EOF_END
echo

echo "${MAGENTA_TEXT}${BOLD_TEXT}🆔 Confirming your GCP Project ID for storage operations.${RESET_FORMAT}"
export PROJECT=$(gcloud config get-value project)
echo

echo "${YELLOW_TEXT}${BOLD_TEXT}🪣 Creating a Google Cloud Storage bucket named after your Project ID.${RESET_FORMAT}"
gsutil mb -p $PROJECT gs://$PROJECT
echo

echo "${CYAN_TEXT}${BOLD_TEXT}📤 Uploading the 'config.yaml' to your new GCS bucket.${RESET_FORMAT}"
gsutil cp config.yaml gs://$PROJECT
echo

echo "${RED_TEXT}${BOLD_TEXT}🌐 Making objects in the GCS bucket publicly readable.${RESET_FORMAT}"
gsutil -m acl set -R -a public-read gs://$PROJECT
echo

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
