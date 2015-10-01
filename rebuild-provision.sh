#!/usr/bin/env bash

PROVISION_PATH=`pwd`/.provision/;
PROVISION_FIRST_LINE='config.vm.provision "shell", inline: <<-SHELL'
PROVISION_LAST_LINE=' SHELL'
VAGRANT_FILE=/vagrant/Vagrantfile
VAGRANT_FILE_TMP=/vagrant/Vagrantfile.tmp

chmod 744 $PROVISION_PATH*.sh

cp $VAGRANT_FILE $VAGRANT_FILE_TMP
SED_STRING='/'$PROVISION_FIRST_LINE'/,/'$PROVISION_LAST_LINE'/d'
SED_STRING="${SED_STRING//\./\\.}"
sed -i "$SED_STRING" $VAGRANT_FILE_TMP
sed -i '/^end$/d' $VAGRANT_FILE_TMP

LINE=$(grep "$PROVISION_FIRST_LINE" $VAGRANT_FILE)
if [ "$LINE" = "" ]
	then
		LINE="  # "$PROVISION_FIRST_LINE
fi
echo "$LINE" >> $VAGRANT_FILE_TMP

LINE=$(grep "apt-get update" $VAGRANT_FILE)
if [ "$LINE" = "" ]
	then
		LINE="    # apt-get update"
fi
echo "$LINE" >> $VAGRANT_FILE_TMP

echo "    cd `pwd`/.provision/" >> $VAGRANT_FILE_TMP

for file in $PROVISION_PATH*.sh
do
	FILE_NAME=`basename $file`
	LINE=$(grep "$FILE_NAME" $VAGRANT_FILE)
	if [ "$LINE" = "" ]
		then
			LINE="    # "$FILE_NAME
	fi
	echo "$LINE" >> $VAGRANT_FILE_TMP
done

LINE=$(grep "$PROVISION_LAST_LINE" $VAGRANT_FILE)
if [ "$LINE" = "" ]
	then
		LINE="  # "$PROVISION_LAST_LINE
fi
echo "$LINE" >> $VAGRANT_FILE_TMP

echo "end" >> $VAGRANT_FILE_TMP

rm $VAGRANT_FILE
mv $VAGRANT_FILE_TMP $VAGRANT_FILE