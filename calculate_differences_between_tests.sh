#!/usr/local/bin/bash

mkdir coverage_diff_data

for test1 in `find coverage_data -name "*#*" | sed 's#coverage_data/##' | sed 's/\.txt//'`; do
    for test2 in `find coverage_data -name "*#*" | sed 's#coverage_data/##' | sed 's/\.txt//'`; do
        if [[ "$test1" < "$test2" ]]; then
            output="coverage_diff_data/${test1}-${test2}.diff"
            diff "coverage_data/${test1}.txt" "coverage_data/${test2}.txt" >> "${output}"
            deleted=$(grep -c "^<" "${output}")
            added=$(grep -c "^>" "${output}")
            matching=$(fgrep -xcf "coverage_data/${test1}.txt" "coverage_data/${test2}.txt")
            if [[ "$matching" != "0" ]]; then
                if [[ ( "$added" == "0" && "$deleted" == "0" ) ]]; then
                    echo "$test1 and $test2 are covering exactly the same lines"
                elif [[ ( "$added" == "0" && "$deleted" != "0" ) ]]; then
                    echo "$test2 covers the same lines as $test1 (and more)"
                elif [[ ( "$added" != "0" && "$deleted" == "0" ) ]]; then
                    echo "$test1 covers the same lines as $test2 (and more)"
                else
                    rm "${output}"
                fi
            else
                rm "${output}"
            fi
        fi
    done
done

