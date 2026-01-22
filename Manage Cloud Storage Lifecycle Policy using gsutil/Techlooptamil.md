## ☁️ [Cloud IAM: Qwik Start](https://www.skills.google/games/6987/labs/43425)

### 🔗 **Solution Video:** [Watch Here](https://youtu.be/bq7wRFhqrEg?si=LcGDG_33bEche9ua)

---

## 💀 **Disclaimer:**
This script and guide are provided for educational purposes to help you understand the lab process. Before using the script, I encourage you to open and review it to understand each step. Please make sure you follow Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.


## 🌐 **Quick Start Guide:**

**Launch Cloud Shell:**
Start your Google CloudShell session by [clicking here](https://console.cloud.google.com/home/dashboard?project=&pli=1&cloudshell=true).


```bash
# I Know you will Steal it
PROJECT_ID=$(gcloud config get-value project)

cat <<EOF > lifecycle.json
{
  "rule": [
    {
      "action": {
        "type": "SetStorageClass",
        "storageClass": "NEARLINE"
      },
      "condition": {
        "daysSinceNoncurrentTime": 30,
        "matchesPrefix": ["projects/active/"]
      }
    },
    {
      "action": {
        "type": "SetStorageClass",
        "storageClass": "NEARLINE"
      },
      "condition": {
        "daysSinceNoncurrentTime": 90,
        "matchesPrefix": ["archive/"]
      }
    },
    {
      "action": {
        "type": "SetStorageClass",
        "storageClass": "COLDLINE"
      },
      "condition": {
        "daysSinceNoncurrentTime": 180,
        "matchesPrefix": ["archive/"]
      }
    },
    {
      "action": {
        "type": "Delete"
      },
      "condition": {
        "age": 7,
        "matchesPrefix": ["processing/temp_logs/"]
      }
    }
  ]
}
EOF


gsutil lifecycle set lifecycle.json gs://$PROJECT_ID-bucket
```
- This command downloads the setup script from GitHub. The script will help configure the environment and perform necessary setup steps.


---

---

## 🎉 **Lab Completed!**

You've successfully completed the lab! Great job on working through the process.

### 🌟 **Stay Connected!**

- 🗣 **Participate in the [Discussion Group](https://chat.whatsapp.com/H6EAk2nwAn3HOvEY82JGky)** to engage with other learners.
- 🐦 **Follow us on [Youtube](https://www.youtube.com/@Techloop_Tamil)** for the latest updates.


---
---

**Keep up the great work and continue your learning journey!**

#[Techloop Tamil](https://www.youtube.com/@Techloop_Tamil) - Don't Forget to Subscribe!
