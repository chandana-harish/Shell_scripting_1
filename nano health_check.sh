explanation:
1.#!/bin/bash-script using the Bash shell.

2.REPORT="server_health_report_$(date +%F_%H-%M-%S).txt"

3.REPORT= → Variable assignment.

$(date +%F_%H-%M-%S) → Command substitution.
%F → YYYY-MM-DD
%H-%M-%S → Hour-Minute-Second
Prevents overwriting old reports.]

4.CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
Breaking it down:
top -bn1
-b → Batch mode (non-interactive)
-n1 → Run once
grep "Cpu(s)"
Filters the CPU statistics line.
awk '{print $8}'
Extracts the 8th column, usually idle CPU %.

5.free -m-memory usage selection

6.df -h --total
df → Disk filesystem
-h → Human readable (GB, MB)
--total → Adds total line

7.ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu
Explanation:
ps → Process status
-e → All processes
-o → Custom output format
id → Process ID
ppid → Parent Process ID
cmd → Command
%mem → Memory usage
%cpu → CPU usage
--sort=-%cpu → Descending CPU order

8.head -n 15
Limits output for readability.






#!/bin/bash
# Server Health Check Script
# Report file
REPORT="server_health_report_$(date +%F_%H-%M-%S).txt"
echo "==========================================" > $REPORT
echo "        SERVER HEALTH CHECK REPORT        " >> $REPORT
echo "==========================================" >> $REPORT
echo "Generated on: $(date)" >> $REPORT
echo "" >> $REPORT

# CPU Usage
echo "---- CPU USAGE ----" >> $REPORT
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "CPU Usage: $CPU_USAGE%" >> $REPORT
echo "" >> $REPORT

# Memory Usage
echo "---- MEMORY USAGE ----" >> $REPORT
free -m | awk 'NR==2{
    printf "Total Memory: %s MB\nUsed Memory: %s MB\nFree Memory: %s MB\nUsage: %.2f%%\n",
    $2, $3, $4, $3*100/$2 }' >> $REPORT
echo "" >> $REPORT

# Disk Usage
echo "---- DISK USAGE ----" >> $REPORT
df -h --total | grep 'total' | awk '{
    printf "Total Disk: %s\nUsed Disk: %s\nFree Disk: %s\nUsage: %s\n",
    $2, $3, $4, $5 }' >> $REPORT
echo "" >> $REPORT

# Top 5 Processes by CPU Usage
echo "---- TOP 5 PROCESSES (CPU) ----" >> $REPORT
ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%cpu | head -n 6 >> $REPORT
echo "" >> $REPORT

# Active Network Connections
echo "---- ACTIVE NETWORK CONNECTIONS ----" >> $REPORT
ss -tunap | head -n 15 >> $REPORT
echo "" >> $REPORT
echo "         END OF REPORT                    " >> $REPORT
echo "Report generated: $REPORT"




