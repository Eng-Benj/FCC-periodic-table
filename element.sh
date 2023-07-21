#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE atomic_number = $1")
  elif [[ ${#1} -le 2 ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE symbol = '$1'")
  elif [[ ${#1} -gt 2 ]]
  then
    ELEMENT_INFO=$($PSQL "SELECT atomic_number, symbol, name, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements FULL JOIN properties USING (atomic_number) FULL JOIN types USING (type_id) WHERE name = '$1'")
  fi
  if [[ -z $ELEMENT_INFO ]]
  then
    echo "I could not find that element in the database."
  else
  echo "$ELEMENT_INFO" | while IFS="|" read ATOMIC_NUMBER SYMBOL NAME TYPE ATOMIC_MASS MELTING_POINT_CELSIUS BOILING_POINT_CELSIUS
  do
  echo "The element with atomic number $(echo "$ATOMIC_NUMBER" | sed 's/ //g') is $(echo "$NAME" | sed 's/ //g') ($(echo "$SYMBOL" | sed 's/ //g')). It's a $(echo "$TYPE" | sed 's/ //g'), with a mass of $(echo "$ATOMIC_MASS" | sed 's/ //g') amu. $(echo "$NAME" | sed 's/ //g') has a melting point of $(echo "$MELTING_POINT_CELSIUS" | sed 's/ //g') celsius and a boiling point of $(echo "$BOILING_POINT_CELSIUS" | sed 's/ //g') celsius."
  done
  fi
fi