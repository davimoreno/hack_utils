#!/usr/bin/env python3

#
# Prints all bytes from 0-255 (except bad chars) in \xXX format
# Useful for helping to find bad chars during buffer overflow attacks
#
# author: @davimoreno
#

def get_bytearray(badchars):
    # Create string with all bytes thar are not badchars
    list_badchars = list(badchars.encode("latin1"))
    bytearray = "".join([ f"\\x{i:02x}" for i in range(0, 256) if i not in list_badchars])
    return bytearray

def main():
    # Inform all badchars here
    badchars = "\x00\x0a\xff"

    bytearray = get_bytearray(badchars)

    print(bytearray)

if __name__ == "__main__":
    main()
