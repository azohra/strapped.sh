function push(v) {
    stk[stk_i++] = v
}

function pop(lvls) {
    for (i = 0; i < lvls; i++){
        stk[stk_i--]
    }
}

function join_stack() {
    val = ""
    for (k = stk_i - 1; k >= 0; k--) {
        val = stk[k] "." val
    }
    return val
}

/^[[:space:]]*[a-zA-Z0-9\_]+\:/ {
    match($0, /^[[:space:]]*/)
    c_level = RLENGTH / 2
    pop(i_level - c_level)

    sub(/:\w*$/, "")
    sub(/^[[:space:]]*/, "")
    push($0)

    i_level = c_level
}

/^[[:space:]]*[a-zA-Z0-9\_]+\:.*/ {
    match($0, /^[[:space:]]*/)
    c_level = RLENGTH / 2
    pop(i_level - c_level)

    sub(/^[[:space:]]*/, "")
    sub(/\:[[:space:]]*/, "=")
    gsub(/[[:space:]]$/, "")
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

