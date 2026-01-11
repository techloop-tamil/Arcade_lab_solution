

## ☁️ Configure Cloud Buckets with gsutil for Load Balancing & Fault Tolerance | [GSP073](https://www.cloudskillsboost.google/games/6058/labs/38571)

### 🔗 **Solution Video:** [Watch Here](https://youtu.be/bq7wRFhqrEg?si=LcGDG_33bEche9ua)

---

## 💀 **Disclaimer:**
This script and guide are provided for educational purposes to help you understand the lab process. Before using the script, I encourage you to open and review it to understand each step. Please make sure you follow Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.


## Step1:
```bash
PROJECT=$(gcloud config get-value project)
BUCKET=qwiklabs-gcp-03-061714b645d0-bucket



```
## Step2:
```

gsutil setmeta -h "Content-Type:text/html" gs://${BUCKET}/index.html
gsutil setmeta -h "Content-Type:text/css" gs://${BUCKET}/style.css
gsutil setmeta -h "Content-Type:image/jpeg" gs://${BUCKET}/logo.jpg

```
## Step3:
```


gsutil web set -m index.html -e 404.html gs://${BUCKET}
```
## Step4:
```
gsutil iam ch allUsers:objectViewer gs://${BUCKET}
```

- This command downloads the setup script from GitHub. The script will help configure the environment and perform necessary setup steps.


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
