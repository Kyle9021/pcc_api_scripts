#!/bin/bash

# Tested with Prisma Cloud Compute 20.12 on 4.26.2021
# Written by Kyle Butler Prisma Cloud Channel Systems Engineer
# Choose bash scripting for the benefits of portability
# Requires jq to be installed.
# Assign the variables below or export them with a different script and call it in this script. 

prisma_user=<USERNAME>
prisma_user_password=<PASSWORD>
pcc_url=<IP_ADDRESS/HOSTNAME:PORT>


# don't change anything below this line. 

# creates an array of host names and assigns it to a variable host_name_api_call
host_name_api_call=$(curl -k \
  -u ${prisma_user}:${prisma_user_password}\
  -H 'Content-Type: application/json' \
  -X GET \
  https://"${pcc_url}"/api/v1/hosts| jq '.[] | {"host": .hostname}' | jq -r '.host')

# creates an array of container profile twistcli ID's and assigns it to a variable container_profile_api_call
container_profile_api_call=$(curl -k\
 -u ${prisma_user}:${prisma_user_password}\
 -H 'Content-Type: application/json' \
 -X GET \
https://"${pcc_url}"/api/v1/profiles/container)

# a loop within a loop. This does all the heavy lifting. The first loop loops through all the available profile Id's
# the inner loop runs the curl command over the array testing all known hosts to the prisma cloud compute console. 

for row in $(echo "${container_profile_api_call}" | jq '.[] | {ID: ._id, Image_Name: .image}' | jq -r '.ID'); do
 for host in ${host_name_api_call}
 do
 echo "${host}" >> logfile 
  curl -k \
   -u ${prisma_user}:${prisma_user_password} \
   -H 'Content-Type: application/json' \
   -X GET \
   "https://"${pcc_url}"/api/v1/profiles/container/{"${row}"}/forensic?hostname={"${host}"}"\
 | jq '.[] | {"type": .type, "time": .timestamp, "containerId": .containerId}'\
 | grep Container -A 2 >> logfile
 done
done

grep -B 1 -A 2 'Container' logfile >> report.txt

rm logfile
