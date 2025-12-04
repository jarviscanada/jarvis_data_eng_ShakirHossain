psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

#check # of args
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

hostname=$(hostname -f)

cpu_number=$(lscpu | awk -F: '/^CPU\(s\)/ {print $2}' | xargs)
cpu_architecture=$(lscpu | awk -F: '/^Architecture/ {print $2}' | xargs)
cpu_model=$(lscpu | awk -F: '/^Model name/ {print $2}' | xargs)
cpu_mhz=$(lscpu | awk -F: '/^CPU MHz/ {print $2}' | xargs)
l2_cache=$(lscpu | awk -F: '/^L2 cache/ {print $2}' | xargs)
timestamp=$(vmstat -t | awk 'NR==3 {print $(NF-1), $NF}'| tail -n1 | xargs )
total_mem=$(awk '/MemTotal/ {printf "%.0f\n", $2/1024}' /proc/meminfo)

#Subquery to find matching id in host_info table
host_id="SELECT id FROM host_info WHERE hostname='$hostname'";
#PSQL command: Inserts server usage data into host_usage table
#Note: be careful with double and single quotes

insert_stmt="INSERT INTO host_info(id,hostname,cpu_number,cpu_architecture,cpu_model, cpu_mhz, l2_cache, timestamp, total_mem)
VALUES ('$host_id','$hostname','$cpu_number','$cpu_architecture','$cpu_model','$cpu_mhz','$l2_cache','$timestamp','$total_mem')"

#set up env var for pql cmd
export PGPASSWORD=$psql_password
#Insert date into a database
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"
exit $?