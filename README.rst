=====================
Fix React Native Port
=====================
Simple bash script to replace port 8081 with a new one in React Native iOS
projects.

Usage
-----
Run ``fix-rn-port.sh`` without any arguments to see the help text.::

    usage: fix-rn-port.sh -p <new-port> [-o <old-port>] [-d <directory>]

    Replaces the packager port used by React Native IOS.

    required arguments:
      -p    replacement port number

    optional arguments:
      -o    the port number to replace (default 8081)
      -d    the directory to search (default current directory)

How It Works
------------

1. Replace port 8081 with the specified number in the files:
   * RCTWebSocketExecutor.m
   * RCTBridgeDelegate.h
   * RCTBundleURLProvider.m
   * RCTPackagerConnection.m
2. Modify the build script that detects whether or not the package is running
   to look at the new port.
3. Remove node_modules, run npm cache clean, and npm install.

See Also
--------
* https://github.com/webgoudarzi/yoobles/issues/35
