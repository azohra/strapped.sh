function max(a, b) {
    if (a < b) {
        b
    } else {
        a
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

/^[[:space:]]*[a-zA-Z0-9\_]+\:[[:space:]]*$/ {
    match($0, /^[[:space:]]*/)
    c_level = RLENGTH / 2
    diff = i_level - c_level
    if (diff < -1) {
        print "Yaml Syntax Error: Extra indentation on line", NR > "/dev/stderr"
        exit 1
    }
    if (c_level == 0) {
        pop(diff + 1)
    } else {
        pop(diff)
    }
    sub(/^[[:space:]]*/, "")
    sub(/:.*$/, "")
    push($0)
    i_level -= (i_level - c_level)
}

/^[[:space:]]*[a-zA-Z0-9\_]+\:[[:space:]]*[^[:space:]]+[[:space:]]*$/ {
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

    sub(/^\{/, "")
    sub(/\}$/, "")

    split($0, splitted, ",")
    for (v in splitted) {
        gsub(/^[[:space:]]/, "", splitted[v])
        gsub(/[[:space:]]$/, "", splitted[v])

        split(splitted[v], vals, ":")
        gsub(/^[[:space:]]/, "", vals[1])
        gsub(/[[:space:]]$/, "", vlas[1])
        gsub(/^[[:space:]]/, "", vals[2])
        gsub(/[[:space:]]$/, "", vlas[2])

        print stack "[" indx "]." vals[1] "=" vals[2]
    }
}

