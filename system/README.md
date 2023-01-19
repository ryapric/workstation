Workstation system configuration management
===========================================

How to add new init modules
---------------------------

1. Add a new script under `init-modules` that handles the
   installation/configuration logic, wrapped in a shell function.

1. Add a call to that shell function in `main.sh`, invoked by the `run`
   function.

1. Add relevant code to confirm functionality to `verify.sh`.
