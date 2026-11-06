status=0

for n in 1 2 3 4; do
    dir="Testcase$n"
    outdir="Testcase${n}Diff"
    ok=1
    any_diff=0

    if [ ! -d "$dir" ]; then
        echo "missing directory $dir" >&2
        ok=0
    else
        for f1 in "$dir"/*.1.txt; do
            [ -f "$f1" ] || continue
            f2="${f1%.1.txt}.2.txt"
            [ -f "$f2" ] || continue

            name=$(basename "$f1" .1.txt)
            name=${name// /}              
            outfile="$outdir/${name}Diff.txt"

            if cmp -s "$f1" "$f2"; then
                
                if [ -e "$outfile" ]; then
                    echo "unexpected $outfile" >&2
                    ok=0
                fi
            else
               
                any_diff=1
                if [ ! -f "$outfile" ]; then
                    echo "missing $outfile" >&2
                    ok=0
                elif ! cmp -s <(diff -u "$f1" "$f2" | tail -n +3) <(tail -n +3 "$outfile"); then
                    echo "wrong contents in $outfile" >&2
                    ok=0
                fi
            fi
        done

       
        if [ "$any_diff" -eq 1 ] && [ ! -d "$outdir" ]; then
            echo "missing directory $outdir" >&2
            ok=0
        elif [ "$any_diff" -eq 0 ] && [ -d "$outdir" ]; then
            echo "unexpected directory $outdir" >&2
            ok=0
        fi
    fi

    if [ "$ok" -eq 1 ]; then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        status=1
    fi
done

exit $status
