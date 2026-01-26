

## ☁️ Cloud Data Loss Prevention API: Qwik Start | [GSP107](https://www.cloudskillsboost.google/focuses/600?parent=catalog)

### 🔗 **Solution Video:** [Watch Here](https://youtu.be/1d8mfbEPhYI)

---

## 💀 **Disclaimer:**
This script and guide are provided for educational purposes to help you understand the lab process. Before using the script, I encourage you to open and review it to understand each step. Please make sure you follow Qwiklabs' terms of service and YouTube’s community guidelines. The goal is to enhance your learning experience, not to bypass it.


## 🌐 **Quick Start Guide:**

**Launch Cloud Shell:**
Start your Google CloudShell session by [clicking here](https://console.cloud.google.com/home/dashboard?project=&pli=1&cloudshell=true).

```bash
export REGION=
```

```bash
gcloud beta alloydb clusters create lab-cluster \
    --password=Change3Me \
    --network=peering-network \
    --region=$REGION \
    --project=$DEVSHELL_PROJECT_ID

gcloud beta alloydb instances create lab-instance \
    --instance-type=PRIMARY \
    --cpu-count=2 \
    --region=$REGION  \
    --cluster=lab-cluster \
    --project=$DEVSHELL_PROJECT_ID
```
---

 **Launch Another Cloud Shell +**  

```bash
export REGION=
```

```bash
gcloud beta alloydb clusters create gcloud-lab-cluster \
    --password=Change3Me \
    --network=peering-network \
    --region=$REGION \
    --project=$DEVSHELL_PROJECT_ID

gcloud beta alloydb instances create gcloud-lab-instance\
    --instance-type=PRIMARY \
    --cpu-count=2 \
    --region=$REGION  \
    --cluster=gcloud-lab-cluster \
    --project=$DEVSHELL_PROJECT_ID
```

----

### 🔗 [``VM Instance``](https://console.cloud.google.com/compute/instances?referrer=search&project=)

### 🔗 [``AlloyDB``](https://console.cloud.google.com/alloydb/clusters?referrer=search&project=)



Set the following environment variable, replacing ALLOYDB_ADDRESS with the Private IP address of the AlloyDB instance.
```bash
export ALLOYDB=
```
Run the following command to store the Private IP address of the AlloyDB instance on the AlloyDB client VM so that it will persist throughout the lab.
```bash
echo $ALLOYDB  > alloydbip.txt 
```
Use the following command to launch the PostgreSQL (psql) client. You will be prompted to provide the postgres user's password (``Change3Me``) which you entered when you created the cluster.
```bash
psql -h $ALLOYDB -U postgres
```

Input and run the following SQL commands separately to enable the extension.
```bash
\c postgres
```
```bash
CREATE TABLE regions (
    region_id bigint NOT NULL,
    region_name varchar(25)
) ;

ALTER TABLE regions ADD PRIMARY KEY (region_id);
```
```bash
INSERT INTO regions VALUES ( 1, 'Europe' );

INSERT INTO regions VALUES ( 2, 'Americas' );

INSERT INTO regions VALUES ( 3, 'Asia' );

INSERT INTO regions VALUES ( 4, 'Middle East and Africa' );
```

Run the following system query to see details on the pgaudit extension.
```bash
SELECT region_id, region_name from regions;
```

---

## 🎉 **Lab Completed!**

You've successfully completed the lab! Great job on working through the process.

### 🌟 **Stay Connected!**

- 🗣 **Participate in the [Discussion Group](https://chat.whatsapp.com/LHufF35bAJEC2vqmlmfC8J)** to engage with other learners.
- 🐦 **Follow us on [Youtube](https://www.youtube.com/@Techloop_Tamil)** for the latest updates.


---
---

**Keep up the great work and continue your learning journey!**

# [Techloop Tamil](https://www.youtube.com/@Techloop_Tamil) - Don't Forget to Subscribe!
