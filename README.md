# README

## Assumptions

* You're using the SELF-HOSTED version of Prisma Cloud Compute
* You're using ubuntu 20.04
* You're able to reach your PCC console from your ubuntu 20.04 machine
* You understand <IP_ADDRESS/HOSTNAME:PORT> should look something like: `192.39.1.3:38290` or `pcc-demo-deploy.io:40349`
* You would know how to harden this process if working in a production environment. 

* * If you do decide to keep the keys/username/password in this script, then it's critical you:
  
   * Add it to your `.gitignore` file and `chmod 700 container_start_report.bash` between steps 2 and 3 below so that others can't read, write, or excute it. 

# Instructions

## Instructions
* Step 1: `git clone https://github.com/Kyle9021/pcc_api_scripts`
* Step 2: `cd pcc_api_scripts/`
* Step 3: `nano container_start_report.bash` and replace `<USERNAME>`, `<PASSWORD>`, `<IP_ADDRESS/HOSTNAME:PORT>` with the appropriate values from your pcc console. 
* Step 4: Install jq if you dont have it `sudo apt update && upgrade -y` then `sudo apt install jq`
* Step 5: `bash container_start_report.bash`

The report will be in a text file called report.text. This is a very simple low-level script that should be used for demo/poc purposes. Written in Bash for portability. The report will list the `hostname` of the machine the container was found on, then the type of message `container started`, with the `timestamp` and the `containerId`

NOTE: It may take a while to run depending on how many containers and hosts are associated with the PCC console. 

* Step 6: Once script runs `cat report.txt`

Please be sure to check out the offical [PAN development site](https://prisma.pan.dev/) for Prisma Cloud 
