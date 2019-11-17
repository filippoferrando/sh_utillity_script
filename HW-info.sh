#!/bin/bash
# Shell script to collect HW information
 
if ! type "dmidecode" > /dev/null 2>&1; then
	echo "dmidecode non è installato!"
	exit 0
fi
 
if ! type "lspci" > /dev/null 2>&1; then
	echo "lspci non è installato!"
	exit 0
fi
 
if ! type "lshw" > /dev/null 2>&1; then
	echo "lshw non è installato!"
	exit 0
fi
 
if ! (type "smartctl" > /dev/null 2>&1;) && ! (type "hdparm" > /dev/null 2>&1;) then
	echo "Né smartctl né hdparm sono installati!"
	exit 0
fi
 
dateStart=$(date +"%s")
 
fn="hwinfo.csv"
 
echo "Lettura dati S.O., PC name e kernel version..."
 
uname -s | sed 's/^/Operating system;/' > $fn
uname -n | sed 's/^/PC name;/' >> $fn
uname -r | sed 's/^/Kernel version;/' >> $fn
 
echo "Lettura dati distribuzione Linux..."
cat /etc/*-release |grep DISTRIB_DESCRIPTION | sed 's/DISTRIB_DESCRIPTION=/Linux distro;/g' >> $fn
 
echo "Lettura dati BIOS..."
dmidecode -s bios-vendor | sed 's/^/BIOS vendor;/' >> $fn
dmidecode -s bios-version | sed 's/^/BIOS version;/'  >> $fn
dmidecode -s bios-release-date | sed 's/^/BIOS release date;/' >> $fn
dmidecode -s system-manufacturer | sed 's/^/System manufacturer;/' >> $fn
dmidecode -s system-product-name | sed 's/^/System product name;/' >> $fn
dmidecode -s system-serial-number | sed 's/^/System serial number;/' >> $fn
dmidecode -s system-uuid | sed 's/^/System UUID;/' >> $fn
dmidecode -s baseboard-manufacturer | sed 's/^/Motherboard manufacturer;/' >> $fn
dmidecode -s baseboard-product-name | sed 's/^/Motherboard product name;/' >> $fn
dmidecode -s baseboard-version | sed 's/^/Motherboard version;/' >> $fn
dmidecode -s baseboard-serial-number | sed 's/^/Motherboard serial number;/' >> $fn
dmidecode -s chassis-manufacturer | sed 's/^/Chassis manufacturer;/' >> $fn
dmidecode -s chassis-type | sed 's/^/Chassis type;/' >> $fn
dmidecode -s chassis-serial-number | sed 's/^/Chassis serial number;/' >> $fn
dmidecode -s processor-manufacturer | sed 's/^/Processor manufacturer;/' >> $fn
dmidecode -s processor-version | sed 's/^/Processor version;/' >> $fn
dmidecode -s processor-frequency | sed 's/^/Processor frequency;/' >> $fn
 
# lspci -mmv 
echo "Lettura dati periferiche PCI..."
pre=""
res=""
lspci -mmv |
while read line
do
	if [[ "$line" == *"Class"* ]] || [[ "$line" == "Vendor"* ]] || [[ "$line" == "Device"* ]]; then
		if [[ "$line" == *"Class"* ]]; then
			pre=$( echo $line | sed 's/Class:[ ^t]*//g' )
		else
			line=$( echo $line | sed 's/:/;/g' |  sed 's/#/n\./g' )
			res=$pre" "$line
			if [[ ! "$res" == "Ethernet"* ]] && [[ ! "$res" == "Network"* ]]; then
				echo $res >> $fn
			fi
		fi
	fi
done
echo "Lettura dati periferiche Networking e Memoria RAM (potrebbe essere lento)..."
#lshw -class network -class memory
pre=""
res=""
lshw -class network -class memory | 
while read line
do
	if [[ "$line" == *"description:"* ]] || [[ "$line" == "product:"* ]] || [[ "$line" == "vendor:"* ]] \
		|| [[ "$line" == "logical name:"* ]] || [[ "$line" == "serial:"* ]]  || [[ "$line" == "size:"* ]] \
		|| [[ "$line" == "slot:"* ]] ; then
		if [[ "$line" == *"description"* ]]; then
			pre=$( echo $line | sed 's/description:[ ^t]*//g' )
		else
			line=$( echo $line | sed 's/: /;/g' )			
			res=$pre" "$line
			echo $res >> $fn
		fi
	fi
done
 
mpMainHd=$(df -Hl | grep ^\/dev.*\/$ | cut -c 1-8)
 
echo "Individuato: "$mpMainHd" come punto di montaggio dell'HDD principale..."
 
if (type "smartctl" > /dev/null 2>&1;) then
	echo "Lettura dati Hard-disk e S.M.A.R.T. con smartmontools..."	
	smartctl -i $mpMainHd | 
	while read line
	do
		if [[ "$line" == "Model Family"* ]] || [[ "$line" == "Device Model"* ]]	|| [[ "$line" == "Serial Number"* ]] \
			|| [[ "$line" == *"Firmware"* ]] || [[ "$line" == *"Capacity"* ]]; then
			line=$( echo $line | sed 's/: /;/g' )
			echo "HDD "$line >> $fn
		fi
	done
 
	smartctl -A $mpMainHd | sed -n '/RAW_VALUE/,/^$/p' | sed 1d |
	while IFS=" " read -r -a line; 
	do
		nb=${#line[@]}
		if [[ "$nb" > 0 ]]; then
			pre=$( echo ${line[$((nb - 9))]} | sed 's/_/ /g' )			
			echo "HDD SMART "$pre";"${line[$((nb - 1))]} >> $fn
		fi
	done
else
	echo "Lettura dati Hard-disk con hdparm..."
	hdparm -I $mpMainHd | sed -n '/ATA device/,/Commands\/features:/p' | 
	while read line 
	do
		if [[ "$line" == *"Model Number:"* ]]; then
			echo $line | sed 's/: /;/g' | sed 's/^/HDD /' >> $fn
		fi
		if [[ "$line" == *"Serial Number:"* ]]; then
			echo $line | sed 's/: /;/g' | sed 's/^/HDD /' >> $fn
		fi
		if [[ "$line" == *"Firmware Revision:"* ]]; then
			echo $line | sed 's/: /;/g' | sed 's/^/HDD /' >> $fn
		fi
		if [[ "$line" == *"Transport:"* ]]; then
			echo $line | sed 's/: /;/g' | sed 's/^/HDD /' >> $fn
		fi
		if [[ "$line" == *"device size with M = 1000*1000:"* ]]; then
			echo $line | sed 's/device size with M = 1000\*1000: /Size;/g' | sed 's/^/HDD /' >> $fn
		fi
		if [[ "$line" == *"Nominal Media Rotation Rate:"* ]]; then
			echo $line | sed 's/: /;/g' | sed 's/^/HDD /' >> $fn
		fi
	done
fi
 
date | sed 's/^/Scan date;/' >> $fn
dateStop=$(date +"%s")
diff=$(($dateStop-$dateStart))
echo "Elapsed time; $(($diff / 60)) minutes and $(($diff % 60)) seconds." >> $fn
 
echo "il file: "$fn" è stato generato!"
 
exit 0
