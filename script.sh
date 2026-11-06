for dir in Testcase*/; do
    dir=${dir%/}                      
    case "$dir" in
        Testcase*Diff) continue ;;    
    esac

    outdir="${dir}Diff"
    rm -rf "$outdir"                  

    for f1 in "$dir"/*.1.txt; do
        [ -f "$f1" ] || continue     
        f2="${f1%.1.txt}.2.txt"
        [ -f "$f2" ] || continue      

        name=$(basename "$f1" .1.txt)
        name=${name// /}             
        mkdir -p "$outdir"
        diff -u "$f1" "$f2" > "$outdir/${name}Diff.txt"

       
        if [ $? -eq 0 ]; then
            rm -f "$outdir/${name}Diff.txt"
        fi
    done

    
    rmdir "$outdir" 2>/dev/null
done

