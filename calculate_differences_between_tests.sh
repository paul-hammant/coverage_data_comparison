mkdir coverage_diff_data

for test1 in `find coverage_data -name "*#*" | sed 's#coverage_data/##' | sed 's/\.txt//'`; do
    for test2 in `find coverage_data -name "*#*" | sed 's#coverage_data/##' | sed 's/\.txt//'`; do
        if [[ "$test1" != "$test2" ]]; then
            if [[ "$test1" > "$test2" ]]; then
                one=$test2
                two=$test1
            else
                one=$test1
                two=$test2
            fi
            output="coverage_diff_data/${one}-${two}.diff"
            if [[ ! -e "$output" ]];then
                diff "coverage_data/${one}.txt" "coverage_data/${two}.txt" >> "${output}"
                deleted=$(grep -c "^<" "${output}")
                added=$(grep -c "^>" "${output}")
                if [[ "$added" == "0" || "$deleted" == "0" ]]; then
                    echo "$one and $two are very very close"
                else
                    rm "${output}"
                fi
            fi
        fi
    done
done

