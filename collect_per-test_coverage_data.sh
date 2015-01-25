#!/bin/sh

rm -rf coverage_data
mkdir coverage_data

# list of unit tests methods (note: possibility of inaccuracy)

ack -A1 --nogroup "@Test" src/test/ | grep public | sed 's/\.java/ /' | sed 's#/#.#g' | sed 's/().*//' | sed 's/public void//'   | perl -pne 's/[ \t]+/#/g' | sed 's/src.test.java.//' | cut -d'#' -f 1,3 > coverage_data/list_of_test_methods.txt

mvn clean

# Process tests one at a time
for testMethod in `cat coverage_data/list_of_test_methods.txt`; do

	# One maven invocation per test (so we can get focused coverage)

    rm -rf target/coverage-reports

    mvn -Dtest=$testMethod -DfailIfNoTests=false test

    op_file_name="coverage_data/${testMethod}.txt"

	ack --noheading "id=\"L" --noignore-dir=target target | egrep -i "class=\"(pc|fc)" | sed 's/\.java.html:/-/' | sed 's#site/jacoco-ut/##' | sed 's#/#.#g' | sed 's/id=.*//' | sed 's/<span class=//' | sed 's/\"//g' | sed 's/ bpc//' | sed 's/ bfc//'> $op_file_name

    [ -s $op_file_name ] || rm $op_file_name

done

