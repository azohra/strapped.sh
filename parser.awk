function max(a, b) {
    if (a < b) {
        b
    } else {
        a
    }
}

function report(error) {
    print "Yaml Error:", error > "/dev/stderr"
    if (force_complete) {
        linter_status=1
    } else {
        exit 1
    }
}

function push(v) {
    stk[stk_i++] = v
}

function pop(lvls) {
    if (lvls > 0) {
        stk_i = max(stk_i - lvls, 0)
    }
}

function join_stack() {
    val = ""
    for (k = stk_i - 1; k >= 0; k--) {
        val = stk[k] "." val
    }
    return val
}

function safe_split(input, output) {
    split(input, chars, "")
    in_quote = 1
    acc = ""
    count = 0
    for (i=0; i < length(input); i++) {
        c=chars[i]
        if (c=="\"") {
            in_quote = (in_quote + 1) % 2
        }
        if (c=="," && in_quote) {
            output[count++] = acc
            acc = ""
        } else {
            acc = acc c
        }

    }
    output[count++] = acc

}

/^[[:space:]]*[a-zA-Z0-9\_]+\:[[:space:]]*$/ {
    match($0, /^[[:space:]]*/)
    c_level = RLENGTH / 2
    diff = i_level - c_level
    if (diff < -1) {
        report("Extra indentation on line "NR)
    }
    if (c_level == 0) {
        pop(diff + 1)
    } else {
        pop(diff)
    }
    sub(/^[[:space:]]*/, "")
    sub(/:.*$/, "")
    push($0)
    i_level -= diff
}

/^[[:space:]]*[a-zA-Z0-9\_]+\:[[:space:]]*[^[:space:]]+[[:space:]]*$/ {
    match($0, /^[[:space:]]*/)
    c_level = RLENGTH / 2
    diff = i_level - c_level
    if (diff < -1) {
        report("Extra indentation on line "NR)
    }
    sub(/^[[:space:]]*/, "")
    sub(/:[[:space:]]+/, "=")
    sub(/[[:space:]]*$/, "")
    print join_stack() $0
}

/^[[:space:]]*\-/ {
    stack = join_stack()
    indx = list_counter[stack]++

    match($0, /^ */)
    i_level = RLENGTH / 2

    if (indx == 0); i_level++

    sub(/^[[:space:]]*\- /, "")

    sub(/^[[:space:]]*\{/, "")
    sub(/\}[[:space:]]*$/, "")


    safe_split($0, splitted)
    for (v in splitted) {
        gsub(/^[[:space:]]/, "", splitted[v])
        gsub(/[[:space:]]$/, "", splitted[v])

        key=splitted[v]
        val=splitted[v]

        sub(/^[[:space:]]*/, "", key)
        sub(/:.*$/, "", key)

        sub(/^[[:space:]]*[^[:space:]]+:[[:space:]]+\"?/, "", val) # "
        sub(/\"?[[:space:]]*$/, "", val) #"

        print stack "[" indx "]." key "=" val
    }
    delete splitted
}

END	{
    if (force_complete) {
        exit linter_status
    }
}

