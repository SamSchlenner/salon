#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {  
  echo $1
  echo -e "\nWhat service do you want to book?\n---"
  SERVICES=$($PSQL "select * from services")
  echo "$SERVICES" | while read SERVICE_NAME BAR SERVICE_ID
  do
    echo "$SERVICE_ID) $SERVICE_NAME"
  done

}



echo -e "\n~~~~ Welcome to Sam's Salon ~~~~\n"
MAIN_MENU
read SERVICE_ID_SELECTED
SERVICE_ID_SELECTED_QUERY=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE_ID_SELECTED_QUERY ]]
then
  MAIN_MENU "Please select a valid service."
else
  echo -e "\nPlease enter a phone number."
  read CUSTOMER_PHONE
  CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_NAME ]]
  then
    echo -e "\nPlease enter a name."
    read CUSTOMER_NAME
    CUSTOMER_INSERT=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    echo "Customer added."
  fi
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  SERVICE_NAME_SELECTED=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  echo -e "\nPlease enter a time."
  read SERVICE_TIME
  BOOKING_MESSAGE=$($PSQL "insert into appointments(customer_id,service_id,time) values($CUSTOMER_ID,$SERVICE_ID_SELECTED,'$SERVICE_TIME')")
  echo "I have put you down for a $SERVICE_NAME_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
fi



