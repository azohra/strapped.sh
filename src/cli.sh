function usage {
    echo -e "\\nUsage: strapped [flags]\\n"
    echo "flags:"
    echo "  -u, --upgrade               upgrade strapped to the latest version"
    echo "  -v, --version               print the current strapped version"
    echo "  -a, --auto                  do not prompt for confirmation"
    echo "  -y, --yml file/url          path to a valid strapped yml config"
    echo "  -l, --lint file             exit after validating a config file"
    echo "  -r, --repo URL              override the default strap repository"
    echo "  -s, --straps string         run a comma-separated subset of the config"
    echo "  -d, --debug                 show command output"
    echo "  -h, --help                  print this message"
    exit "${1:-1}"
}

function upgrade {
    local installer
    installer=$(curl -fsSL https://stay.strapped.azohra.com) || {
        pretty_print ":announce:" "Strapped::Upgrade download failed"
        exit 2
    }
    bash /dev/stdin <<< "${installer}" || {
        pretty_print ":announce:" "Strapped::Upgrade failed"
        exit 2
    }
    pretty_print ":announce:" "Strapped::Upgraded successfully"
    exit 0
}

while [ $# -gt 0 ] ; do
    case "$1" in
    -d|--debug)
        STRAPPED_DEBUG="true"
    ;;
    -u|--upgrade)
        upgrade
    ;;
    -y|--yml)
        yml_location="$2"
        shift # extra value 
    ;;
    -l|--lint)
        # init_parser
        ysh "${2}" > /dev/null
        exit $?
    ;;
    -r|--repo)
        base_repo="$2"
        shift # extra value 
    ;;
    -s|--straps)
        custom_straps="$2"
        shift # extra value 
    ;;
    -a|--auto)
        auto_approve="true"
    ;;
    -v|--version)
        echo "v$VERSION" && exit 0
    ;;
    -h|--help)
        usage 0
    ;;
    -*)
        printf "Unknown option: %s\n" "$1" >&2
        usage 1
    ;;
    esac
    shift
done
