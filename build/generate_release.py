# Imports
import sys
import subprocess
import os.path
import hashlib

# Version of this script
version = "0.1.0"

# Function that generates the release
def generate_release(file_path, ver):

    complete_path = file_path + "/strapped.rb"
    release_path = "{}.tar.gz".format(ver)

    if(os.path.isfile(complete_path) == False):
        print('\nError: {} could not be located. Maybe use strapped to install the repo for you? :p').format(complete_path)
        exit(1)

    # Generate the SHA256 HASH OF THE FILE
    buffer_size = 65536
    sha256      = hashlib.sha256()

    with open(release_path, 'rb') as f:
        while True:
            data = f.read(buffer_size)
            if not data:
                break
            sha256.update(data)

    print('2. Generated a SHA256 hash for the release: {}'.format(sha256.hexdigest()))

    # Update the ruby script with path to the new release and its sha256 hash
    # Open the file and read change the required lines
    f = open(complete_path, 'r')
    lines = f.readlines()
    lines[6] = '  url \"https://github.com/azohra/strapped.sh/archive/{}.tar.gz\"\n'.format(ver)
    lines[7] = '  sha256 \"{}\"\n'.format(sha256.hexdigest())
    f.close()

    # Write the line changes back to the file
    f = open(complete_path, 'w')
    f.writelines(lines)
    f.close()

    print('3. Updated the homebrew installer for strapped.sh in: {}'.format(complete_path))


# Displays command-line options
def display_usage():
    print('Usage: python3 generate_release.py [opts] -d ../homebrew-tools')
    print('Required params:')
    print('\t-d <str>        # Specifies the relative location of your azohra/homebrew-tools directory')
    print('\t-t <str>        # Specifies the target version to release')

def keys_present(args, keys):
    return True if any (k in args for k in keys) else False

# Notify the user if they are missing any arguments,
# Yes, this sexy CLI is mine. Yes, you can steal it
def is_missing_fields(args):
    err = False
    err_tracker = []

    required_fields = [
        ('-d', '\t\t-d <str>                 # Specifies the relative location of your azohra/homebrew-tools directory'),
        ('-t', '\t\t-t <str>                 # Specifies the target version to release'),
    ]

    for (field, hint) in required_fields:
        if field not in args:
            err = True
            err_tracker.append(hint)

    if err:
        print("Error:\tInvalid usage, use options -h, --help for usage details")
        print("Hint:\tYou are missing the following fields:")
        for e in err_tracker: print(e)

    return err

def main():
    # Collect command-line args and transform into dictionary
    # Don't feel like being a pro and using getopt because I'm jazzy and we're just
    # gonna have to deal with that fact for the time being, ok?
    args = dict(map(None, *[iter(sys.argv[1:])]*2))

    # Check for -h or -v flags
    if keys_present(args, ('-h', '--help')): display_usage(); return
    if keys_present(args, ('-v', '--version')): print(version); return

    # Verify the presense of required arguments
    if is_missing_fields(args): exit(1)

    # Extract and sanitize arguments
    directory           = args['-d']
    ver                 = args['-t']

    # Generate the release
    generate_release(directory, ver)


if __name__ == '__main__':
    main()