#!/bin/bash
red=`echo -en "\e[31m"`
normal=`echo -en "\e[0m"`
green=`echo -en "\e[32m"`
RED=`echo -en "\e[41m"`
blue=`echo -en "\e[34m"`
orange=`echo -en "\e[33m"`
#1st
function start() {
echo ${green}
echo "Enter your preference"
echo "1. Encrypt"
echo "2. Decrypt"
echo "3. Exit"
read input
echo ${normal}

if [[ $input == "1" ]]; then
	enc

elif [[ $input == "2" ]]; then
	decrypt
elif [[ $input == "3" ]]; then
	echo " "
echo "${RED}-exiting the program--"
       echo -n ${normal}

       exit
else
	echo ""
	echo "${red}*****wrong input*****${normal}"
	echo " "
	start
fi

}

#2nd'
function mes() {
		echo "Do you want to add or continue (a/c)"
	        read res
		if [[ $res == "a" ]]; then
		echo "what do you want to add?.."
		read mess
		echo $mess>> $filename
		echo "This is your new mesage"
		echo ${orange}
		cat $filename
		echo ${green}
		mes
		elif [[ $res == "c" ]]; then
			echo " "
			echo "This is your final message."
			echo ""
			echo ${orange}
			cat $filename
			echo ${green}
			echo " "
			echo ${blue}
			echo "starting encryption process"
			echo ${green}
			
			encryption
			
		else
			echo " "
			echo "${RED}****wrong input***${normal}"
			echo ${green}
			mes
		
		fi
		


	}


    #3rd
    function file() {
	echo "*********************"
	echo "Select a file to encrypt"
	echo ${orange}
	nl -s "." .file>.file1
	cat .file1
	echo ${green}
	read number
	re='^[0-9]+$'
	if [[ $number =~ $re ]]; then
		cat .file1|tail -n 1 | cut -d"." -f1 >.num
		a=$(cat .num)
		if [[ $number -le $a ]]; then
		head -n $number .file | tail -n 1 > .file1
		filename=$(cat .file1)
		echo "Starting to encrypt your file ${blue}'$filename' ${green}"
		echo "with your message"
		echo " "
		echo ${orange}
		cat $filename
		echo " "
		echo ${green}
		encryption
	        else
		echo "${RED}enter valid input ${normal}"
		file
	fi
else
	echo "${red}====>wrong input ${normal}"
	echo ${green}
	file
	fi
	}

    #4th
    function enc() {
	cd /home/anish/script/file
	echo ${green}
	echo "Do you want to creat a file or encrypt exicting file"
	echo "1. To creat a file"
	echo "2. To use a exicting file"
	read input
	if [[ $input == "1" ]]; then
		echo "enter the file name"
		read filename
		a=$(ls $filename 2>&1)
		if [[ $filename == $a ]]; then
			echo "${red}file already exit.${green}"
			echo "This is your message"${orange}
			echo " "
			cat $filename
			echo "${green}"
			
			encryption
		else
		touch $filename
		echo "your file  ${blue} $filename ${green} is at"
	       	pwd
		echo "enter a message you want to encrypt"
		read message 
		echo $message > $filename
		echo "this is your message"
		echo ${orange}
		cat $filename
		echo ${green}
		
	mes
	fi
	
    elif [[ $input == "2" ]]; then
	echo " "
	echo "these are your file"
	echo ${orange}
	ls >.file
	cat .file	
	echo ${green}

	
	file



else
	echo "${RED}**** Wrong input **** ${normal}"
	echo ${green}
	enc
fi	
}

#5th
function sten() {
	
	echo "these are the types of encryption you could use"
	sleep 2 
	echo "-----------------------------------------------"
	echo ${orange}
	openssl enc -list
	echo ${green}
	echo "Enter the type you want to use :"
	read method
	echo "You chossed${blue} $method${green} to encrypt."
       	echo " "
       	echo ${red}
	echo "Please input your password:"
	read pass
	echo ${green}
	encry=$(openssl enc $method -in $filename -out /home/anish/script/encryption/$filename.$method -k $pass 2>&1)
	if [[ $encry == *"enc"* ]]; then
	echo "${RED}=====> wrong input.${normal}"
	echo ${green}
	echo ""
	sleep 3
	sten

	else
	echo "your encryption file is ${orange} '$filename.$method' ${green}in ${orange} /home/anish/script/encryption/$filename.$method ${green}"
	echo ""
	echo "And your encrypted message is ${orange}"
	cat /home/anish/script/encryption/$filename.$method
	echo "${green}"
	cd ..
	
	echo ""
	sleep 2
	echo "*********************************************************"
	start

	fi
}

#6
function key() {
echo "======> Starting to create keys."
echo " "
cd /home/anish/script/keys
echo ${green}
echo "Enter a name for private key"
echo ${orange}
read name
echo ${green}
echo "Enter a name for public key"
	echo ${orange}
	read name2
	echo ${green}

	echo ""
	echo "starting to create a $name.Key and $name2.key"

	a=$(openssl genrsa -out $name.Key 2>&1)	
	function pub() {
	echo "${blue}"
	encry=$(openssl rsa -in $name.Key -pubout -out $name2.key 2>&1)
	if [[ $encry == *"unable"* ]]; then
	echo 
	echo "${RED}=====> wrong input${normal}"
	echo ${green}
	echo ""
	sleep 1
	pub
	else	
		echo ""
		echo "${orange}Successfull created both key${green}"
		ls $name.Key $name2.key
		v=$(pwd)
		echo "in $v"

		echo ${orange}
		sleep 1
		Asymmetric
		echo ${green}
	fi

	}	
	pub



}


#7
function choice(){
	echo ${green}
	echo "Encrypting the file with public key!!"
	echo " "
	echo "Which key you Want to Use"
	cd /home/anish/script/keys
	ls  *.key >.keyli
	nl -s "." .keyli>.keyy
	cat .keyy
	read number
	re='^[0-9]+$'
	  if [[ $number =~ $re ]]; then
		cat .keyy|tail -n 1 | cut -d"." -f1 >.num
		a=$(cat .num)
		if [[ $number -le $a ]]; then
		head -n $number .keyli | tail -n 1 > .file1
		keyname=$(cat .file1)
		echo $keyname
		openssl rsautl --encrypt -inkey $keyname -pubin -in /home/anish/script/file/$filename -out /home/anish/script/encryption/$filename.publicenc
		echo "${blue}Encryption successfull${green}"
		echo "your encrypted file is ${blue}'$filename.publicenc'${green} in ${blue}/home/anish/script/encryption/$filename.publicenc${green}"
		echo ""
	echo "And your encrypted message is ${orange}"
	cat /home/anish/script/encryption/$filename.publicenc
	echo "${green}"
		start
	        else
	        echo ""
		echo "${RED}==========>Invalid input${normal}"
		echo " "
		echo ${green}
		choice
		fi
	else
		echo ""
		echo "${RED}==========>Invalid input${normal}"
		echo " "
		choice
	fi
	

}

#8
function keys(){
	echo "Do you want to create a key or use the existing ones"
	echo ${blue}
	echo "1. To create a new key"
	echo "2. Use a existing key"
	read key
	echo ${green}
	if [[ $key == "1" ]]; then
		echo ""
		key
	elif [[ $key == "2" ]]; then
	keycheck=$(ls /home/anish/script/keys)
	if [[ $keycheck == *'.key'* ]]; then
		echo ""
		Asymmetric
		echo ""
	else
		echo ''
		echo "${red}You don't have keys So, First creat one${green}"
		key
	fi
	else
	echo " "
	echo "${RED}======> Wrong input${normal}"
	echo " ${green}"
	keys	
	fi
}

#9
function Asymmetric(){
	echo " "
	echo " Starting Asymmetric encryption in ${blue}'/home/anish/script/file/$filename'${green} with message:"
	echo " "
	echo ${orange}
	cat /home/anish/script/file/$filename
	echo ${green}
	echo " "
	
choice

	


 }
 #10
 function encryption() {

echo "Select a encryption method."
echo "1.Symmetric key encryption"
echo "2.Asymmetric key encryption"
read typee
if [[ $typee == "1" ]]; then
	
sten

elif [[ $typee == "2" ]]; then
	echo ""

keys
else 
	echo " "
	echo "${RED}======> Wrong input.${normal}"
	echo ${green}
	echo " "
	encryption
fi


}

#11
function readd(){
	echo "Do you want to read the file.(y/n)"
	read inp
	if [[ $inp == "y" ]]; then
	echo ""
	 echo ${orange}
	 cat /home/anish/script/decryption/$name 
	 echo ${green}
	 echo ""
	 echo "********"
	 sleep 2
	 start
	elif [[ $inp == "n" ]]; then
	start
	else 
	echo ""
	echo "${RED}========> Wrong input."${normal}
	echo ${green}
	readd
	
	fi
	}

#12

function data() {
	echo ${green}
	echo "Enter  symmetric key algorithm to decrypt the data"
	echo ${red}
	read key
	echo ${green}
	echo " "
	echo "Enter the password"
	echo ${red}
	read pass
	echo ${green}
	decry=$(openssl enc $key -in $filename -out /home/anish/script/decryption/$name -k $pass -d 2>&1)
	if [[ $decry == *"enc"* ]]; then
	echo ""
	echo "${red}========> Wrong input"${normal}
	echo ${green}
	echo ""
	data

	else
	echo "your decrypt file ${blue}'$name'${green} is saved in ${blue}/home/anish/script/decryption/$name${green}"
	
	readd
	echo ""
	sleep 2
	echo "*********************************************************"
        
	

	fi
}

#13

function don() {
		echo "Enter your output file name"
		echo ${red}
		read name
		echo ${green}
		decr=$(openssl rsautl --decrypt -inkey $keyname -in  /home/anish/script/encryption/$filename -out /home/anish/script/decryption/$name 2>&1)
	          if [[ $decr == *"RSA"* ]]; then
	echo "${RED}=====> wrong input You may have selected wrong key or file.${normal}"
	echo ""
	echo ${green}
	sleep 2
	choi

	      	else
	echo "${orange}Yours file is decrypted.${green}" 
		  fi
		  readd
	  }

#14
function readdd(){
	echo "Do you want to read the file.(y/n)"
	read inp
	if [[ $inp == "y" ]]; then
	echo ""
	 echo ${orange}
	 cat /home/anish/script/decryption/$name 
	 echo ${green}
	 echo ""
	 echo "********"
	 sleep 2
	 start
	elif [[ $inp == "n" ]]; then
	start
	else 
	echo " "
	echo "${RED}========> Wrong input${normal}"
	echo ${green}
	readdd
	fi
	}

#15
function choi() {
	
		echo "Which Private key you want to use?"
		ls *.Key>.key
		nl -s "." .key>.file1
		cat .file1
		read number
		re='^[0-9]+$'
		if [[ $number =~ $re ]]; then
		cat .file1|tail -n 1 | cut -d"." -f1 >.num
		a=$(cat .num)
		 if [[ $number -le $a ]]; then
		  head -n $number .key | tail -n 1 > .file1
		  keyname=$(cat .file1)
		 echo "Starting to decript using ${blue}'$keyname'${green}"
		 don
		 else
	echo ""
	
	echo "${RED}========> Wrong input. ${normal}"
	
	echo ${green}
	echo " "
	choi
		
  don
	
	readdd
	fi

	        
    else
	echo ""
	
	echo "${RED}========> Wrong input. ${normal}"
	
	echo ${green}
	echo " "
	choi
	fi

	
	}

#16
function met(){
	echo "Decrypting file using Private key"
	choi
    }

#17

function stdec() {
echo ${green}
echo "How would you like to decrypt."
echo ${blue}
echo "1.Symmetric key decryption"
echo "2.Asymmetric key decryption"
read typee
echo ${green}
if [[ $typee == "1" ]]; then
	echo "your encrypted file name is ${blue}'$filename'${green}"
	cd /home/anish/script/encryption
	echo ""
	echo "Enter your output file name"
	echo ${red}
	read name
	echo ${green}
	echo " "
	
data

elif [[ $typee == "2" ]]; then
	echo "**Starting Asymmetric key decription**"
	echo ""
	echo "${red}Make sure you have selected right file${green}"
	sleep 2
	cd ../keys
	echo " "
	echo "Your file name is $filename"
	
met


else
	echo ""
	
	echo "${RED}========> Wrong input."${normal}
	echo ${green}
	echo " "
	stdec
fi

}

#18
function files() {
cat .filelist
read number
echo ${green}
	re='^[0-9]+$'
	if [[ $number =~ $re ]]; then
		cat .filelist|tail -n 1 | cut -d"." -f1 >.num
		a=$(cat .num)
		if [[ $number -le $a ]]; then
		head -n $number .list | tail -n 1 > .file1
		filename=$(cat .file1)
		echo "Starting to decrypt your file ${blue}'$filename'${green}"
		echo " "
		stdec
	        else
		echo " "
		echo "${RED}========> Wrong input"${normal}
		echo ${green}
		files
			
		fi
	else 
		echo " "
		echo "${RED}========> Wrong input"${normal}
		echo ${green}
		files
	fi
}

#19
function decrypt() {
echo ${green}
echo "***Starting Decryption***"
echo " "
echo "select file to decrypt"
echo ''${orange}
cd /home/anish/script/encryption
ls >.list
#ls /home/anish/script/encryption>/home/anish/script/.list
nl -s '.' .list >.filelist

files
}

start
