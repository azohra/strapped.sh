function usage {
    echo -e "\\nUsage: strapped [flags]\\n"
    echo "flags:"
    echo "  -u, --upgrade               upgrade strapped to the latest version"
    echo "  -v, --version               print the current strapped version"
    echo "  -a, --auto                  do not prompt for confirmation"
    echo "  -y, --yml file/url          path to a valid strapped yml config"
    echo "  -l, --lint                  exits after reading config file"
    echo "  -s, --straps string         run a subset of your config. Comma seperated."
    echo "  -h, --help                  prints this message"
    exit 1
}

function upgrade {
    rm /usr/local/bin/strapped
    curl -s https://stay.strapped.sh | sh
    pretty_print ":announce:" "Strapped::Upgraded Successfully!"
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
        echo 'v0.1.3' && exit 0
    ;;
    -h|--help)
        usage
    ;;
    -*)
        "Unknown option: '$1'"
    ;;
    esac
    shift
done
