#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# Check number of arguments
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# Save machine statistics in MB and hostname
vmstat_mb=$(vmstat --unit M)
host=$(hostname -f |xargs)
echo "$host"
hostname="jrvs-remote-desktop-centos7-6.us-central1-a.c.spry-framework-236416.internal"
# Hardware stats
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(df -BM / | awk '{gsub("M","",$4);print $4}' | tail -n1 | xargs)

# Current timestamp
timestamp=$(vmstat -t | awk 'NR==3 {print $(NF-1), $NF}' | xargs)

# Get host ID from host_info
host_id=$(psql -h "$psql_host" -p "$psql_port" -U "$psql_user" -d "$db_name" -t -c "SELECT id FROM host_info WHERE hostname='$hostname';" | xargs)

# Insert statement
insert_stmt="INSERT INTO host_usage(timestamp, host_id, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES ('$timestamp',$host_id,$memory_free,$cpu_idle,$cpu_kernel,$disk_io,$disk_available);"

# Set password environment variable
export PGPASSWORD=$psql_password

# Execute insert
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

exit $?