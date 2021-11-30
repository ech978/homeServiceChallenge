#!/bin/bash
Maddr="192.168.1.23"
addr="192.168.1.10"
user="nvidia"
pwd="nvidia"
tmp=

# Run nptdate
echo "Run ntp date"

echo
echo "--------------------"

# Run ssh keygen
echo "Run ssh keygen"
~/tb3_ssh_keygen $addr
echo "--------------------"

# Edit remote ~/.bashrc
echo "Edit remote ~/.bashrc"
sed -i "/ROS_MASTER_URI/c\export ROS_MASTER_URI=http:\/\/${Maddr}:11311" ~/.bashrc
sed -i "/ROS_HOSTNAME/c\export ROS_HOSTNAME=${Maddr}" ~/.bashrc
. ~/.bashrc
echo "--------------------"

# Edit host ~/.bashrc && Run sh Host's Checklist (ttyACM0)
echo "Run checklist from hostPC"
# sshpass -p $pwd ssh $user@$addr \
# -o StrictHostKeyChecking=no \
# 'sed -i "/ROS_MASTER_URI/c\export ROS_MASTER_URI=http:\/\/$Maddr:11311" ~/.bashrc'

# sshpass -p $pwd ssh $user@$addr \
# -o StrictHostKeyChecking=no \
# 'sed -i "/ROS_HOSTNAME/c\export ROS_HOSTNAME=$addr" ~/.bashrc'

# sshpass -p $pwd ssh $user@$addr \
# -o StrictHostKeyChecking=no \
# '. ~/.bashrc'

sshpass -p $pwd ssh $user@$addr \
-o StrictHostKeyChecking=no \
'sh ~/catkin_ws/src/checklist.sh'
echo "--------------------"



# # Run HSC demo remote
# echo "Run HSC demo remote"
# roslaunch turtlebot3_home_service_challenge_tools turtlebot3_home_service_challenge_demo_remote.launch address:=$addr&
# read -p "Press any key: " tmp
# echo "--------------------"

# # Run HSC manager
# echo "Run HSC manager"
# roslaunch turtlebot3_home_service_challenge_manager manager.launch&
# read -p "Press any key: " tmp
# echo "--------------------"

echo "Please run below code"
echo roslaunch turtlebot3_home_service_challenge_tools turtlebot3_home_service_challenge_demo_remote.launch address:=$addr
echo roslaunch turtlebot3_home_service_challenge_manager manager.launch
echo
echo ssh $user@$addr
echo sudo ntpdate ntp.ubuntu.com
echo "--------------------"


# restart 구현예정
while true; do
    read -p "Please Select [ready/start/stop/restart/quit]: " response
    case $response in
        "ready" )
            rostopic pub -1 /tb3_hsc/command std_msgs/String ready_mission
            ;;
        "start" )
            rostopic pub -1 /tb3_hsc/command std_msgs/String start_mission
            ;;
        "stop" )
            rostopic pub -1 /tb3_hsc/command std_msgs/String stop_mission
            ;;
        "restart" )
            rostopic pub -1 /tb3_hsc/command std_msgs/String ready_mission
            rostopic pub -1 /tb3_hsc/command std_msgs/String nav_start
            ;;

        "quit" )
           # roslaunch1=$(ps aux | grep demo_remote | awk '{ print $2 }' | head -1 )
           # kill -9 $roslaunch1

           # roslaunch2=$(ps aux | grep challenge_manager | awk '{ print $2 }' | head -1 )
           # kill -9 $roslaunch2
           exit 0
           ;;
        * )
            echo "Please Input correct string"
            ;;
    esac
done
