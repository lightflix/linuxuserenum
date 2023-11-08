#!/bin/bash
hostname=$(hostname)
ip_address=$(hostname -I | cut -d ' ' -f 1) 
timestamp=$(date +"%Y%m%d_%H%M%S") 
output_file="userlist_$hostname"_"$ip_address.csv" 
echo "Hostname: $hostname" >> "$output_file"
echo "IP: $ip_address" >> "$output_file"
echo "System Information: $(uname -a)" >> "$output_file"
echo "Timestamp: $timestamp" >> "$output_file"
echo >> "$output_file"
echo "Username,Home Directory,Shell Access,User Type" >> "$output_file"
while IFS=: read -r username _ uid gid _ home shell
do
    if [ -d "$home" ]; then
        home_exists="Yes"
    else
        home_exists="No"
    fi

    if [ -n "$shell" ] && [ "$shell" != "/sbin/nologin" ] && [ "$shell" != "/usr/sbin/nologin" ] && [ "$shell" != "/bin/false" ]; then
        shell_access="Yes"
    else
        shell_access="No"
    fi

    if [ $uid -lt 1000 ]; then
        user_type="System User"
    else
        user_type="Regular User"
    fi
    echo "$username,$home_exists,$shell_access,$user_type" >> "$output_file"
done < /etc/passwd
echo >> "$output_file"
cat /etc/passwd >> "$output_file"
new_output_file="${output_file%.*}_$(md5sum "$output_file" | cut -c 1-10).csv" 
mv "$output_file" "$new_output_file"
echo "Script executed successfully. File '$new_output_file' has been saved in the current directory."
